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
import 'package:iKCHECK/views/home/alertScreen.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../Utils/styles.dart';
import '../../widgets/globalWidgets.dart';

class AlertYES extends StatefulWidget {
  const AlertYES({Key? key}) : super(key: key);

  @override
  State<AlertYES> createState() => _AlertYESState();
}

class _AlertYESState extends State<AlertYES> {
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.lightPrimaryStrip,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.sp, vertical: 30.sp),
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
                                    // width: SCREENWIDTH.w * 0.47,
                                    child: Text(
                                      // LocaleKeys.ALERTS_ORG.tr()=="Organization" ? 
                                      alertTranslate(value.pickedAlertEnquiryItems[
                                      'items'][0]['details']),
                                      //  : value.pickedAlertEnquiryItems[
                                      // 'items'][0]['details'],
                                      softWrap: true,
                                      style: AppFont.H3.copyWith(
                                        letterSpacing: 0.5,
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
                                recognized: true,
                              )
                            ],
                          )
                        : Container();
                  }),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Container(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 17.w),
                  child: Text(
                    LocaleKeys.ALERTS_YESALERT_CONTENT.tr(),style: TextStyle(fontSize: 16.sp),
                    maxLines: 2,
                  ),
                ),
                // height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    color:AppColors.clearWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: AppColors.primary)),
              ),
              SizedBox(
                height: 25.h,
              ),
              Container(
                  height: 55.h,
                  width: double.infinity,
                  child: isLoadingPD
                      ? FilledButton(
                          title: '',
                          ontap: () {},
                          isLoadingFilledBtn: true,
                        )
                      : FilledButton(
                          isLoadingFilledBtn: false,
                          title: LocaleKeys.COMMON_CONFIRM.tr(),
                          ontap: () async {
                            setState(() {
                              isLoadingPD = true;
                            });
                            Map alertItem = Provider.of<MainProvider>(context,
                                    listen: false)
                                .pickedAlertEnquiryItems['items'][0];

                            String userId = await getString('US_user_id') ?? '';
                            Map object = {
                              'alertId': alertItem['id'],
                              'alertTypeDesc': "",
                              'alertTypeId': alertItem['type'],
                              'alertTypeShortDesc': "",
                              'comments': "",
                              'identityTypeId': alertItem['identityType'],
                              'status': "NF_CLOSE",
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
                                Provider.of<MainProvider>(context,
                                        listen: false)
                                    .dashboardDetails;
                            if (localDashBoardDetailsUpdate['unreadAlert'] !=
                                0) {
                              localDashBoardDetailsUpdate['unreadAlert'] =
                                  localDashBoardDetailsUpdate['unreadAlert'] -
                                      1;
                              Provider.of<MainProvider>(context, listen: false)
                                  .setDashboardDetails(
                                      localDashBoardDetailsUpdate);
                            }
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

                            Provider.of<MainProvider>(context, listen: false)
                                .setLoaderAlertStatus(true);
                            await ApiCallManagement()
                                .getIdentityEnquiryDetails(context, object3, '');
                            Provider.of<MainProvider>(context, listen: false)
                                .setLoaderAlertStatus(false);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            // pushNewScreen(
                            //   context,
                            //   screen:AlertScreen() ,
                            //   withNavBar: true,
                            //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            // );
                            setState(() {
                              isLoadingPD = false;
                            });
                            // Navigator.of(context).push(SliderTransition(AlertSent()));
                          },
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
