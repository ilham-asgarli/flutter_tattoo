import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../domain/models/design-response/design_response_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/logic/state/cubit/ready/ready_cubit.dart';
import '../../../widgets/blinking_widget.dart';
import '../view-models/ready_view_model.dart';
import 'empty_view.dart';

class ReadyView extends StatefulWidget {
  const ReadyView({Key? key}) : super(key: key);

  @override
  State<ReadyView> createState() => _ReadyViewState();
}

class _ReadyViewState extends State<ReadyView> {
  ReadyViewModel viewModel = ReadyViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SignBloc, SignState>(
        builder: (context, signState) {
          return BlocBuilder<ReadyCubit, ReadyState>(
            builder: (context, readyState) {
              return StreamBuilder<BaseResponse<List<DesignResponseModel>>>(
                stream: viewModel.getDesignRequestRepository
                    .getDesignRequestStream(signState.userModel.id ?? ""),
                builder: (context, snapshot) {
                  BaseResponse<List<DesignResponseModel>>? baseResponse =
                      snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          HexColor("#666666"),
                        ),
                      ),
                    );
                  }

                  if (baseResponse is BaseSuccess<List<DesignResponseModel>>) {
                    List<DesignResponseModel>? designModels = baseResponse.data;
                    if (designModels != null && designModels.isNotEmpty) {
                      return buildImageGrid(designModels);
                    } else {
                      return const EmptyView();
                    }
                  } else {
                    return const EmptyView();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  GridView buildImageGrid(List<DesignResponseModel> designModels) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: designModels.length,
      itemBuilder: (context, index) {
        DesignRequestModel? designRequestModel =
            designModels[index].designRequestModel;
        int imageIndex = designRequestModel?.designRequestImageModels2
                ?.indexWhere((element) => element.name == "1") ??
            0;
        imageIndex = imageIndex >= 0 ? imageIndex : 0;

        return InkWell(
          onTap: () {
            if (designRequestModel?.finished ?? false) {
              RouterService.instance.pushNamed(
                path: RouterConstants.photo,
                data: designModels[index],
              );
            } else {
              RouterService.instance.pushNamed(
                path: RouterConstants.retouch,
                data: designModels[index].designRequestModel,
              );
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildImage(designRequestModel
                      ?.designRequestImageModels2?[imageIndex].link ??
                  ""),
              buildRetouching(designRequestModel?.finished ?? false),
            ],
          ),
        );
      },
    );
  }

  Visibility buildRetouching(bool finished) {
    return Visibility(
      visible: !finished,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
        ),
        child: BlinkingWidget(
          periodDuration: 2,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Image.asset(
              "ic_retouching".toPNG,
              width: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(String link) {
    return CachedNetworkImage(
      imageUrl: link,
      fit: BoxFit.cover,
    );
  }
}
