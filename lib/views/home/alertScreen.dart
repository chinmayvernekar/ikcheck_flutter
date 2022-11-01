import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/alert/checkAlertScreen.dart';
import 'package:iKCHECK/views/alert/handledAlertScreen.dart';
import 'package:iKCHECK/widgets/loader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AlertScreen extends StatefulWidget {
  AlertScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool alertUILoading = false;
  bool buttonprocessing = false;
  bool alertLoadingbool = false;
  int indexforload = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData2();
  }

  Future loadData2() async {
    // Provider.of<MainProvider>(context,listen: false).setLoaderAlertStatus(true);
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
    // await ApiCallManagement()
    //     .getIdentityEnquiryDetails(context, object, '');
    // Provider.of<MainProvider>(context,listen: false).setLoaderAlertStatus(false);

    // setState(() {
    //   isLoading2 = true;
    // });
    // await Future.delayed(Duration(seconds: 10), () {});

    // setState(() {
    //   isLoading2 = false;
    // });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: AppBar(
            automaticallyImplyLeading: false,
            // leading:InkWell(
            //   onTap: () async {
            //     Navigator.of(context).pop();
            //
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.all(10.sp),
            //     child: SvgPicture.asset(
            //       'assets/svgs/arrowLeft.svg',
            //     ),
            //   ),
            //
            // ),
            toolbarHeight: 100.h,
            backgroundColor: AppColors.clearWhite,
            elevation: 0,
            title: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.DASHBOARD_ALERTS.tr(),
                    style: AppFont.H3.copyWith(
                      fontSize: 24.sp,
                      color: AppColors.clearBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 87.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // height: SCREENHEIGHT.h * 0.2,
                padding: EdgeInsets.only(
                  left: 65.sp,
                  right: 65.sp,
                ),
                child: Container(
                  width: 253.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 1),
                      // color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                    onPressed: () async {
                      if(buttonprocessing == false){
                        try{
                          setState(() {
                            isLoadingPD = true;
                            buttonprocessing = true;
                          });
                          String userId = await getString('US_user_id') ?? '';
                          Map object = {
                            "userId": userId,
                            "alertId": 0,
                            "status": null,
                            "read": 'READ',
                            "type": null,
                            "fromDate": null,
                            "toDate": null,
                            "content": null,
                            "source": null,
                            "sort": "Date time",
                            "page": 1
                          };
                          await ApiCallManagement().getIdentityEnquiryDetails(
                            context,
                            object,
                            'handledAlertEnquiryItems',
                          );
                          setState((){
                            buttonprocessing = false;
                          });
                          pushNewScreen(
                            context,
                            screen: HandledAlertScreen(),
                            withNavBar: true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                          );
                          setState(() {
                            isLoadingPD = false;
                            buttonprocessing = false;
                          });
                        }catch(e){
                          setState((){
                            buttonprocessing = false;
                          });
                        }
                      }
                    },
                    child: isLoadingPD
                        ? LoadingAnimationWidget.prograssiveDots(
                            color: AppColors.primary,
                            size: 40.sp,
                          )
                        : Text(
                            LocaleKeys.ALERTS_HANDLEDALERTS.tr(),
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
        body: Provider.of<MainProvider>(context).isLoadingAlert
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: ((context, index) {
                  return buildSkeletonAnimation();
                }),
              )
            : Container(
                // height: 690.h,
                child: Consumer<MainProvider>(
                  builder: (context, value, child) {
                    List alertList = (value.enquiryItems.isNotEmpty &&
                            value.enquiryItems['items'] != null)
                        ? value.enquiryItems['items']
                        : [];
                    return alertList.isEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                alertUILoading = true;
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
                                context,
                                object,
                                '',
                              );
                              setState(() {
                                alertUILoading = false;
                              });
                            },
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.sp,
                                ),
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    SvgPicture.asset(
                                        'assets/svgs/empty_alert.svg',
                                        height: 150.sp),
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    Text(
                                      LocaleKeys.ALERTS_NONEWALERTSTOCHECK.tr(),
                                      textAlign: TextAlign.center,
                                      style: AppFont.normal.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView(
                            children: [
                              SizedBox(
                                // color: Colors.red,
                                height: (SCREENHEIGHT.h * 0.78) - 85.h,
                                child: RefreshIndicator(
                                  displacement: 20.sp,
                                  onRefresh: () async {
                                    setState(() {
                                      alertUILoading = true;
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
                                      context,
                                      object,
                                      '',
                                    );
                                    setState(() {
                                      alertUILoading = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    curve: Curves.ease,
                                    duration: Duration(milliseconds: 250),
                                    padding: alertUILoading
                                        ? EdgeInsets.only(top: 100.sp)
                                        : EdgeInsets.zero,
                                    child: ListView.builder(
                                      // physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: alertList.length + 1,
                                      itemBuilder: (context, index) {
                                        return index == alertList.length
                                            ? Column(
                                                children: [
                                                  // Container(
                                                  //   // height: SCREENHEIGHT.h * 0.2,
                                                  //   padding: EdgeInsets.only(
                                                  //     left: 65.sp,
                                                  //     right: 65.sp,
                                                  //     top: 50.sp,
                                                  //   ),
                                                  //   child: Container(
                                                  //   width: 253.w,
                                                  //     height: 55.h,
                                                  //     decoration: BoxDecoration(
                                                  //         border: Border.all(
                                                  //             color:
                                                  //                 AppColors.primary,
                                                  //             width: 1),
                                                  //         // color: AppColors.primary,
                                                  //         borderRadius:
                                                  //             BorderRadius.circular(
                                                  //                 8)),
                                                  //     child: TextButton(
                                                  //       onPressed: () async {
                                                  //         setState((){
                                                  //           isLoadingPD=true;
                                                  //         });
                                                  //         String userId =
                                                  //             await getString(
                                                  //                     'US_user_id') ??
                                                  //                 '';
                                                  //         // Map object = {
                                                  //         //   'alertId': 0,
                                                  //         //   'content': null,
                                                  //         //   'fromDate': null,
                                                  //         //   'page': 1,
                                                  //         //   'read': 'READ',
                                                  //         //   'sort': "Date time",
                                                  //         //   'source': null,
                                                  //         //   'status': null,
                                                  //         //   'toDate': null,
                                                  //         //   'type': null,
                                                  //         //   'userId': userId,
                                                  //         // };
                                                  //
                                                  //         //!
                                                  //
                                                  //         Map object = {
                                                  //
                                                  //           "userId": userId,
                                                  //           "alertId": 0,
                                                  //           "status": null,
                                                  //           "read": 'READ',
                                                  //           "type": null,
                                                  //           "fromDate": null,
                                                  //           "toDate": null,
                                                  //           "content": null,
                                                  //           "source": null,
                                                  //           "sort": "Date time",
                                                  //           "page": 1
                                                  //
                                                  //
                                                  //         };
                                                  //         await ApiCallManagement().getIdentityEnquiryDetails(
                                                  //           context,
                                                  //           object,
                                                  //           'handledAlertEnquiryItems',
                                                  //         );
                                                  //         pushNewScreen(
                                                  //           context,
                                                  //           screen:HandledAlertScreen() ,
                                                  //           withNavBar: true, // OPTIONAL VALUE. True by default.
                                                  //           pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                                  //         );
                                                  //         setState((){
                                                  //           isLoadingPD=false;
                                                  //         });
                                                  //       },
                                                  //       child: isLoadingPD ?LoadingAnimationWidget.prograssiveDots(
                                                  //         color: AppColors.primary,
                                                  //         size: 40.sp,
                                                  //       ):
                                                  //       Text(
                                                  //         LocaleKeys
                                                  //             .ALERTS_HANDLEDALERTS
                                                  //             .tr(),
                                                  //         style: TextStyle(
                                                  //           color:
                                                  //               AppColors.primary,
                                                  //           fontWeight:
                                                  //               FontWeight.w600,
                                                  //           fontSize: 18.sp
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  Container(
                                                    height: 50,
                                                    width: 20,
                                                  ),
                                                ],
                                              )
                                            : AlertTile(
                                                alertType: alertList[index]
                                                    ['orgId'],
                                                title: alertList[index]
                                                    ['details'],
                                                Datetime: getFormatedDateTime(
                                                    alertList[index]['time']),
                                                alertLoading:
                                                    alertLoadingbool &&
                                                        index == indexforload,
                                                ontap: () async {
                                                  if (_isLoading == false) {
                                                    print("hittttt");
                                                    try {
                                                      setState(() {
                                                        indexforload = index;
                                                        alertLoadingbool = true;
                                                        _isLoading = true;
                                                      });

                                                      print("alert $alertList");
                                                      String userId =
                                                          await getString(
                                                              'US_user_id') ??
                                                              '';
                                                      Map object = {
                                                        'alertId':
                                                        alertList[index]
                                                        ['id'],
                                                        'content': null,
                                                        'fromDate': null,
                                                        'page': 1,
                                                        'read': null,
                                                        'sort': "Date time",
                                                        'source': null,
                                                        'status': null,
                                                        'toDate': null,
                                                        'type': null,
                                                        'userId': userId,
                                                      };

                                                      await ApiCallManagement()
                                                          .getIdentityEnquiryDetails(
                                                          context,
                                                          object,
                                                          'pickedAlert');
                                                      // setState((){
                                                      //   _isLoading = false;
                                                      // });

                                                      await pushNewScreen(
                                                        context,
                                                        screen: CheckAlert(),
                                                        withNavBar: false,
                                                        // OPTIONAL VALUE. True by default.
                                                        pageTransitionAnimation:
                                                        PageTransitionAnimation
                                                            .cupertino,
                                                      );
                                                      // setState(() {
                                                      //   alertLoadingbool =
                                                      //   false;
                                                      // });
                                                      // Provider.of<MainProvider>(context,listen: false).setLoaderAlertStatus(false);
                                                      // await Provider.of<MainProvider>(context,
                                                      //     listen: false)
                                                      //     .setLoaderStatus(true);

                                                      // Map object1 = {
                                                      //   'alertId':
                                                      //   alertList[index]
                                                      //   ['id'],
                                                      //   'alertTypeId':
                                                      //   alertList[index]
                                                      //   ['type'],
                                                      //   'userId': userId,
                                                      // };

                                                      // await ApiCallManagement()
                                                      //     .fraudDetailsApiCall(
                                                      //   object1,
                                                      //   context,
                                                      //   'pickedFraudDetails',
                                                      // );
                                                      // Provider.of<MainProvider>(context,
                                                      //     listen: false)
                                                      //     .setLoaderStatus(false);
                                                      setState(() {
                                                        alertLoadingbool =
                                                        false;
                                                        _isLoading = false;
                                                      });
                                                    } catch (e) {
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    }
                                                  }
                    },
                                              );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              //
                              // SizedBox(
                              //   height: ((620.h - 90.h * alertList.length) <= 0)
                              //       ? 10.h
                              //       : 620.h - 90.h * alertList.length,
                              // ),
                            ],
                          );

                    // Positioned(
                    //   bottom: 0,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(bottom: 10.h),
                    //     child: Container(
                    //       height: 46,
                    //       width: 320.w,
                    //       decoration: BoxDecoration(
                    //           border: Border.all(
                    //               color: AppColors.primary, width: 1),
                    //           // color: AppColors.primary,
                    //           borderRadius: BorderRadius.circular(8)),
                    //       child: TextButton(
                    //         onPressed: () async {
                    //           String userId =
                    //               await getString('US_user_id') ?? '';
                    //           Map object = {
                    //             'alertId': 0,
                    //             'content': null,
                    //             'fromDate': null,
                    //             'page': 1,
                    //             'read': 'READ',
                    //             'sort': "Date time",
                    //             'source': 'RDW',
                    //             'status': null,
                    //             'toDate': null,
                    //             'type': null,
                    //             'userId': userId,
                    //           };

                    //           //!
                    //           Navigator.of(context).push(
                    //             SliderTransition(
                    //               NavbarScreen(
                    //                 apiCallString:
                    //                     'getHandledAlertEnquiryItems',
                    //                 apiData: object,
                    //                 selectedPageIndex: 11,
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //         child: Text(
                    //           LocaleKeys.NAVBARCONTENT_HANDLEDALERTS.tr(),
                    //           style: TextStyle(
                    //             color: AppColors.primary,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  },
                ),
              ));
  }
}

// ignore: non_constant_identifier_names
class AlertTile extends StatelessWidget {
  String title;
  String alertType;
  String? Type;
  String Datetime;
  VoidCallback ontap;
  bool alertLoading;

  AlertTile(
      {required this.title,
      required this.alertType,
      required this.Datetime,
      required this.ontap,
      required this.alertLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 0.5.sp,
              color: AppColors.ashColor,
            ),
          ),
        ),
        // height: SCREENHEIGHT.h * 0.09,
        child: Container(
          width: SCREENWIDTH.w,
          color: Colors.white,
          // height: 85.h,
          child: Align(
            alignment: Alignment.center,
            child: ListTile(
              contentPadding: EdgeInsets.only(
                  left: 20.sp, right: 20.sp, bottom: 2.sp, top: 2.sp),
              dense: true,
              visualDensity: VisualDensity(vertical: 1),
              title: Text(
                // LocaleKeys.ALERTS_ORG.tr() == "Organization"
                    // ? 
                    alertTranslate(title),
                    // : title,
                // LocaleKeys.ALERTS_ORG.tr()=="Organization" ? translateMap[title]: title,
                style: AppFont.messageTitle,
              ),
              subtitle: Text(
                Datetime,
                style: AppFont.messageSubtitle,
              ),
              trailing: Padding(
                padding: EdgeInsets.only(right: 10.sp),
                child: alertLoading
                    ? LoadingAnimationWidget.prograssiveDots(
                        color: AppColors.primary,
                        size: 40.sp,
                      )
                    : SvgPicture.asset(
                        'assets/svgs/arrowRight.svg',
                        height: 25.sp,
                        color: AppColors.black3,
                      ),
              ),
              // trailing: Icon(
              //   Icons.arrow_forward_ios_rounded,
              //   color: Colors.grey,
              //   size: 28.sp,
              // ),
              leading: Container(
                height: 55.sp,
                width: 55.sp,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.msgIconBorder,
                    width: 2.sp,
                  ),
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: alertType == "SS"
                    ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/svgs/Vector.svg',
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/svgs/alertprefix.svg',
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// AlertTile(
//   title: 'Driver License Checked',
//   Datetime: '08 March 2022,10:16',
//   ontap: () {
//     Navigator.push(context,
//         SliderTransition(NavbarScreen(selectedPageIndex: 7)));
//   },
// ),
// AlertTile(
//   title: 'Driver License linked',
//   Datetime: '07 March 2022,12:14',
//   ontap: () {
//     Navigator.push(
//       context,
//       SliderTransition(
//         NavbarScreen(selectedPageIndex: 7),
//       ),
//     );
//   },
// ),
// AlertTile(
//   title: 'Driver License Checked',
//   Datetime: '08 March 2022,10:16',
//   ontap: () {},
// ),
