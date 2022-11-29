import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/repositories/auth/implementations/anonymous_auth_implementation.dart';

import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';

class MyAppViewModel extends BaseViewModel {
  MyAppViewModel({required super.context});

  void initAndRemoveSplashScreen() async {
    AnonymousAuthImplementation anonymousAuth = AnonymousAuthImplementation();
    BaseResponse responseModel = await anonymousAuth.signInAnonymously();

    if (responseModel is BaseSuccess) {
      FlutterNativeSplash.remove();
    }
  }

  String getInitialRoute() {
    return RouterConstants.home;
  }
}
