import 'package:tattoo/domain/repositories/auth/interfaces/auth_interface.dart';

import '../../../../backend/features/auth/implementations/backend_auth.dart';
import '../../../../core/base/models/base_response.dart';

class AuthRepository extends AuthInterface {
  final BackendAuth auth = BackendAuth();

  @override
  Future<BaseResponse> signOut() async {
    BaseResponse baseResponse = await auth.signOut();
    return baseResponse;
  }

  @override
  Future<BaseResponse> getCurrentUser() async {
    BaseResponse baseResponse = await auth.getCurrentUser();
    return baseResponse;
  }
}
