import 'package:tattoo/domain/models/design-response/design_response_model.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_request_model.dart';

abstract class BackendGetDesignRequestInterface {
  Future<BaseResponse<DesignRequestModel>> getDesignRequest(
    String userId,
  );

  Stream<BaseResponse<List<DesignResponseModel>>> getDesignRequestStream(
    String userId,
  );

  Stream<BaseResponse<List<DesignRequestModel>>>
      getNotFinishedDesignRequestForDesignerStream(
    DesignRequestModel? designRequestModel,
  );
}
