import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tattoo/core/extensions/context_extension.dart';
import 'package:tattoo/core/extensions/widget_extension.dart';
import 'package:tattoo/core/router/core/router_service.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';
import 'package:tattoo/domain/repositories/review/implemantations/review_repository.dart';
import 'package:tattoo/utils/logic/constants/locale/locale_keys.g.dart';
import 'package:tattoo/utils/logic/constants/router/router_constants.dart';
import 'package:tattoo/utils/logic/state/bloc/sign/sign_bloc.dart';
import 'package:tattoo/utils/logic/state/cubit/home-tab/home_tab_cubit.dart';
import 'package:tattoo/utils/ui/constants/colors/app_colors.dart';

import '../../../../utils/logic/helpers/in-app-review/in_app_review_helper.dart';
import 'dialog_action_button.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final bool insufficientBalance;
  final BuildContext buildContext;

  const ErrorDialog({
    Key? key,
    this.message = "",
    this.insufficientBalance = false,
    required this.buildContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondColor,
      actionsPadding: EdgeInsets.zero,
      contentPadding: context.paddingMedium,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        insufficientBalance
            ? Row(
                children: [
                  DialogActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                      BlocProvider.of<HomeTabCubit>(context).changeTab(1);
                      RouterService.instance
                          .popUntil(removeUntilPageName: RouterConstants.home);
                    },
                    child: Text(
                      LocaleKeys.buyCredit.tr(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  DialogActionButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await InAppReviewHelper.instance.request();
                      await ReviewRepository().makeReview(UserModel(
                          id: buildContext
                              .read<SignBloc>()
                              .state
                              .userModel
                              .id));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.evaluate.tr(),
                          style: const TextStyle(color: Colors.black),
                        ),
                        context.widget.horizontalSpace(10),
                        FaIcon(
                          FontAwesomeIcons.star,
                          size: 20,
                          color: Colors.amber.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  DialogActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      LocaleKeys.close.tr(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
