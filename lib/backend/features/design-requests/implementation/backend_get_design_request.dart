import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/backend/models/design-requests/backend_design_request_model.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/design-request/design_model.dart';

import '../../../models/design-requests/backend_design_response_image_model.dart';
import '../../../utils/constants/firebase/design-request-images/design_requests_collection_constants.dart';
import '../../../utils/constants/firebase/design-requests/design_requests_collection_constants.dart';
import '../interface/backend_get_design_request_interface.dart';

class BackendGetDesignRequest extends BackendGetDesignRequestInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference designRequests = FirebaseFirestore.instance
      .collection(DesignRequestsCollectionConstants.designRequests);
  CollectionReference designRequestImages = FirebaseFirestore.instance
      .collection(DesignRequestImageCollectionConstants.designRequestImages);

  @override
  Future<BaseResponse<DesignModel>> getDesignRequest(String userId) async {
    try {
      DocumentSnapshot designRequestsDocumentSnapshot =
          await designRequests.doc(userId).get();
      Map<String, dynamic>? designRequestsData =
          designRequestsDocumentSnapshot.data() as Map<String, dynamic>?;

      QuerySnapshot designRequestImagesQuerySnapshot = await designRequestImages
          .where("requestId", isEqualTo: designRequestsDocumentSnapshot.id)
          .get();

      List<BackendDesignResponseImageModel> designResponseImageModels = [];
      for (var element in designRequestImagesQuerySnapshot.docs) {
        Map<String, dynamic>? designRequestImagesData =
            element.data() as Map<String, dynamic>?;
        if (designRequestImagesData != null) {
          designResponseImageModels.add(BackendDesignResponseImageModel(
            id: designRequestImagesData["id"],
            requestId: designRequestImagesData["requestId"],
            link: designRequestImagesData["link"],
          ));
        }
      }

      if (designRequestsData != null) {
        return BaseSuccess<DesignModel>(
            data: BackendDesignRequestModel().to(
          model: BackendDesignRequestModel(
            id: designRequestsData["id"],
            userId: designRequestsData["userId"],
            designerId: designRequestsData["designerId"],
            retouchId: designRequestsData["retouchId"],
            previousRequestId: designRequestsData["previousRequestId"],
            finished: designRequestsData["finished"],
            createdDate: designRequestsData["createdDate"],
            designResponseImageModels: designResponseImageModels,
          ),
        ));
      } else {
        return BaseSuccess<DesignModel>(data: DesignModel());
      }
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }

  @override
  Stream<BaseResponse<List<DesignModel>>> getDesignRequestStream(
      String userId) async* {
    try {
      List<DesignModel> designModels = [];
      Stream<QuerySnapshot> designRequestsStream =
          designRequests.where("userId", isEqualTo: userId).snapshots();

      await for (QuerySnapshot designRequestsDocumentSnapshot
          in designRequestsStream) {
        for (var element in designRequestsDocumentSnapshot.docs) {
          Map<String, dynamic>? designRequestsData =
              element.data() as Map<String, dynamic>?;

          QuerySnapshot designRequestImagesQuerySnapshot =
              await designRequestImages
                  .where("requestId", isEqualTo: element.id)
                  .get();

          List<BackendDesignResponseImageModel> designResponseImageModels = [];
          for (var element in designRequestImagesQuerySnapshot.docs) {
            Map<String, dynamic>? designRequestImagesData =
                element.data() as Map<String, dynamic>?;
            if (designRequestImagesData != null) {
              designResponseImageModels.add(
                BackendDesignResponseImageModel(
                  id: designRequestImagesData["id"],
                  requestId: designRequestImagesData["requestId"],
                  link: designRequestImagesData["link"],
                  name: designRequestImagesData["name"],
                ),
              );
            }
          }

          if (designRequestsData != null) {
            designModels.add(
              BackendDesignRequestModel().to(
                model: BackendDesignRequestModel(
                  id: designRequestsData["id"],
                  userId: designRequestsData["userId"],
                  designerId: designRequestsData["designerId"],
                  retouchId: designRequestsData["retouchId"],
                  previousRequestId: designRequestsData["previousRequestId"],
                  finished: designRequestsData["finished"],
                  createdDate: designRequestsData["createdDate"],
                  designResponseImageModels: designResponseImageModels,
                ),
              ),
            );
          }

          yield BaseSuccess<List<DesignModel>>(
            data: designModels,
          );
        }
      }
    } catch (e) {
      yield BaseError(message: e.toString());
    }
  }
}