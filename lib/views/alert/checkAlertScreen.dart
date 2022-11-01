import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/alert/alertNoScreen.dart';
import 'package:iKCHECK/views/alert/alertYesScreen.dart';
import 'package:iKCHECK/widgets/globalWidgets.dart';
import 'package:iKCHECK/widgets/loader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckAlert extends StatefulWidget {
  @override
  State<CheckAlert> createState() => _CheckAlertState();
}

class _CheckAlertState extends State<CheckAlert> {
  double height = 0.h;
  double width = double.infinity;
  bool isExpanded = false;
  List alertHelpQA = [];
  bool _isLoading = false;

  void _expand(String alertType, String orgId) async {
    setState(() {
      height = SCREENHEIGHT.h * 0.156 * 40;
      isExpanded = true;
    });
    if (alertType.isNotEmpty && alertHelpQA.isEmpty) {
      setState(() {
        _isLoading = true;
      });
      List alertHelpQA1 = await ApiCallManagement()
          .getHelpAlertsDetails(context, alertType, orgId);
      print("from api $alertHelpQA1");
      setState(() {
        alertHelpQA = alertHelpQA1;
        _isLoading = false;
      });
    }
    setState(() {
      height = SCREENHEIGHT.h * 0.156 * alertHelpQA.length;
    });
  }

  void _collapse() {
    setState(() {
      isExpanded = false;
    });
  }

  bool ismorethan = false;
  var _alertType;
  var _email;
  var _lasttext;
  int _refcount = 0;
  String sites = "";
  String typeofAlert = "";
  String lastScanDate = "";
  String lastAlertDate = "";
  String referenceRDW = "";

  var _referenceData;

  var _temp;
  @override
  initState() {
    var _tempData = Provider.of<MainProvider>(context, listen: false)
        .pickedAlertEnquiryItems;
    setState(() {
      _temp = _tempData;
      print(" hiierror $_temp");
      _alertType = _temp["items"][0]["orgId"];
      _email = _temp["items"][0]["identity"].toString().toLowerCase();
      print("tempData $_temp");

      _referenceData = _temp["items"][0]["reference"].toString();
      if (!(_referenceData == null)) {
        if (_alertType == "SS") {
          print("helloss$_referenceData");
          _lasttext = json.decode(_referenceData)["breaches"];

          _refcount = json.decode(_referenceData)["breaches"].length;

          lastScanDate = json.decode(_referenceData)["lastScan"];
          lastAlertDate = json.decode(_referenceData)["lastAlert"];
          if (_refcount > 0) {
            json.decode(_referenceData)["breaches"].toList().forEach((element) {
              sites = sites + element + "\n";

              // if(i<50){
              //   sites =  sites +element+"\n";
              //   i = i + 1;
              // }else{
              //   setState((){
              //     ismorethan = true;
              //   });
              // }
            });
          }
        } else {
          print("hello rdw 4$_referenceData");
          referenceRDW = _referenceData.toString();
          print("referenceRDW $referenceRDW");
        }
      }
      typeofAlert = _temp["items"][0]["type"];
      print("TYPE $typeofAlert");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () async {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: SvgPicture.asset(
                'assets/svgs/arrowLeft.svg',
              ),
            ),
            // child: Padding(
            //   padding: EdgeInsets.all(10.sp),
            //   child: Icon(
            //     Icons.arrow_back_ios_new_rounded,
            //     color: AppColors.clearBlack,
            //   ),
            // child: Icon(
            //   Icons.arrow_back_ios_new_rounded,
            //   color: AppColors.clearBlack,
            // ),
            // ),
          ),
          toolbarHeight: 100.h,
          backgroundColor: AppColors.clearWhite,
          elevation: 0,
          title: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.NAVBARCONTENT_CHECKALERTS.tr(),
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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        //physics: !isExpanded? NeverScrollableScrollPhysics() : ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.lightPrimaryStrip,
                ),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 31.w, vertical: 30.h),
                    // padding: EdgeInsets.only(
                    //     left: 31.w,
                    //     right: 31,
                    //     top: Provider.of<MainProvider>(context).isLoading
                    //         ? 15.h
                    //         : 30.h,
                    //     bottom: 15.h),
                    child: firstComponent("$_alertType")),
              ),
              SizedBox(
                height: 20.h,
              ),
              secondComponent("$_alertType"),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstComponent(String alertType) {
    return Consumer<MainProvider>(
      builder: (context, value, child) {
        return value.isLoading
            ? buildSkeletonAnimation()
            : value.pickedAlertEnquiryItems.isNotEmpty
                ? Column(
                    children: [
                      logoHeading(value, alertType),
                      SizedBox(
                        height: 20.h,
                      ),
                      alertType == "SS"
                          ? labelsForSS(value)
                          : labelsForRDW(value),
                      (typeofAlert == "SS_NB_TN" || typeofAlert == "SS_NB")
                          ? Container()
                          : SizedBox(height: 6.h),
                      (typeofAlert == "SS_NB_TN" || typeofAlert == "SS_NB")
                          ? Container()
                          : moreWidget(value),
                      if (!Provider.of<MainProvider>(context).isLoading)
                        GestureDetector(
                          onTap: () {
                            _expand("", "");
                          },
                          onDoubleTap: _collapse,
                          child: AnimatedContainer(
                            color: AppColors.transparent,
                            curve: Curves.fastLinearToSlowEaseIn,
                            // height: height,
                            duration: Duration(milliseconds: 200),
                            child: isExpanded
                                ? Container(
                                    // width: double.infinity,
                                    width: SCREENWIDTH.w,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _isLoading
                                              ? Container(
                                                  height: 200,
                                                  width: SCREENWIDTH.w,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: 3,
                                                    itemBuilder:
                                                        ((context, index) {
                                                      return buildSkeletonAnimationMore();
                                                    }),
                                                  ),
                                                )
                                              : alertHelpQA.isNotEmpty
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          alertHelpQA.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              alertHelpQA[index]
                                                                  ['Question'],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.sp,
                                                              ),
                                                            ),
                                                            Text(
                                                              alertHelpQA[index]
                                                                  ['Answer'],
                                                              style: TextStyle(
                                                                fontSize: 14.sp,
                                                              ),
                                                              maxLines: 15,
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    )
                                                  : Container(),
                                          isExpanded
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      TextButton(
                                                        onPressed: _collapse,
                                                        child: Column(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/svgs/up.svg',
                                                              color: AppColors
                                                                  .primary,
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Text(
                                                              LocaleKeys
                                                                  .ALERTS_COLLAPESE
                                                                  .tr(),
                                                              style: AppFont.s1
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color: AppColors
                                                                          .clearBlack),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                    ],
                  )
                : Container();
      },
    );
  }

  Widget logoHeading(value, String alertType) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        alertType.toUpperCase() == "SS"
            ? Container(
                alignment: Alignment.centerLeft,
                width: SCREENWIDTH.w * 0.28,
                child: Image.asset(
                  "assets/images/Vectorblur.png",
                  fit: BoxFit.fitWidth,
                ))
            : Container(
                padding: const EdgeInsets.only(right: 35),
                width: SCREENWIDTH.w * 0.28,
                child: SvgPicture.asset(
                  'assets/svgs/alertprefix.svg',
                  color: AppColors.primary.withOpacity(0.3),
                  width: 90.w,
                ),
              ),
        alertType.toUpperCase() == "SS"
            ? Flexible(
                // width: SCREENWIDTH.w * 0.5,
                child: Text(
                  // LocaleKeys.ALERTS_ORG.tr() == "Organization"
                  //     ?
                  alertTranslate(
                      value.pickedAlertEnquiryItems['items'][0]['details']),
                  //     : value.pickedAlertEnquiryItems[
                  // 'items'][0]['details'],

                  softWrap: true,
                  style: AppFont.H3.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22.sp,
                  ),
                ),
              )
            : Flexible(
                child: Text(
                  // LocaleKeys.ALERTS_ORG.tr()=="Organization" ?
                  alertTranslate(
                      value.pickedAlertEnquiryItems['items'][0]['details']),
                  //  : value.pickedAlertEnquiryItems[
                  // 'items'][0]['details'],
                  softWrap: true,
                  style: AppFont.H3.copyWith(
                    letterSpacing: 0.5,
                    height: 1.5,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
      ],
    );
  }

  Widget moreWidget(value) {
    return !isExpanded
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                child: TextButton(
                  onPressed: () {
                    print("more info ${value.pickedAlertEnquiryItems}");

                    _expand(value.pickedAlertEnquiryItems['items'][0]['type'],
                        value.pickedAlertEnquiryItems['items'][0]['orgId']);
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/down.svg',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        LocaleKeys.ALERTS_MOREINFO.tr(),
                        style: AppFont.s1.copyWith(
                            fontSize: 12.sp, color: AppColors.clearBlack),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget labelsForRDW(value) {
    return Column(
      children: [
        labelRow(
          title: LocaleKeys.ALERTS_ORG.tr(),
          info: value.pickedAlertEnquiryItems['items'][0]['orgId'],
        ),
        labelRow(
          title: LocaleKeys.ALERTS_DATE.tr(),
          info: dateTranslate(getFormatedDateOnlyTrimmed(value.pickedAlertEnquiryItems['items'][0]['time'],
              // 'dmy',
              // true
              )
              ),

        ),
        labelRow(
          title: LocaleKeys.ALERTS_TIME.tr(),
          info: getFormatedTimeOnly(
              value.pickedAlertEnquiryItems['items'][0]['time'], true),
        ),
        if (getValidLicenseNo(
            value.pickedAlertEnquiryItems['items'][0]['reference']))
          labelRow(
            title: LocaleKeys.ALERTS_LICENSENO.tr(),
            info: '******${referenceRDW}',
          ),
      ],
    );
  }

  Widget labelsForSS(value) {
    if (typeofAlert == "SS_BREACH") {
      return Column(
        children: [
          labelRow(
            title: "E-mail",
            info: value.pickedAlertEnquiryItems['items'][0]['identity']
                .toString()
                .toLowerCase(),
            isBold: true,
          ),
          labelRow(
            title: LocaleKeys.MONITORING_DATE.tr(),
            info: dateTranslate(getFormatedDateOnlyTrimmed(value.pickedAlertEnquiryItems['items'][0]['time'],
                // 'dmy',
                // true
                )
                ),
            isSize: true,
          ),
          labelRow(
            title: LocaleKeys.MONITORING_AANTAL.tr(),
            info: _lasttext.contains("More sites found...")
                ? "${_refcount - 1}+ " + LocaleKeys.MONITORING_DATALEAKS.tr()
                : _refcount.toString() +
                    " " +
                    LocaleKeys.MONITORING_DATALEAKS.tr(),
          ),
          labelRow(
            title: LocaleKeys.MONITORING_WACHTWOORD.tr(),
            info: LocaleKeys.MONITORING_CRACKED.tr(),
            redClr: true,
            isBold: true,
          ),
          labelRow(title: LocaleKeys.MONITORING_SITES.tr(), info: sites),
        ],
      );
    } else if (typeofAlert == "SS_NB_TN") {
      return Column(
        children: [
          labelRow(
            title: "E-mail",
            info: value.pickedAlertEnquiryItems['items'][0]['identity']
                .toString()
                .toLowerCase(),
            isBold: true,
          ),
          SizedBox(
            height: 8,
          ),
          labelRow(
            title: LocaleKeys.MONITORING_DATE.tr(),
            info: dateTranslate(getFormatedDateOnlyTrimmed(lastScanDate,
                // 'dmy',
                // true
                )
                ),
            isSize: true,
          ),
          SizedBox(
            height: 8,
          ),
          labelRow(
            title: LocaleKeys.MONITORING_RESULT.tr(),
            info: LocaleKeys.MONITORING_NOTHINGFOUND.tr(),
            greenClr: true,
            isBold: true,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          labelRow(
            title: "E-mail",
            info: value.pickedAlertEnquiryItems['items'][0]['identity']
                .toString()
                .toLowerCase(),
            isBold: true,
          ),
          SizedBox(height: 3,),
          labelRow(
            title:LocaleKeys.MONITORING_PERIOD.tr(),
            info: dateTranslate(dateTranslate(getFormatedDateOnlyTrimmed(
              lastAlertDate,
                // 'dmy',
                // true
                ))+" - "+dateTranslate(getFormatedDateOnlyTrimmed(lastScanDate,
              // 'dmy',
              // true
              )))
          ),
          // labelRow(
          //     title: LocaleKeys.MONITORING_PERIOD.tr(),
          //     info: dateTranslate(dateTranslate(
          //             getFormatedDateOnly(lastAlertDate, 'dmy', true)) +
          //         " - " +
          //         dateTranslate(
          //             getFormatedDateOnly(lastScanDate, 'dmy', true)))),
          labelRow(
            title: LocaleKeys.MONITORING_RESULT.tr(),
            info: "NIETS GEVONDEN",
            greenClr: true,
            isBold: true,
          ),
        ],
      );
    }
  }

  Widget secondComponent(String alertType) {
    return Column(
      children: [
        SizedBox(height: 10),
        if (!Provider.of<MainProvider>(context).isLoading)
          textforCard(alertType),
        if (!Provider.of<MainProvider>(context).isLoading)
          SizedBox(
            height: 25.h,
          ),
        if (!Provider.of<MainProvider>(context).isLoading) button(alertType),
      ],
    );
  }

  Widget textforCard(String alertType) {
    return alertType.toUpperCase() == "SS" ? textforSS() : textforRDW();
    //   Container(
    //   child: Padding(
    //     padding:
    //     EdgeInsets.symmetric(vertical: 21.h, horizontal: 17.w),
    //     child: Text(
    //       LocaleKeys.ALERTS_DOURECOGNIZETHISEVENT.tr(),
    //     ),
    //   ),
    //   height: 60,
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(8),
    //       border: Border.all(width: 1, color: AppColors.primary)),
    // );
  }

  Widget textforRDW() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 21.h, horizontal: 17.w),
        child: Text(
          LocaleKeys.ALERTS_DOURECOGNIZETHISEVENT.tr(),
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.clearWhite,
          border: Border.all(width: 1, color: AppColors.primary)),
    );
  }

  Widget textforSS() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 21.h, horizontal: 17.w),
        child: typeofAlert == "SS_BREACH"
            ? Text(LocaleKeys.MONITORING_SSBREACHDATA.tr(),
                style: TextStyle(fontSize: 16.sp))
            : Text(LocaleKeys.MONITORING_WECONTINOUSLYEMAILADRESS.tr(),
                style: TextStyle(fontSize: 16.sp)),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.clearWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: AppColors.primary)),
    );
  }

  Widget button(String alertType) {
    return alertType.toUpperCase() == "SS" ? ButtonForSS() : ButtonForRDW();
  }

  Widget ButtonForRDW() {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            isLoadingFilledBtn: false,
            title: LocaleKeys.COMMON_YES.tr().toUpperCase(),
            ontap: () {
              pushNewScreen(
                context,
                screen: AlertYES(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
        ),
        SizedBox(
          width: 25.w,
        ),
        Expanded(
          child: isLoadingPD
              ? FilledButton(
                  title: '',
                  ontap: () {},
                  isLoadingFilledBtn: true,
                )
              : FilledButton(
                  isLoadingFilledBtn: false,
                  title: LocaleKeys.COMMON_NO.tr().toUpperCase(),
                  ontap: () async {
                    setState(() {
                      isLoadingPD = true;
                    });
                    Map alertItem =
                        Provider.of<MainProvider>(context, listen: false)
                            .pickedAlertEnquiryItems['items'][0];
                    String userId = await getString('US_user_id') ?? '';

                    Map object = {
                      'alertId': alertItem['id'],
                      'alertTypeId': alertItem['type'],
                      'userId': userId,
                    };

                    await ApiCallManagement()
                        .fraudDetailsApiCall(object, context, '');
                    setState(() {
                      isLoadingPD = false;
                    });
                    pushNewScreen(
                      context,
                      screen: AlertNo(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                ),
        ),
      ],
    );
  }

  bool isLoadingProcessing = false;
  bool isLoadingProcessing2 = false;
  Widget ButtonForSS() {
    if (typeofAlert == "SS_BREACH") {
      return Column(
        children: [
          InkWell(
            child: Container(
              constraints: BoxConstraints(minHeight: 55.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary,
              ),
              child: InkWell(
                onTap: () async {
                  String url =
                      LocaleKeys.MONITORING_SSALERTLINK.tr() + "${_email}";

                  if (await canLaunch(url))
                    await launch(url,
                        forceWebView: false, forceSafariVC: false);
                  else
                    // can't launch url, there is some error
                    throw "Could not launch $url";
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Icon(Icons.launch,
                          color: Colors.white.withOpacity(0.0)),
                    ),
                    Text(
                      LocaleKeys.MONITORING_LOGIN.tr(),
                      style: AppFont.identityButtonFont.copyWith(
                        color: AppColors.clearWhite,
                        fontSize: 18.sp,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Icon(
                        Icons.launch,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              setState(() {
                isLoadingProcessing = true;
              });
              String userId = await getString('US_user_id') ?? '';
              Map object = {
                'alertId': _temp["items"][0]["id"],
                'alertTypeDesc': "SS_BREACH no fraud",
                'alertTypeId': _temp["items"][0]['type'],
                'alertTypeShortDesc': "SS",
                'comments': "SS TEST",
                'identityTypeId': _temp["items"][0]['identityType'],
                'status': _temp["items"][0]['type'] == "SS_BREACH"
                    ? "F_INFO"
                    : "NF_INFO",
                'userId': userId,
              };

              await ApiCallManagement().updateFraudCall(object, context);
              Map object2 = {
                'alertId': _temp["items"][0]["id"],
                'read': "READ",
                'userId': userId,
              };

              ApiCallManagement().updateReadCountApi(object2, context);

              Map localDashBoardDetailsUpdate =
                  Provider.of<MainProvider>(context, listen: false)
                      .dashboardDetails;
              if (localDashBoardDetailsUpdate['unreadAlert'] != 0) {
                localDashBoardDetailsUpdate['unreadAlert'] =
                    localDashBoardDetailsUpdate['unreadAlert'] - 1;
                Provider.of<MainProvider>(context, listen: false)
                    .setDashboardDetails(localDashBoardDetailsUpdate);
              }

              // Map object3 = {
              //   'alertId': 0,
              //   'content': null,
              //   'fromDate': null,
              //   'page': 1,
              //   'read': null,
              //   'sort': "Date time",
              //   'source': null,
              //   'status': "To Be Attended",
              //   'toDate': null,
              //   'type': null,
              //   'userId': userId,
              // };
              // await ApiCallManagement().getIdentityEnquiryDetails(
              //   context,
              //   object3,
              //   '',
              // );

              Map object4 = {
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
              setState(() {
                isLoadingProcessing = false;
              });
              Provider.of<MainProvider>(context, listen: false)
                  .setLoaderAlertStatus(true);
              await ApiCallManagement()
                  .getIdentityEnquiryDetails(context, object4, '');
              Provider.of<MainProvider>(context, listen: false)
                  .setLoaderAlertStatus(false);
              Navigator.pop(context);
            },
            child: Container(
              constraints: BoxConstraints(minHeight: 55.sp),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.primary)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoadingProcessing
                      ? LoadingAnimationWidget.prograssiveDots(
                          color: AppColors.primary,
                          size: 40.sp,
                        )
                      : Text(
                          LocaleKeys.MONITORING_SHUTDOWN.tr(),
                          style: AppFont.identityButtonFont.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return InkWell(
        onTap: () async {
          setState(() {
            isLoadingProcessing2 = true;
          });
          String userId = await getString('US_user_id') ?? '';
          Map object = {
            'alertId': _temp["items"][0]["id"],
            'alertTypeDesc': "SS_BREACH no fraud",
            'alertTypeId': _temp["items"][0]['type'],
            'alertTypeShortDesc': "SS",
            'comments': "SS TEST",
            'identityTypeId': _temp["items"][0]['identityType'],
            'status':
                _temp["items"][0]['type'] == "SS_BREACH" ? "F_INFO" : "NF_INFO",
            'userId': userId,
          };

          await ApiCallManagement().updateFraudCall(object, context);
          print("Fraud api");
          Map object2 = {
            'alertId': _temp["items"][0]["id"],
            'read': "READ",
            'userId': userId,
          };
          ApiCallManagement().updateReadCountApi(object2, context);

          Map localDashBoardDetailsUpdate =
              Provider.of<MainProvider>(context, listen: false)
                  .dashboardDetails;
          if (localDashBoardDetailsUpdate['unreadAlert'] != 0) {
            localDashBoardDetailsUpdate['unreadAlert'] =
                localDashBoardDetailsUpdate['unreadAlert'] - 1;
            Provider.of<MainProvider>(context, listen: false)
                .setDashboardDetails(localDashBoardDetailsUpdate);
          }

          // Map object3 = {
          //   'alertId': 0,
          //   'content': null,
          //   'fromDate': null,
          //   'page': 1,
          //   'read': null,
          //   'sort': "Date time",
          //   'source': null,
          //   'status': "To Be Attended",
          //   'toDate': null,
          //   'type': null,
          //   'userId': userId,
          // };
          // ApiCallManagement().getIdentityEnquiryDetails(context, object3, "getEnquiryDetails");
          // Navigator.of(context).pop();

          Map object3 = {
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
          setState(() {
            isLoadingProcessing2 = false;
          });
          Provider.of<MainProvider>(context, listen: false)
              .setLoaderAlertStatus(true);
          await ApiCallManagement()
              .getIdentityEnquiryDetails(context, object3, '');
          Provider.of<MainProvider>(context, listen: false)
              .setLoaderAlertStatus(false);
          Navigator.pop(context);
        },
        child: Container(
          constraints: BoxConstraints(minHeight: 55.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary,
              border: Border.all(color: AppColors.primary)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoadingProcessing2
                  ? LoadingAnimationWidget.prograssiveDots(
                      color: AppColors.clearWhite,
                      size: 40.sp,
                    )
                  : Text(
                      LocaleKeys.MONITORING_SHUTDOWN1.tr(),
                      style: AppFont.identityButtonFont.copyWith(
                        color: AppColors.clearWhite,
                      ),
                    ),
            ],
          ),
        ),
      );
    }
  }
}

// class labelRow extends StatelessWidget {
//   String title;
//   String info;
//   labelRow({required this.title, required this.info});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.sp),
//       child: Row(
//         children: [
//           Container(
//             // color: Colors.red,
//             width: SCREENWIDTH.w * 0.28,
//             child: Text(
//               '$title:',
//               style: AppFont.rowLabel,
//             ),
//           ),
//           Text(
//             info,
//             style: AppFont.rowLabel.copyWith(
//                 color: Color(0xff061025).withOpacity(0.8),
//                 fontWeight: FontWeight.w500),
//           )
//         ],
//       ),
//     );

//   }
// }
