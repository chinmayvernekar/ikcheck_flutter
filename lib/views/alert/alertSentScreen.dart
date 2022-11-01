import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/home/alertScreen.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../Utils/styles.dart';
import '../../utils/globalVariables.dart';
import '../../widgets/globalWidgets.dart';

class AlertSent extends StatefulWidget {
  const AlertSent({Key? key}) : super(key: key);

  @override
  State<AlertSent> createState() => _AlertSentState();
}

class _AlertSentState extends State<AlertSent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading:  InkWell(
            onTap: () async {

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
                Provider.of<MainProvider>(context, listen: false)
                    .setLoaderAlertStatus(true);
                await ApiCallManagement()
                    .getIdentityEnquiryDetails(context, object, '');
                Provider.of<MainProvider>(context, listen: false)
                    .setLoaderAlertStatus(false);
                // pushNewScreen(
                //   context,
                //   screen:AlertScreen() ,
                //   withNavBar: true, // OPTIONAL VALUE. True by default.
                //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                // );
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pop(context);


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
                height: 236.h,
                child: SvgPicture.asset('assets/svgs/sent_report.svg'),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 17.w),
                  child: Text(
                    '${LocaleKeys.ALERTS_NOALERT_REPORTSENTMSG.tr()}!',
                    maxLines: 2,style:TextStyle(fontSize:16.sp)
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
                height: 20.h,
              ),
              Container(
                  height: 55.h,
                  width: double.infinity,
                  child:isLoadingPD ?FilledButton(
                    title: '',
                    ontap: () {},
                    isLoadingFilledBtn: true,
                  ):
                  FilledButton(
                    isLoadingFilledBtn: false,
                    title: LocaleKeys.COMMON_OK.tr(),
                    ontap: () async {
                      setState((){
                        isLoadingPD=true;
                      });
                      String userId = await getString('US_user_id') ?? '';

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
                      Navigator.pop(context);

                      // pushNewScreen(
                      //   context,
                      //   screen:AlertScreen() ,
                      //   withNavBar: true, // OPTIONAL VALUE. True by default.
                      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      // );
                      setState((){
                        isLoadingPD=false;
                      });
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
