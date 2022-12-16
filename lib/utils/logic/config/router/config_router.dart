import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tattoo/domain/models/design-response/design_response_model.dart';
import 'package:tattoo/presentation/features/photo/views/photo_view.dart';
import 'package:tattoo/presentation/features/retouch/views/retouch_view.dart';

import '../../../../presentation/features/home/views/home_view.dart';
import '../../../../presentation/features/not-found-navigation/views/not_found_navigation_view.dart';
import '../../../../presentation/features/sign-up-in/views/sign_up_in.dart';
import '../../../../presentation/features/tattoo-choose/views/tattoo_choose_view.dart';
import '../../constants/router/router_constants.dart';
import '../../state/cubit/photo/photo_cubit.dart';
import '../../state/cubit/retouch/retouch_cubit.dart';

class ConfigRouter {
  static final ConfigRouter instance = ConfigRouter._init();

  ConfigRouter._init();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterConstants.home:
        return normalNavigate(
          HomeView(),
          RouterConstants.home,
        );
      case RouterConstants.tattooChoose:
        return normalNavigate(
          TattooChooseView(imageFile: settings.arguments as XFile),
          RouterConstants.tattooChoose,
        );
      case RouterConstants.signUpIn:
        return normalNavigate(
          SignUpIn(),
          RouterConstants.signUpIn,
        );
      case RouterConstants.photo:
        return normalNavigate(
          BlocProvider<PhotoCubit>(
            create: (_) => PhotoCubit(),
            child: PhotoView(
                designModel: settings.arguments as DesignResponseModel),
          ),
          RouterConstants.photo,
        );
      case RouterConstants.retouch:
        return normalNavigate(
          BlocProvider<RetouchCubit>(
            create: (context) => RetouchCubit(),
            child: RetouchView(imageLink: settings.arguments as String?),
          ),
          RouterConstants.retouch,
        );
      default:
        //throw NavigateException<SettingsDynamicModel>(args.arguments);
        return normalNavigate(
          const NotFoundNavigationView(),
          RouterConstants.notFound,
        );
    }
  }

  MaterialPageRoute normalNavigate(Widget widget, String pageName) {
    return MaterialPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(name: pageName),
    );
  }
}
