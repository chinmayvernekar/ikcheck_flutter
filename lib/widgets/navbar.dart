import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/Help/TermsAndConditionScreen.dart';
import 'package:iKCHECK/views/Help/contactScreen.dart';
import 'package:iKCHECK/views/Help/faqScreen.dart';
import 'package:iKCHECK/views/Help/helpScreen.dart';
import 'package:iKCHECK/views/Help/privacyPolicyScreen.dart';
import 'package:iKCHECK/views/RDW/dlLinked.dart';
import 'package:iKCHECK/views/RDW/identityScreen.dart';
import 'package:iKCHECK/views/RDW/unlinkDLScreen.dart';
import 'package:iKCHECK/views/account/changeLanguageScreen.dart';
import 'package:iKCHECK/views/account/changePasswordScreen.dart';
import 'package:iKCHECK/views/account/clearDataAccountScreen.dart';
import 'package:iKCHECK/views/account/deleteAccountScreen.dart';
import 'package:iKCHECK/views/alert/alertNoScreen.dart';
import 'package:iKCHECK/views/alert/alertSentScreen.dart';
import 'package:iKCHECK/views/alert/alertYesScreen.dart';
import 'package:iKCHECK/views/alert/handledAlertScreen.dart';
import 'package:iKCHECK/views/home/accountScreen.dart';
import 'package:iKCHECK/views/home/fraudHelpScreen.dart';
import 'package:iKCHECK/views/home/victimSupportScreen.dart';
import 'package:iKCHECK/views/messages/messageScreen.dart';
import 'package:iKCHECK/views/monitoring/breachesFound.dart';
import 'package:iKCHECK/views/monitoring/monitorActivities.dart';
import 'package:iKCHECK/views/monitoring/monitoringIntro.dart';
import 'package:iKCHECK/views/monitoring/screen3.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/globalFunctions.dart';
import '../Utils/globalVariables.dart';
import '../views/account/changeEmailScreen.dart';
import '../views/account/personalDataScreen.dart';
import '../views/alert/checkAlertScreen.dart';
import '../views/alert/hadledAlertViewScreen.dart';
import '../views/home/alertScreen.dart';
import '../views/home/dashboardScreen.dart';
import '../views/messages/messageView.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

String userEmail = "";

class NavbarScreen extends StatefulWidget {
  bool greenStrip = false;
  String? userId;
  int selectedPageIndex = 0;
  String apiCallString = '';
  Map? apiData = {};
  int? msgIndex = -1;

  NavbarScreen(
      {this.userId,
      this.selectedPageIndex = 0,
      this.apiCallString = '',
      this.apiData,
      this.msgIndex,
      this.greenStrip = false});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class InnerPage {
  Widget page;
  String title;
  InnerPage(
    this.page,
    this.title,
  );
}

class _NavbarScreenState extends State<NavbarScreen> {
  List<InnerPage> _pages = [];
// bool isLoading = false;
  static String routeName = '/navbar-screen';
  int webViewIndex = -1;

  Future getMonetringStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("user_email")) {
      setState(() {
        userEmail = prefs.getString("user_email")!;
      });
    }
    // if(prefs.containsKey("alertsOnOf")){
    //   bool tempAlert = prefs.getBool("alertsOnOf")!;
    //   Provider.of<MainProvider>(context,listen: false).setdataletvalue(tempAlert);
    // }else{
    //   print("datalet variable not exist");
    //   Provider.of<MainProvider>(context,listen: false).setdataletvalue(false);
    // }
    if (prefs.containsKey("isFirstTime")) {
      bool tempUser = prefs.getBool("isFirstTime")!;
      Provider.of<MainProvider>(context, listen: false).setfirstUser(tempUser);
    } else {
      Provider.of<MainProvider>(context, listen: false).setfirstUser(true);
    }
  }

  @override
  void initState() {
    // Timer.run(() {
    //   Provider.of<MainProvider>(context,listen:false).setselectedIndex(0);
    // });
    getMonetringStatus();
    // Consumer<MainProvider>(
    //    builder: (context, value, child) {
    //      List alertList = (value.enquiryItems.isNotEmpty &&
    //          value.enquiryItems['items'] != null)
    //          ? value.enquiryItems['items']
    //          : [];
    //
    //    });
    globelContext = context;

    _pages = [
      //0
      InnerPage(DashBoardScreen(), 'Home'),
      //1
      InnerPage(MessageScreen(), LocaleKeys.DASHBOARD_MESSAGES.tr()),
      //2
      InnerPage(AccountScreen(), LocaleKeys.DASHBOARD_ACCOUNT.tr()),
      //3
      InnerPage(AlertScreen(), LocaleKeys.DASHBOARD_ALERTS.tr()),
      //4
      InnerPage(IdentityPage(), LocaleKeys.DASHBOARD_IDENTITIES.tr()),
      // 5
      InnerPage(
          UnlinkDriverLicenseScreen(), LocaleKeys.DASHBOARD_IDENTITIES.tr()),
      // 6
      InnerPage(RDWDLlinkedScreen(), LocaleKeys.DASHBOARD_IDENTITIES.tr()),
      // 7
      InnerPage(CheckAlert(), LocaleKeys.NAVBARCONTENT_CHECKALERTS.tr()),
      // 8
      InnerPage(AlertYES(), LocaleKeys.NAVBARCONTENT_CHECKALERTS.tr()),
      // 9
      InnerPage(AlertNo(), LocaleKeys.NAVBARCONTENT_CHECKALERTS.tr()),
      // 10
      InnerPage(AlertSent(), LocaleKeys.NAVBARCONTENT_CHECKALERTS.tr()),
      // 11
      InnerPage(
          HandledAlertScreen(), LocaleKeys.NAVBARCONTENT_HANDLEDALERTS.tr()),
      //12
      InnerPage(
          HandledAlertView(), LocaleKeys.NAVBARCONTENT_HANDLEDALERTS.tr()),
      //13
      InnerPage(
          PersonalDataScreen(), LocaleKeys.NAVBARCONTENT_PERSONALDATA.tr()),
      //14
      InnerPage(ChangeEmailScreen(), LocaleKeys.NAVBARCONTENT_EMAIL.tr()),
      //15
      InnerPage(FraudHelpDesk(), LocaleKeys.NAVBARCONTENT_FRAUDHELPDESK.tr()),
      //16
      InnerPage(
          VictimSupportScreen(), LocaleKeys.NAVBARCONTENT_VICTIMSUPPORT.tr()),
      //17
      InnerPage(
          MessageView(widget.msgIndex), LocaleKeys.DASHBOARD_MESSAGES.tr()),
      // 18
      InnerPage(const ChangePasswordScreen(),
          LocaleKeys.ACCOUNT_PASSWORD_PASSWORD.tr()),
      // 19
      InnerPage(const DeleteAccountScreen(),
          LocaleKeys.ACCOUNT_DELETEACCOUNT_DELETEACCOUNT.tr()),
      // 20
      InnerPage(const ClearDataAccountScreen(),
          LocaleKeys.ACCOUNT_CLEARDATA_CLEARDATA.tr()),
      // 21
      InnerPage(HelpScreen(), LocaleKeys.HELP_HELP.tr()),
      // 22
      InnerPage(FAQ(), LocaleKeys.HELP_FAQHEADER.tr()),
      // 23
      InnerPage(ContactScreen(), LocaleKeys.COMMON_CONTACT.tr()),
      //24
      InnerPage(
          TermsAndConditionScreen(), LocaleKeys.HELP_TERMSANDCONDITIONS.tr()),
      //25
      InnerPage(PrivacyPolicyScreen(), LocaleKeys.HELP_PRIVACYPOLICY.tr()),
      //26
      InnerPage(ChangeLanguageScreen(), LocaleKeys.COMMON_LANGUAGE.tr()),
      //27
      InnerPage(MonitoringScreen(), "Monitoring"),
      //28
      InnerPage(MonitoringScreen2(greenStrip: widget.greenStrip), "Monitoring"),
      //29
      InnerPage(BreachesFound(), "Monitoring"),
      //30
      InnerPage(MonitoringScreen3(), "Monitoring"),
    ];
    //_controller.index = navSelectedIndex;
    // if(navSelectedIndexGlobal<4){
    //   _controller.index = navSelectedIndexGlobal;
    // }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<MainProvider>(context, listen: false).setselectedIndex(0);
      await removeString('EMAIL_FOR_IPAD');
      await removeString('PATH_FOR_IPAD');
      // setState(() {
      if (Provider.of<MainProvider>(context, listen: false).accStripBool) {
        Provider.of<MainProvider>(context, listen: false)
            .setAccStrip(false, false, '');
      }
      if (widget.apiCallString == 'stripClearDataRoute') {
        // Provider.of<MainProvider>(context, listen: false)
        //     .setAccStrip(true, true, LocaleKeys.ACCOUNT_DATACLEARED.tr());
      }
      Provider.of<MainProvider>(context, listen: false).setLoaderStatus(true);
      Provider.of<MainProvider>(context, listen: false)
          .setLoaderAlertStatus(true);
      Provider.of<MainProvider>(context, listen: false)
          .setLoaderMsgStatus(true);

      // isLoading = true;
      // });
      String firstTimeUser = await getString('firstTimeUser') ?? '';
      if (firstTimeUser == '') {
        await storeString('firstTimeUser', 'NO');
      }

      String firstTimeIdentity = await getString('firstTimeIdentity') ?? '';
      if (firstTimeIdentity == '') {
        await storeString('firstTimeUser', 'NO');
      }

      String cacheDataNotificationAndDeeplinkMap =
          await getString('cacheDataNotificationAndDeeplink') ?? '';
      Map cacheDataNotificationAndDeeplink = {};
      if (cacheDataNotificationAndDeeplinkMap.isNotEmpty) {
        cacheDataNotificationAndDeeplink =
            json.decode(cacheDataNotificationAndDeeplinkMap);
      }
      if (cacheDataNotificationAndDeeplink.isNotEmpty) {
        await ApiCallManagement().getDashboardDetails(context);
        routingFunctionForNotificationAndDeeplink(
            cacheDataNotificationAndDeeplink, context);
        await removeString('cacheDataNotificationAndDeeplink');
      } else if (widget.apiCallString == 'getDashboardDetails') {
        // await ApiCallManagement().getDashboardDetails(context);
      } else if (widget.apiCallString == 'getIdentityStatus') {
        // await ApiCallManagement().getIdentityStatus(context);
      } else if (widget.apiCallString == 'getEnquiryDetails') {
        // Provider.of<MainProvider>(context, listen: false)
        //     .setLoaderAlertStatus(true);
        // await ApiCallManagement()
        //     .getIdentityEnquiryDetails(context, widget.apiData, '');
        // Provider.of<MainProvider>(context, listen: false)
        //     .setLoaderAlertStatus(false);
      } else if (widget.apiCallString == 'getPickEnquiryDetails') {
        // await ApiCallManagement()
        //     .getIdentityEnquiryDetails(context, widget.apiData, 'pickedAlert');
      } else if (widget.apiCallString == 'getHandledAlertEnquiryItems') {
        // await ApiCallManagement().getIdentityEnquiryDetails(
        //   context,
        //   widget.apiData,
        //   'handledAlertEnquiryItems',
        // );
      } else if (widget.apiCallString == 'pickedhandledAlertEnquiryItems') {
        // await ApiCallManagement().getIdentityEnquiryDetails(
        //   context,
        //   widget.apiData,
        //   'pickedhandledAlertEnquiryItems',
        // );
      } else if (widget.apiCallString == 'getAccountDetails') {
        // await ApiCallManagement().getAccountDetails(
        //   context,
        // );
      } else if (widget.apiCallString == 'deletedRouteAlert') {
        String userId = await getString('US_user_id') ?? '';
        Map object = {
          'alertId': 0,
          'content': null,
          'fromDate': null,
          'page': 1,
          'read': null,
          'sort': "Date time",
          'source': null,
          'status': "To Be Attended",
          'toDate': null,
          'type': null,
          'userId': userId,
        };
        await ApiCallManagement()
            .getIdentityEnquiryDetails(context, object, '');
      } else if (widget.apiCallString == 'getMessagesUserNewsApi') {
        // Provider.of<MainProvider>(context, listen: false)
        //     .setLoaderMsgStatus(true);
        // await ApiCallManagement().getMessagesUserNewsApi(context, 1);
        // Provider.of<MainProvider>(context, listen: false)
        //     .setLoaderMsgStatus(false);
      }

      // setState(() {
      Provider.of<MainProvider>(context, listen: false).setLoaderStatus(false);
      Provider.of<MainProvider>(context, listen: false)
          .setLoaderAlertStatus(false);
      Provider.of<MainProvider>(context, listen: false)
          .setLoaderMsgStatus(false);

      // isLoading = false;
      // });
    });

    // Timer.run(() {
    //   pushNewScreen(
    //     context,
    //     screen: _pages[navSelectedIndex].page,
    //     withNavBar: true,
    //     pageTransitionAnimation: PageTransitionAnimation.cupertino,
    //   );
    // });
  }

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  bool shouldPop = true;
  @override
  Widget build(BuildContext context) {
    // Value =   Provider.of<MainProvider>(context,listen:false).selectedIndex;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          body: Consumer<MainProvider>(builder: (context, value, child) {
            return PersistentTabView(
              context,
              onItemSelected: (int index) async {
                value.setselectedIndex(index);
                if (index == 1) {
                  Provider.of<MainProvider>(context, listen: false)
                      .setLoaderMsgStatus(true);
                  await ApiCallManagement().getMessagesUserNewsApi(context, 1);
                  Provider.of<MainProvider>(context, listen: false)
                      .setLoaderMsgStatus(false);
                }

                if (index == 2) {
                  if (Provider.of<MainProvider>(context, listen: false)
                      .accStripBool) {
                    Provider.of<MainProvider>(context, listen: false)
                        .setAccStrip(false, false, '');
                  }
                }
                if (index == 3) {
                  Provider.of<MainProvider>(context, listen: false)
                      .setLoaderAlertStatus(true);
                  String userId = await getString('US_user_id') ?? '';

                  Map object = {
                    'alertId': 0,
                    'content': null,
                    'fromDate': null,
                    'page': 1,
                    'read': null,
                    'sort': "Date time",
                    'source': null,
                    'status': "To Be Attended",
                    'toDate': null,
                    'type': null,
                    'userId': userId,
                  };
                  await ApiCallManagement()
                      .getIdentityEnquiryDetails(context, object, '');
                  Provider.of<MainProvider>(context, listen: false)
                      .setLoaderAlertStatus(false);
                }
              },
              controller: _controller,
              screens: _buildScreens(),
              navBarHeight: 82.sp,
              items: _navBarsItems(value.selectedIndex),
              confineInSafeArea: true,
              backgroundColor: Colors.white, // Default is Colors.white.
              handleAndroidBackButtonPress: true, // Default is true.
              resizeToAvoidBottomInset:
                  true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: false, // Default is true.
              hideNavigationBarWhenKeyboardShows:
                  true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: const NavBarDecoration(
                //borderRadius: BorderRadius.circular(10.0),
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(10),
                //   topRight: Radius.circular(10),
                // ),
                border: Border(
                  top: BorderSide(
                    color: Color(0xffE8E8E8),
                    width: 1,
                  ),
                ),
                colorBehindNavBar: Colors.white,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
              ),
              margin: EdgeInsets.only(top: 50),

              screenTransitionAnimation: ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 1),
              ),
              navBarStyle: NavBarStyle
                  .style8, // Choose the nav bar style with this property.
            );
          }),
        )
      ],
    );
  }
}

Border customBorder(int pageIndex, int selectedPageIndex) {
  if (pageIndex == selectedPageIndex) {
    return Border(
        bottom: BorderSide(
      color: Colors.transparent,
      // style:
      // width: 0.5.w,
    ));
  } else {
    return Border(
      bottom: BorderSide.none,
    );
  }
}

List<PersistentBottomNavBarItem> _navBarsItems(int navSelectedIndex) {
  return [
    PersistentBottomNavBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0),
            child: SvgPicture.asset(
              'assets/svgs/dashboard.svg',
              color: customColor(0, navSelectedIndex),
              fit: BoxFit.scaleDown,
              height: 36.h,
            ),
            // color: custimC,/*  */
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            child: Text(
              LocaleKeys.DASHBOARD_DASHBOARD.tr(),
              style: 0 == navSelectedIndex
                  ? AppFont.iconLabel.copyWith(color: AppColors.primary)
                  : AppFont.iconLabel.copyWith(
                      color: AppColors.unselectedIcon,
                    ),
            ),
          ),
        ],
      ),
      //title: ("Dashboard"),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      //icon: Icon(Icons.mail_outline,size: 45),
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<MainProvider>(
            builder: (context, value, child) {
              bool badgeValue = checkingForUnreadMessage(
                value.dashboardDetails,
                context,
              );
              return Badge(
                animationDuration: Duration.zero,
                elevation: 0,
                showBadge: badgeValue,
                badgeColor: Color.fromARGB(255, 232, 45, 45),
                position: BadgePosition.topEnd(
                  top: MediaQuery.of(context).size.height * 0.001,
                  end: SCREENWIDTH.w * 0.06,
                ),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 0),
                  child: SvgPicture.asset(
                    'assets/svgs/mail.svg',
                    color: customColor(1, navSelectedIndex),
                    fit: BoxFit.scaleDown,
                    height: 36.h,
                  ),
                  // color: custimC,/*  */
                ),
              );
            },
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            child: Text(LocaleKeys.DASHBOARD_MESSAGES.tr(),
                style: 1 == navSelectedIndex
                    ? AppFont.iconLabel.copyWith(color: AppColors.primary)
                    : AppFont.iconLabel
                        .copyWith(color: AppColors.unselectedIcon)),
          ),
        ],
      ),
      // title: ("Messages"),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      //icon: Icon(CupertinoIcons.person,size: 40),
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0),
            child: SvgPicture.asset(
              'assets/svgs/account.svg',
              color: customColor(2, navSelectedIndex),
              fit: BoxFit.scaleDown,
              height: 36.h,
            ),
            // color: custimC,/*  */
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            child: Text(LocaleKeys.DASHBOARD_ACCOUNT.tr(),
                style: 2 == navSelectedIndex
                    ? AppFont.iconLabel.copyWith(color: AppColors.primary)
                    : AppFont.iconLabel
                        .copyWith(color: AppColors.unselectedIcon)),
          ),
        ],
      ),
      //title: ("Account"),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<MainProvider>(
            builder: (context, value, child) {
              bool badgeValue = showingBadgeBasedonDashboardApi(
                value.dashboardDetails,
                context,
              );
              return Badge(
                elevation: 0,
                animationDuration: Duration.zero,
                showBadge: badgeValue,
                badgeColor: Color.fromARGB(255, 232, 45, 45),
                position: BadgePosition.topEnd(
                  top: MediaQuery.of(context).size.height * 0.001,
                  end: SCREENWIDTH.w * 0.08,
                ),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 0),
                  child: SvgPicture.asset(
                    'assets/svgs/alerts.svg',
                    color: customColor(3, navSelectedIndex),
                    fit: BoxFit.scaleDown,
                    height: 36.h,
                  ),
                  // color: custimC,/*  */
                ),
              );
            },
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            child: Text(LocaleKeys.DASHBOARD_ALERTS.tr(),
                style: 3 == navSelectedIndex
                    ? AppFont.iconLabel.copyWith(color: AppColors.primary)
                    : AppFont.iconLabel
                        .copyWith(color: AppColors.unselectedIcon)),
          ),
        ],
      ),
      // icon: Icon(CupertinoIcons.bell,size: 40),
      // title: ("Alerts"),
      iconSize: 20.h,
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];
}

List<Widget> _buildScreens() {
  return [
    DashBoardScreen(),
    MessageScreen(),
    AccountScreen(),
    AlertScreen(),
  ];
}

Color customColor(int pageIndex, int selectedPageIndex) {
  if (pageIndex == selectedPageIndex) {
    return AppColors.primary;
  } else {
    return AppColors.unselectedIcon.withOpacity(0.5);
  }
}

Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
  return Container(
    alignment: Alignment.center,
    height: 60.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: IconTheme(
            data: IconThemeData(
                size: 26.0,
                color: isSelected
                    ? (item.activeColorSecondary == null
                        ? item.activeColorPrimary
                        : item.activeColorSecondary)
                    : item.inactiveColorPrimary == null
                        ? item.activeColorPrimary
                        : item.inactiveColorPrimary),
            child: item.icon,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Material(
            type: MaterialType.transparency,
            child: FittedBox(
                child: Text(
              item.title!,
              style: TextStyle(
                  color: isSelected
                      ? (item.activeColorSecondary == null
                          ? item.activeColorPrimary
                          : item.activeColorSecondary)
                      : item.inactiveColorPrimary,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0),
            )),
          ),
        )
      ],
    ),
  );
}
