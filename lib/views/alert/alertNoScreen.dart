import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/alert/alertSentScreen.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../Utils/styles.dart';
import '../../widgets/globalWidgets.dart';

class AlertNo extends StatefulWidget {
  const AlertNo({Key? key}) : super(key: key);

  @override
  State<AlertNo> createState() => _AlertNoState();
}

class _AlertNoState extends State<AlertNo> {
  int _currentRaioValue = 0;
  TextEditingController remarks = TextEditingController();
  bool alertNoLoaderBtn = false;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.lightPrimaryStrip,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
                  child:
                      Consumer<MainProvider>(builder: (context, value, child) {
                    return value.pickedAlertEnquiryItems.isNotEmpty
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/alertprefix.svg',
                                    color: AppColors.primary.withOpacity(0.3),
                                    width: 90.w,
                                  ),
                                  SizedBox(
                                    width: 30.w,
                                  ),
                                  Flexible(
                                    // width: SCREENWIDTH.w * 0.5,
                                    child: Text(
                                      // 'Drivers license checked',
                                      // LocaleKeys.ALERTS_ORG.tr()=="Organization" ? 
                                      alertTranslate(value.pickedAlertEnquiryItems[
                                      'items'][0]['details']) ,
                                      // : value.pickedAlertEnquiryItems[
                                      // 'items'][0]['details'],
                                      //     .toString(),
                                      softWrap: true,
                                      style: AppFont.H3.copyWith(
                                        letterSpacing: 0.5,
                                        color: Color(0xff061025),
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                        fontSize: 22.sp,
                                      ),
                                      // style: GoogleFonts.poppins(
                                      //     fontSize: 25.sp,
                                      //     height: 1,
                                      //     fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              labelRow(
                                title: LocaleKeys.ALERTS_ORG.tr(),
                                info: value.pickedAlertEnquiryItems['items'][0]
                                    ['orgId'],
                              ),
                              labelRow(
                                title: LocaleKeys.ALERTS_DATE.tr(),
                                info: dateTranslate(getFormatedDateOnlyTrimmed(
                                    value.pickedAlertEnquiryItems['items'][0]
                                        ['time'],
                                    // 'dmy',
                                    // true
                                    )),
                              ),
                              labelRow(
                                title: LocaleKeys.ALERTS_TIME.tr(),
                                info: getFormatedTimeOnly(
                                    value.pickedAlertEnquiryItems['items'][0]
                                        ['time'],
                                    true),
                              ),
                              if(getValidLicenseNo(value.pickedAlertEnquiryItems['items'][0]['reference']))

                                labelRow(
                                title: LocaleKeys.ALERTS_LICENSENO.tr(),
                                info:
                                    '******${value.pickedAlertEnquiryItems['items'][0]['reference']}',
                              ),
                              labelRow.recognized(
                                title: LocaleKeys.ALERTS_REVIEW.tr(),
                                recognized: false,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          )
                        : Container();
                  }),
                ),
              ),
            ),
            // SizedBox(
            //   height: 30.h,
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 10.h),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color:AppColors.clearWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: AppColors.primary)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 17.w),
                  child: RichText(
                    text: TextSpan(
                      style: AppFont.normal.copyWith(color: Colors.black),
                      children: [
                        TextSpan(
                            text:
                                '${LocaleKeys.ALERTS_NOALERT_ATTENTION.tr()}:  ',
                            style: AppFont.normal.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 16.sp)),
                        TextSpan(
                            text: LocaleKeys.ALERTS_NOALERT_CONTENT.tr(),
                            style: AppFont.normal.copyWith(
                                fontWeight: FontWeight.w300, fontSize: 16.sp))
                      ],
                    ),
                    maxLines: 7,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: SCREENWIDTH.w,
              child: Padding(
                padding: EdgeInsets.only(left: 22.w, right: 26.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio(
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                        value: 1,
                        groupValue: _currentRaioValue,
                        onChanged: (int? value) {
                          setState(() {
                            _currentRaioValue = value!;
                          });
                        }),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 3.sp),
                        child: Text(
                            '${LocaleKeys.ALERTS_NOALERT_RADIO1.tr()} ${Provider.of<MainProvider>(context).pickedAlertEnquiryItems.isNotEmpty ? Provider.of<MainProvider>(context).pickedAlertEnquiryItems['items'][0]['orgId'] : 'organization'}',
                            style: AppFont.normal.copyWith(
                                fontWeight: FontWeight.w300, fontSize: 16.sp),maxLines: 2,overflow: TextOverflow.ellipsis,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width:SCREENWIDTH.w,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 22.w,
                  right: 26.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio(
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                        value: 2,
                        groupValue: _currentRaioValue,
                        onChanged: (int? value) {
                          setState(() {
                            _currentRaioValue = value!;
                          });
                        }),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 3.sp),
                        child: Text(
                          LocaleKeys.ALERTS_NOALERT_RADIO2.tr(),
                          style: AppFont.normal.copyWith(
                              fontWeight: FontWeight.w300, fontSize: 16.sp),
                          maxLines: 2,overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 26.w,
              ),
              child: Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color:AppColors.clearWhite,
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all(width: 1.sp, color: Colors.blueGrey)),
                child: TextFormField(
                  controller: remarks,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.sp),
                    border: InputBorder.none,
                    hintText: LocaleKeys.ALERTS_NOALERT_REMARKS.tr(),
                    hintStyle: AppFont.s1.copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 26.w,
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primary),
                height: 55.h,
                width: double.infinity,
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: _currentRaioValue == 0
                          ? MaterialStateProperty.all<Color>(
                              AppColors.disableColor,
                            )
                          : MaterialStateProperty.all<Color>(
                              AppColors.primary,
                            ),
                    ),
                    onPressed: () async {
                      if (_currentRaioValue != 0) {
                        setState(() {
                          alertNoLoaderBtn = true;
                        });
                        Map alertItem =
                            Provider.of<MainProvider>(context, listen: false)
                                .pickedAlertEnquiryItems['items'][0];

                        String userId = await getString('US_user_id') ?? '';
                        Map object = {
                          'alertId': alertItem['id'],
                          'alertTypeDesc': "",
                          'alertTypeId': alertItem['type'],
                          'alertTypeShortDesc': "",
                          'comments': remarks.text,
                          'identityTypeId': alertItem['identityType'],
                          'status': "F_RPT",
                          'userId': userId,
                        };

                        await ApiCallManagement()
                            .updateFraudCall(object, context);

                        Map object2 = {
                          'alertId': alertItem['id'],
                          'read': "READ",
                          'userId': userId,
                        };
                        await ApiCallManagement()
                            .updateReadCountApi(object2, context);

                        Map localDashBoardDetailsUpdate =
                            Provider.of<MainProvider>(context, listen: false)
                                .dashboardDetails;

                        if (localDashBoardDetailsUpdate['unreadAlert'] != 0) {
                          localDashBoardDetailsUpdate['unreadAlert'] =
                              localDashBoardDetailsUpdate['unreadAlert'] - 1;
                          Provider.of<MainProvider>(context, listen: false)
                              .setDashboardDetails(localDashBoardDetailsUpdate);
                        }

                        pushNewScreen(
                          context,
                          screen:AlertSent() ,
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                        setState(() {
                          alertNoLoaderBtn = false;
                        });
                      }
                    },
                    child: alertNoLoaderBtn
                        ? Container(
                            padding: EdgeInsets.all(10.sp),
                            child: LoadingAnimationWidget.prograssiveDots(
                              color: AppColors.clearWhite,
                              size: 50.sp,
                            ),
                          )
                        : Text(
                            LocaleKeys.ALERTS_NOALERT_CREATEREPORT.tr(),
                            style: TextStyle(color: AppColors.clearWhite,fontSize: 18.sp),

                          )),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 26.w,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.lightPrimaryStrip,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                  child: Row(
                    ///Column 1
                    children: [
                      Icon(
                        Icons.info,
                        color: Color(0xffA8C6FA),
                        size: 50.sp,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Container(
                        width: SCREENWIDTH.w * 0.69,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              minLeadingWidth: 0,
                              leading: Icon(
                                Icons.circle,
                                color: AppColors.clearBlack,
                                size: 8,
                              ),
                              title: Text(
                                LocaleKeys.ALERTS_NOALERT_DATA1.tr(),
                                style: AppFont.messageTitle.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            ListTile(
                              minLeadingWidth: 0,
                              leading: Icon(
                                Icons.circle,
                                color: AppColors.clearBlack,
                                size: 8,
                              ),
                              title: Text(
                                LocaleKeys.ALERTS_NOALERT_DATA2.tr(),
                                style: AppFont.messageTitle.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
