import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:badges/badges.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/Help/helpScreen.dart';
import 'package:iKCHECK/views/RDW/dlLinked.dart';
import 'package:iKCHECK/views/RDW/identityScreen.dart';
import 'package:iKCHECK/views/home/accountScreen.dart';
import 'package:iKCHECK/views/home/alertScreen.dart';
import 'package:iKCHECK/views/home/fraudHelpScreen.dart';
import 'package:iKCHECK/views/home/victimSupportScreen.dart';
import 'package:iKCHECK/views/monitoring/monitorActivities.dart';
import 'package:iKCHECK/views/monitoring/monitoringIntro.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/styles.dart';
import '../../widgets/loader.dart';

class DashBoardScreen extends StatefulWidget {
  String? userId;

  DashBoardScreen({this.userId});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  bool identityBool = false;
  bool monitoringloading = false;
  bool identityloading = false;
  bool isProcessingMonitoring = false;
  bool alertloading = false;

  late Animation<Offset> animation;
  late AnimationController animationController;

  // bool isNewAlert = false;
  // bool loadingAlert = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        userNameGlobel = await getString('userid') ?? '';
        setState(() {
          userNameGlobel;
        });
      },
    );

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    getData();
    super.initState();
  }

  Future getData() async {
    await ApiCallManagement().getDashboardDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: WillPopScope(
        onWillPop: () {
          print('hello Renu');
          exit(0);
        },
        child: SafeArea(
          bottom: true,
          top: true,
          child: Stack(
            children: [
              Container(
                height: SCREENHEIGHT.h,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(left: 23.w, right: 23.w, top: 16.h),
                  // child: RefreshIndicator(
                  // color: AppColors.primary,
                  // onRefresh: () async {
                  //   var navigator = Navigator.of(context);
                  //   var route = PageRouteBuilder(
                  //     pageBuilder: (context, animation1, animation2) =>
                  //         NavbarScreen(apiCallString: 'getDashboardDetails'),
                  //     transitionDuration: Duration.zero,
                  //     reverseTransitionDuration: Duration.zero,
                  //   );
                  //   navigator.pushAndRemoveUntil(route, (Route<dynamic> route) {
                  //     return route.isFirst;
                  //   });

                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     'home', (Route<dynamic> route) => false);
                  // },
                  child: ListView(
                    children: [
                      Container(
                        height: 100.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Provider.of<MainProvider>(context,
                                        listen: false)
                                    .setselectedIndex(2);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AccountScreen()));
                                // pushNewScreen(
                                //   context,
                                //   screen:AccountScreen() ,
                                //   withNavBar: true, // OPTIONAL VALUE. True by default.
                                //   //pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                // );
                                await ApiCallManagement()
                                    .getMessagesUserNewsApi(context, 1);
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/profile.svg',
                                color: AppColors.primaryLight,
                                height: 55.h,
                              ),
                            ),
                            // SizedBox(
                            //   width: 2,
                            // ),
                            Spacer(
                              flex: 2,
                            ),
                            Column(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 5.sp),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${LocaleKeys.DASHBOARD_HELLO.tr()},',
                                    style: AppFont.normal.copyWith(
                                      // height: 1,
                                      color: AppColors.black2,
                                    ),
                                  ),
                                ),
                                // userNameGlobel.length>6?
                                // Text(
                                //   '$userNameGlobel'.substring(0,6) +"...!",
                                //   style: AppFont.H1.copyWith(height: 1),
                                //   overflow: TextOverflow.ellipsis,
                                // ):
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    '$userNameGlobel!',
                                    style: AppFont.H1.copyWith(height: 1),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(
                              flex: 18,
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(
                                //   SliderTransition(
                                //     NavbarScreen(
                                //       selectedPageIndex: 21,
                                //     ),
                                //   ),
                                // );
                                pushNewScreen(
                                  context,
                                  screen: HelpScreen(),
                                  withNavBar:
                                      true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/question.svg',
                                height: 50.h,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Provider.of<MainProvider>(context).isLoading
                          ? buildSkeletonAnimation()
                          : Consumer<MainProvider>(
                              builder: (context, value, child) {
                                try {
                                  bool boolValue =
                                      showingBadgeBasedonDashboardApi(
                                    value.dashboardDetails,
                                    context,
                                  );
                                } catch (e) {}
                                bool boolValue =
                                    showingBadgeBasedonDashboardApi(
                                  value.dashboardDetails,
                                  context,
                                );
                                return Visibility(
                                  visible: boolValue,
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        alertloading = true;
                                      });
                                      String userId =
                                          await getString('US_user_id') ?? '';
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
                                          .getIdentityEnquiryDetails(
                                              context, object, '');

                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .setselectedIndex(3);

                                      pushNewScreen(
                                        context,
                                        screen: AlertScreen(),
                                        withNavBar: true,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                      setState(() {
                                        alertloading = false;
                                      });
                                    },
                                    child: Container(
                                      height: 110.h,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.sp, horizontal: 9.sp),
                                      width: SCREENWIDTH.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Spacer(),

                                          SizedBox(
                                            width: 55.sp,
                                            child: SvgPicture.asset(
                                              'assets/svgs/warningAlert.svg',
                                            ),
                                          ),
                                          Spacer(),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                LocaleKeys
                                                    .ALERTMESSAGE_YOUHAVERECEIVEDANALERT
                                                    .tr(),
                                                softWrap: true,
                                                style: AppFont.messageSubtitle
                                                    .copyWith(
                                                  color: AppColors.clearWhite,
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                LocaleKeys
                                                    .ALERTMESSAGE_PLEASEREVIEW
                                                    .tr(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFont.messageSubtitle
                                                    .copyWith(
                                                  color: AppColors.clearWhite,
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          alertloading
                                              ? LoadingAnimationWidget
                                                  .prograssiveDots(
                                                  color: AppColors.clearWhite,
                                                  size: 30.sp,
                                                )
                                              : Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: AppColors.clearWhite,
                                                  size: 30.sp,
                                                ),
                                          Spacer(),

                                          // SizedBox(
                                          //   width: 15.w,
                                          // ),
                                        ],
                                      ),

                                      // child: ListTile(
                                      //   dense: false,
                                      //   onTap: () async {
                                      //     String userId =
                                      //         await getString('US_user_id') ?? '';
                                      //     Map object = {
                                      //       'alertId': 0,
                                      //       'content': null,
                                      //       'fromDate': null,
                                      //       'page': 1,
                                      //       'read': null,
                                      //       'sort': "Date time",
                                      //       'source': null,
                                      //       'status': "To Be Attended",
                                      //       'toDate': null,
                                      //       'type': null,
                                      //       'userId': userId,
                                      //     };

                                      //     Navigator.push(
                                      //       context,
                                      //       SliderTransition(
                                      //         NavbarScreen(
                                      //           selectedPageIndex: 3,
                                      //           apiCallString: 'getEnquiryDetails',
                                      //           apiData: object,
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      //   minLeadingWidth: 10,
                                      //   contentPadding: EdgeInsets.symmetric(
                                      //       vertical: 5.sp, horizontal: 14.sp),
                                      //   leading: Padding(
                                      //     padding: const EdgeInsets.all(0.0),
                                      //     child: SvgPicture.asset(
                                      //       'assets/svgs/warning.svg',
                                      //       fit: BoxFit.fitHeight,
                                      //       height: 40.h,
                                      //     ),
                                      //   ),
                                      //   // Icon(
                                      //   //   Icons.warning_rounded,
                                      //   //   color: Colors.white,
                                      //   //   size: 50,
                                      //   // ),
                                      //   trailing: Icon(
                                      //     Icons.arrow_forward_ios_rounded,
                                      //     color: AppColors.clearWhite,
                                      //     size: 40.h,
                                      //   ),

                                      //   title: Text(
                                      //     LocaleKeys.ALERTMESSAGE_YOUHAVERECEIVEDANALERT
                                      //         .tr(),
                                      //     softWrap: true,
                                      //     style: AppFont.messageSubtitle.copyWith(
                                      //       color: AppColors.clearWhite,
                                      //       fontSize: 16.sp,
                                      //       fontWeight: FontWeight.w500,
                                      //     ),
                                      //   ),
                                      //   subtitle: Text(
                                      //     LocaleKeys.ALERTMESSAGE_PLEASEREVIEW.tr(),
                                      //     maxLines: 1,
                                      //     overflow: TextOverflow.ellipsis,
                                      //     style: AppFont.messageSubtitle.copyWith(
                                      //       color: AppColors.clearWhite,
                                      //       fontSize: 16.sp,
                                      //       fontWeight: FontWeight.w500,
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      SizedBox(
                        height: 30.h,
                      ),
                      // Text(
                      //   LocaleKeys.DASHBOARD_DASHBOARD.tr(),
                      //   style: AppFont.normal.copyWith(
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      monitoringloading || identityloading
                          ? Container(
                              height: SCREENHEIGHT.h,
                              child: Center(
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 26.0,
                                  mainAxisSpacing: 20.0,
                                  children: List.generate(4, (index) {
                                    return buildSkeletonAnimationDashboard();
                                  }),
                                ),
                              ),
                            )
                          : GridView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                crossAxisCount: 2,
                              ),
                              children: [
                                GridItem(
                                  iconHeight: 64.h,
                                  title:
                                      LocaleKeys.DASHBOARD_FRAUDHELPDESK.tr(),
                                  svgName: 'helpdesk',
                                  onTap: () {
                                    pushNewScreen(
                                      context,
                                      screen: FraudHelpDesk(),
                                      withNavBar:
                                          true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  showBadge: false,
                                ),
                                GridItem(
                                  iconHeight: 64.h,
                                  title: LocaleKeys.DASHBOARD_IDENTITIES.tr(),
                                  svgName: 'identity',
                                  onTap: () async {
                                    setState(() {
                                      identityloading = true;
                                    });
                                    if (await getString('firstTimeIdentity') !=
                                        'NO') {
                                      await storeString(
                                          'firstTimeIdentity', 'NO');
                                    }
                                    if (await getString('firstTimeUser') ==
                                        'YES') {
                                      pushNewScreen(
                                        context,
                                        screen: IdentityPage(),
                                        withNavBar:
                                            true, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    } else {
                                      await ApiCallManagement()
                                          .getIdentityStatus(context);
                                      // String identityLicenseStatus =
                                      //     Provider.of<MainProvider>(context, listen: false)
                                      //             .identityStatus['status'] ??
                                      //         '';
                                      // if (identityLicenseStatus.isEmpty) {
                                      //   Navigator.push(
                                      //     context,
                                      //     SliderTransition(
                                      //       NavbarScreen(selectedPageIndex: 4),
                                      //     ),
                                      //   );
                                      // } else {
                                      String userId =
                                          await getString('US_user_id') ?? '';

                                      Map object = {
                                        'alertId': 0,
                                        'content': null,
                                        'fromDate': null,
                                        'page': 1,
                                        'read': null,
                                        'sort': "Date time",
                                        'source': "RDW",
                                        'status': null,
                                        'toDate': null,
                                        'type': null,
                                        'userId': userId,
                                      };

                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .setLoaderAlertStatus(true);
                                      await ApiCallManagement()
                                          .getIdentityEnquiryDetails(
                                              context, object, '');
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .setLoaderAlertStatus(false);

                                      pushNewScreen(
                                        context,
                                        screen: RDWDLlinkedScreen(),
                                        withNavBar:
                                            true, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    }
                                    setState(() {
                                      identityloading = false;
                                    });
                                  },
                                  showBadge: true,
                                ),
                                GridItem(
                                  iconHeight: 75.h,
                                  title: LocaleKeys.MONITORING_MONITORING.tr(),
                                  svgName: 'Vector',
                                  onTap: () async {
                                    try {
                                      setState(() {
                                        monitoringloading = true;
                                      });
                                      print(
                                          "ismonitoring $isProcessingMonitoring");
                                      var resp = await ApiCallManagement()
                                          .getSubscriptionDetails(context);
                                      print("resp $resp");
                                      setState(() {
                                        lastScanId = resp["lastScan"];
                                        buttonStatus = resp["subscription"];
                                        if (buttonStatus.toString() == "1") {
                                          Provider.of<MainProvider>(context,
                                                  listen: false)
                                              .setdataletvalue(true);
                                        } else {
                                          Provider.of<MainProvider>(context,
                                                  listen: false)
                                              .setdataletvalue(false);
                                        }
                                        print(
                                            "buttonstatus ${buttonStatus.runtimeType}");
                                        if (!(resp["info"] == null)) {
                                          emailInfoMonitoring =
                                              resp["info"].toString();
                                        } else {
                                          emailInfoMonitoring = userEmail;
                                        }
                                      });
                                      var subscription = resp["subscription"];
                                      var subscriptionId =
                                          resp["subscriptionId"];
                                      //  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      //  if (await getString('isFirstTime') != 'NO') {
                                      //  await storeString('isFirstTime', 'NO');
                                      //  }
                                      if (subscription == 0 &&
                                          subscriptionId == 0) {
                                        //  if((prefs.getBool("isFirstTime")!) && subscription==null){
                                        pushNewScreen(
                                          context,
                                          screen: MonitoringScreen(),
                                          withNavBar:
                                              true, // OPTIONAL VALUE. True by default.
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      } else {
                                        pushNewScreen(
                                          context,
                                          screen: MonitoringScreen2(
                                              navigater: true),
                                          withNavBar:
                                              true, // OPTIONAL VALUE. True by default.
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      }
                                      setState(() {
                                        monitoringloading = false;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        monitoringloading = false;
                                      });
                                    }
                                  },
                                  showBadge: false,
                                ),
                                GridItem(
                                  iconHeight: 80.h,
                                  title:
                                      LocaleKeys.DASHBOARD_VICTIMSUPPORT.tr(),
                                  svgName: 'victim',
                                  onTap: () {
                                    pushNewScreen(
                                      context,
                                      screen: VictimSupportScreen(),
                                      withNavBar:
                                          true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );

                                    // Navigator.push(
                                    //   context,
                                    //   PageRouteBuilder(
                                    //     pageBuilder: (c, a1, a2) =>  NavbarScreen(
                                    //         selectedPageIndex: 16,
                                    //       ),
                                    //     transitionsBuilder: (c, anim, a2, child) => SlideTransition(position: Tween<Offset>(
                                    //       begin: Offset(0.0, 1.0),
                                    //       end: Offset(0.0, 0.0),
                                    //     ).animate(CurvedAnimation(
                                    //       parent: animationController,
                                    //       curve: Curves.fastLinearToSlowEaseIn,
                                    //     )), child: child),
                                    //     transitionDuration: Duration(seconds: 3),
                                    //   ),
                                    // );
                                  },
                                  showBadge: false,
                                ),
                                GridItem(
                                  iconHeight: 64.h,
                                  title: LocaleKeys.DASHBOARD_SHARE.tr(),
                                  svgName: 'share',
                                  onTap: () {
                                    // Share.shareFiles(['assets/images/logoHD.png'],
                                    //     text:
                                    //         '${LocaleKeys.DASHBOARD_SHARECONTENT.tr()} https://ikcheckacc.page.link');
                                    Share.share(
                                      '${LocaleKeys.DASHBOARD_SHARECONTENT.tr()} $SHARE_LINK',
                                    );
                                  },
                                  showBadge: false,
                                ),
                              ],
                            )
                    ],
                  ),
                ),
                // ),
              ),
              // Visibility(
              //   visible: monitoringloading  || identityloading,
              //   child: Container(
              //     height: SCREENHEIGHT.h,
              //     // width: double.infinity,
              //     child:Center(
              //       child: ListView.builder(
              //         itemCount: 3,
              //         itemBuilder: ((context, index) {
              //           return buildSkeletonAnimation();
              //         }),
              //       ),
              //     ),
              //     color: Colors.white,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

getIdentity() async {
  return await getString('firstTimeIdentity') == 'YES';
}

class GridItem extends StatefulWidget {
  final String title;
  final String svgName;
  bool showBadge = false;
  VoidCallback onTap;
  double iconHeight;
  GridItem({
    required this.iconHeight,
    required this.title,
    required this.svgName,
    required this.onTap,
    required this.showBadge,
  });

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool x = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.showBadge) {
        x = await getIdentity();
        setState(() {
          x;
        });
      }
      //   if (widget.value == 'yes') {
      //     widget.showBadge = await getString('firstTimeUser') == 'YES';
      //     setState(() {
      //       widget.showBadge;
      //     });
      //   }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.clearWhite,
            borderRadius: BorderRadius.circular(16.r)),
        height: 175.h,
        width: 175.w,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.title == LocaleKeys.MONITORING_MONITORING.tr())
                const SizedBox(
                  height: 1,
                ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Badge(
                      animationDuration: Duration.zero,
                      padding: EdgeInsets.all(9),
                      position: BadgePosition.topEnd(end: -5, top: -5),
                      elevation: 0,
                      showBadge: x,
                      child:
                          widget.title == LocaleKeys.MONITORING_MONITORING.tr()
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: SvgPicture.asset(
                                    'assets/svgs/${widget.svgName}.svg',
                                    color: AppColors.primary,
                                    height: widget.iconHeight,
                                  ),
                                )
                              : SvgPicture.asset(
                                  'assets/svgs/${widget.svgName}.svg',
                                  color: AppColors.primary,
                                  height: widget.iconHeight,
                                ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: AppFont.normal.copyWith(
                      height: 1.4,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
