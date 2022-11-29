import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tattoo/utils/logic/state/cubit/home-tab/home_tab_cubit.dart';

import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../../credits/views/credits_view.dart';
import '../../gallery/views/gallery_view.dart';
import '../../more/views/more_view.dart';
import '../../ready/views/ready_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  final List<Widget> _items = const [
    GalleryView(),
    CreditsView(),
    ReadyView(),
    MoreView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTabCubit, HomeTabState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: _items[state.index],
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 0,
                thickness: 0.15,
              ),
            ],
          ),
          bottomNavigationBar: buildBottomNavigationBar(context, state),
        );
      },
    );
  }

  Widget buildBottomNavigationBar(BuildContext context, HomeTabState state) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: state.index,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        selectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            label: LocaleKeys.homeBottomNavBarLabels_gallery.tr(),
            icon: const FaIcon(FontAwesomeIcons.circlePlus),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.homeBottomNavBarLabels_credits.tr(),
            icon: const FaIcon(
              FontAwesomeIcons.star,
              size: 20,
            ),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.homeBottomNavBarLabels_ready.tr(),
            icon: const FaIcon(FontAwesomeIcons.check),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.homeBottomNavBarLabels_more.tr(),
            icon: const FaIcon(FontAwesomeIcons.ellipsis),
          ),
        ],
        onTap: (index) {
          BlocProvider.of<HomeTabCubit>(context).changeTab(index);
        },
      ),
    );
  }
}
