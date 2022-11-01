import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/views/alert/alertSentScreen.dart';
import 'package:iKCHECK/widgets/loader.dart';
import 'package:provider/provider.dart';

import '../../Utils/styles.dart';
import '../../widgets/globalWidgets.dart';

class HandledAlertView extends StatefulWidget {
  const HandledAlertView({Key? key}) : super(key: key);

  @override
  State<HandledAlertView> createState() => _HandledAlertViewState();
}

class _HandledAlertViewState extends State<HandledAlertView> {
  List alertItems = [];
  var _alertType;
  var _email;
  int _refcount = 0;
  String sites = "";
  String typeofAlert = "";
  String lastScanDate = "";
  String lastAlertDate = "";
  String referenceRDW = "";
  var _referenceData;
  var _lasttext;

  var _temp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () async {
              Provider.of<MainProvider>(context, listen: false)
                  .setPickedHandledAlertEnquiryItems({});
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
                  LocaleKeys.NAVBARCONTENT_HANDLEDALERTS.tr(),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.lgBlue,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 31.w, vertical: 30.h),
                  child: Provider.of<MainProvider>(context)
                          .pickedHandledAlertEnquiryItems
                          .isNotEmpty
                      ? Consumer<MainProvider>(
                          builder: (context, value, child) {
                          alertItems = (value
                                      .pickedHandledAlertEnquiryItems.isEmpty &&
                                  value.pickedHandledAlertEnquiryItems[
                                          'items'] ==
                                      0)
                              ? []
                              : value.pickedHandledAlertEnquiryItems['items'];

                          var _tempData =
                              Provider.of<MainProvider>(context, listen: false)
                                  .pickedHandledAlertEnquiryItems;

                          _temp = _tempData;
                          print(" hiierror $_temp");
                          _alertType = _temp["items"][0]["orgId"];
                          _email = _temp["items"][0]["identity"]
                              .toString()
                              .toLowerCase();
                          print("tempData $_temp");
                          _referenceData = _temp["items"][0]["reference"];
                          if (!(_referenceData == null)) {
                            if (_alertType == "SS") {
                              print("helloss$_referenceData");
                              _lasttext =
                                  json.decode(_referenceData)["breaches"];
                              _refcount = json
                                  .decode(_referenceData)["breaches"]
                                  .length;

                              lastScanDate =
                                  json.decode(_referenceData)["lastScan"];
                              lastAlertDate =
                                  json.decode(_referenceData)["lastAlert"];
                              int i = 0;
                              if (_refcount > 0) {
                                json
                                    .decode(_referenceData)["breaches"]
                                    .toList()
                                    .forEach((element) {
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

                          if (alertItems == null) {
                            alertItems = [];
                          }
                          return alertItems.isNotEmpty
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            width: SCREENWIDTH.w * 0.28,
                                            child: alertItems[0]['orgId'] ==
                                                    "SS"
                                                ? Image.asset(
                                                    "assets/images/Vectorblur.png",
                                                    fit: BoxFit.fitWidth,
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/svgs/alertprefix.svg',
                                                    height: 60.h,
                                                    color:
                                                        AppColors.primaryLight,
                                                  )),
                                        // SizedBox(
                                        //   width: 33.w,
                                        // ),
                                        Flexible(
                                          // width: SCREENWIDTH.w * 0.5,
                                          child: Text(
                                            // LocaleKeys.ALERTS_ORG.tr() == "Organization"
                                            //     ?
                                            alertTranslate(value
                                                    .pickedHandledAlertEnquiryItems[
                                                'items'][0]['details']),
                                            //     : value.pickedHandledAlertEnquiryItems[
                                            // 'items'][0]['details'],

                                            softWrap: true,
                                            style: AppFont.H3.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 22.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    alertItems[0]['orgId'] == "SS"
                                        ? labelsForSS(value)
                                        : labelForRDW(value)
                                  ],
                                )
                              : Container();
                        })
                      : buildSkeletonAnimation(),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              if (Provider.of<MainProvider>(context)
                  .pickedHandledAlertEnquiryItems
                  .isNotEmpty)
                Container(
                    height: 55.h,
                    width: double.infinity,
                    child: FilledButton(
                      isLoadingFilledBtn: false,
                      title: LocaleKeys.COMMON_BACK.tr(),
                      ontap: () {
                        Navigator.pop(context);

                        Provider.of<MainProvider>(context, listen: false)
                            .setPickedHandledAlertEnquiryItems({});
                      },
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget labelsForSS(value) {
    if (alertItems[0]['type'] == "SS_BREACH") {
      return Column(
        children: [
          labelRow(
            title: "E-mail",
            info: alertItems[0]['identity'].toString().toLowerCase(),
            isBold: true,
          ),
          labelRow(
            title: LocaleKeys.MONITORING_DATE.tr(),
            info: dateTranslate(getFormatedDateOnlyTrimmed(alertItems[0]['time'],
                // 'dmy',
                // true
                )),
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
    } else if (alertItems[0]['type'] == "SS_NB_TN") {
      return Column(
        children: [
          labelRow(
            title: "E-mail",
            info: alertItems[0]['identity'].toString().toLowerCase(),
            isBold: true,
          ),
          SizedBox(
            height: 8,
          ),
          labelRow(
            title: LocaleKeys.MONITORING_DATE.tr(),
            info: dateTranslate(
                getFormatedDateOnlyTrimmed(lastScanDate,
                    // 'dmy',
                    // true
                    )),
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
            info: alertItems[0]['identity'].toString().toLowerCase(),
            isBold: true,
          ),
          SizedBox(
            height: 3,
          ),
          labelRow(
              title: LocaleKeys.MONITORING_PERIOD.tr(),
              info: dateTranslate(dateTranslate(getFormatedDateOnlyTrimmed(
              lastAlertDate,
                  // 'dmy',
                  // true
                  )) + " - " + dateTranslate(getFormatedDateOnlyTrimmed(lastScanDate,
                  // 'dmy',
                  // true
                  )))
          ),

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

  Widget labelForRDW(value) {
    return Column(
      children: [
        labelRow(
          title: LocaleKeys.ALERTS_ORG.tr(),
          info: alertItems[0]['orgId'],
        ),
        labelRow(
          title: LocaleKeys.ALERTS_DATE.tr(),
          info: dateTranslate(getFormatedDateOnlyTrimmed(
              alertItems[0]['time'], 
              // 'dmy', true
              )),
        ),
        labelRow(
          title: LocaleKeys.ALERTS_TIME.tr(),
          info: getFormatedTimeOnly(alertItems[0]['time']!, true),
        ),
        if (getValidLicenseNo(
            value.pickedHandledAlertEnquiryItems['items'][0]['reference']))
          labelRow(
            title: LocaleKeys.ALERTS_LICENSENO.tr(),
            info:
                '******${value.pickedHandledAlertEnquiryItems['items'][0]['reference']}',
          ),
        labelRow.recognized(
          title: LocaleKeys.ALERTS_REVIEW.tr(),
          recognized: value.pickedHandledAlertFraudDetails['status'] == 'F_RPT'
              ? false
              : true,
        )
      ],
    );
  }
}
