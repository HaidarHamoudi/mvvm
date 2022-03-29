import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvvm/app/app_prefs.dart';
import 'package:mvvm/data/data_source/local_data_source.dart';
import 'package:mvvm/presentation/resources/assets_manager.dart';
import 'package:mvvm/presentation/resources/language_manager.dart';
import 'package:mvvm/presentation/resources/strings_manager.dart';
import 'package:mvvm/presentation/resources/values_manager.dart';
import 'dart:math' as math;

import '../../app/di.dart';
import '../resources/routes_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.p8),
      children: [
        ListTile(
          title: Text(
            AppStrings.changeLanguage,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.changeLangIc),
          trailing: Transform(child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          alignment: Alignment.center, transform: Matrix4.rotationY(isRtl() ? math.pi:0)),
          onTap: () {
            _changeLanguage();
          },
        ),
        ListTile(
          title: Text(
            AppStrings.contactUs,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.contactUsIc),
          trailing: Transform(child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
              alignment: Alignment.center, transform: Matrix4.rotationY(isRtl() ? math.pi:0)),
          onTap: () {
            _contactUs();
          },
        ),
        ListTile(
          title: Text(
            AppStrings.inviteYourFriends,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.inviteFriendsIc),
          trailing: Transform(child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
              alignment: Alignment.center, transform: Matrix4.rotationY(isRtl() ? math.pi:0)),
          onTap: () {
            _inviteFriends();
          },
        ),
        ListTile(
          title: Text(
            AppStrings.logout,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.logoutIc),
          trailing: Transform(child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
              alignment: Alignment.center, transform: Matrix4.rotationY(isRtl() ? math.pi:0)),
          onTap: () {
            _logOut();
          },
        ),
      ],
    );
  }

  bool isRtl(){
    return context.locale == ARABIC_LOCAL; // app is in arabic language
  }

  void _changeLanguage() {
    // I will apply localisation later
    _appPreferences.setLanguageChanged();
    Phoenix.rebirth(context); // restart to apply language changes
  }

  void _contactUs() {
    // it's a task for you to open any web page with dummy content
  }

  void _inviteFriends() {
    // it's a task to share app name with friends
  }

  void _logOut() {
    _appPreferences.logout(); // clear login flag from app prefs
    _localDataSource.clearCache();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }
}

