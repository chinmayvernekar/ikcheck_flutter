
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/monitoring/monitorActivities.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MonitoringScreen extends StatefulWidget {
  bool loading = false;

   MonitoringScreen({Key? key}) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {

  bool myLoadingAnim = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading:InkWell(
            onTap: () async {
              Navigator.pop(context);

            },
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: SvgPicture.asset(
                'assets/svgs/arrowLeft.svg',
              ),
            ),

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
                  LocaleKeys.MONITORING_DATAMONITOR.tr(),
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
      ) ,
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 46.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.MONITORING_DATAMONITOR.tr(),
                      style: AppFont.H1.copyWith(
                          fontSize: 29.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.clearBlack),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  SvgPicture.asset('assets/svgs/Vector.svg',height: 70.sp),

                ],
              ),
            ),
            Container(
                width: double.infinity,
                // height: 290.h,
                color: AppColors.lgBlue,
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 38.h, horizontal: 28.w),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        SvgPicture.asset('assets/svgs/a_mail.svg',color:AppColors.primaryLight),
                        const SizedBox(width: 20,),
                        Expanded(child: Text(userEmail,style:TextStyle(color:AppColors.clearBlack,fontSize: 18.sp,fontWeight: FontWeight.w600),softWrap: false,maxLines: 1,overflow: TextOverflow.ellipsis,))
                      ],),
                      SizedBox(height:20),
                      Text(
                        LocaleKeys.MONITORING_ENABLEMONITORINGSERVICE.tr(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Expanded(
                            child: InkWell(
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       PageRouteBuilder( pageBuilder: (context, animation1,
                              //           animation2) =>NavbarScreen(
                              //         selectedPageIndex: 6,
                              //       )));
                              //   // Navigator.push(context,
                              //   //     MaterialPageRoute(builder: (context) {
                              //   //   return NavbarScreen(
                              //   //     selectedPageIndex: 6,
                              //   //   );
                              //   // }));
                              // },
                              child: Container(
                                constraints: BoxConstraints(minHeight: 55),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.primary,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    setState((){
                                      myLoadingAnim = true;
                                    });
                                    var resp = await ApiCallManagement().enableSubscription(context);
                                    print("resp if $resp");
                                    if(resp!=null && resp["success"]=="true"){
                                      Provider.of<MainProvider>(context,listen: false).setdataletvalue(true);
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setBool("alertsOnOf", true);
                                      prefs.setBool("isFirstTime", false);
                                    }
                                    setState((){
                                      myLoadingAnim = false;
                                    });
                                    pushNewScreen(
                                      context,
                                      screen:MonitoringScreen2(greenStrip: true,navigater:false),
                                      withNavBar: true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    );

                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      !myLoadingAnim ? Text(
                                        LocaleKeys.MONITORING_ENABLEMONITORING.tr(),
                                        style:
                                        AppFont.identityButtonFont.copyWith(
                                          color: AppColors.clearWhite,fontSize: 18.sp
                                        ),
                                        textAlign: TextAlign.center,
                                      ) : LoadingAnimationWidget.prograssiveDots(
                                        color: AppColors.clearWhite,
                                        size: 40.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              height: SCREENHEIGHT.h * 0.18,
              child: Column(
                children: [
                  Text(
                    LocaleKeys.MONITORING_INCONJUCTIONWITH.tr(),
                    style: AppFont.H3.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Image.asset(
                    'assets/images/sslogo.png',
                    height: 120.h,
                    width: 200.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
