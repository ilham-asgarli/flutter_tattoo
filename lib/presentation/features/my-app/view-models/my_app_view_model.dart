import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/repositories/auth/implementations/auth_repository.dart';
import '../../../../domain/repositories/auth/implementations/auto_auth_repository.dart';
import '../../../../domain/repositories/auth/implementations/email_auth_repository.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class MyAppViewModel extends BaseViewModel {
  AutoAuthRepository autoAuthRepository = AutoAuthRepository();
  AuthRepository authRepository = AuthRepository();
  EmailAuthRepository emailAuthRepository = EmailAuthRepository();

  void initAndRemoveSplashScreen(BuildContext context) async {
    SignBloc signBloc = BlocProvider.of<SignBloc>(context);
    if (signBloc.state is SignIn) {
      if (emailAuthRepository.emailVerified()) {
        await onSignedInWithEmail(context);
      } else {
        await onNotSignedInWithEmail(context);
      }
    }
  }

  Future<void> onNotSignedInWithEmail(BuildContext context) async {
    SignBloc signBloc = BlocProvider.of<SignBloc>(context);
    UserModel userModel = signBloc.state.userModel;

    if (userModel.id != null && userModel.id!.isNotEmpty) {
      BaseResponse baseResponse = await autoAuthRepository
          .updateLastAppEntryDate(UserModel(id: userModel.id));

      if (baseResponse is BaseSuccess) {
        BaseResponse<UserModel> userBaseResponse =
            await autoAuthRepository.getUserWithId(userModel.id!);
        if (userBaseResponse is BaseSuccess<UserModel>) {
          signBloc.add(RestoreSignInEvent(
              restoreSignInUserModel: userBaseResponse.data!));
          FlutterNativeSplash.remove();
        }
      }
    } else {
      BaseResponse<UserModel> baseResponse =
          await autoAuthRepository.createUser();

      if (baseResponse is BaseSuccess<UserModel>) {
        signBloc.add(
            RestoreSignInEvent(restoreSignInUserModel: baseResponse.data!));
        FlutterNativeSplash.remove();
      }
    }
  }

  Future<void> onSignedInWithEmail(BuildContext context) async {
    SignBloc signBloc = BlocProvider.of<SignBloc>(context);
    BaseResponse<UserModel> userResponse = authRepository.getCurrentUser();

    if (userResponse is BaseSuccess<UserModel>) {
      BaseResponse baseResponse = await autoAuthRepository
          .updateLastAppEntryDate(UserModel(id: userResponse.data?.id));

      if (baseResponse is BaseSuccess) {
        signBloc.add(const ChangeSignInStatusEvent());
        FlutterNativeSplash.remove();
      }
    }
  }

  String getInitialRoute() {
    return RouterConstants.home;
  }
}
