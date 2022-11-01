
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/views/RDW/dlLinked.dart';
import 'package:iKCHECK/views/monitoring/alert.dart';
import 'package:iKCHECK/views/monitoring/monitorActivities.dart';
import 'package:iKCHECK/widgets/globalWidgets.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'alert.dart';
bool loading = false;
class alert extends StatefulWidget {
  const alert({Key? key}) : super(key: key);

  @override
  State<alert> createState() => _alertState();
}

class _alertState extends State<alert> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: !isExpanded ? NeverScrollableScrollPhysics() : ScrollPhysics(),
        child: SafeArea(
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
                    padding: EdgeInsets.only(
                        left: 31.w,
                        right: 31,
                        top: Provider.of<MainProvider>(context).isLoading
                            ? 15.h
                            : 30.h,
                        bottom: 15.h),
                    child: Consumer<MainProvider>(
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/alertprefix.svg',
                                  color: AppColors.primary
                                      .withOpacity(0.3),
                                  width: 90.w,
                                ),
                                SizedBox(
                                  width: 30.w,
                                ),
                                Expanded(child: Text(LocaleKeys.MONITORING_NODATABREACHFOUND.tr(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.sp)))
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            labelRow(
                              title: "E-mail",
                              info:"jaron@upfront_security.com"
                            ),
                            labelRow(
                              title: LocaleKeys.MONITORING_DATE.tr(),
                              info: "14 June 2022"
                            ),
                            labelRow(
                              title: LocaleKeys.MONITORING_RESULT.tr(),
                              info: "20:36",
                              greenClr: true,
                            ),

                            SizedBox(height: 20.h),

                          ],
                        );

                      },
                    ),
                  ),
                ),
                SizedBox(height: 30.h,),
                if (!Provider.of<MainProvider>(context).isLoading)
                  Container(
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 21.h, horizontal: 17.w),
                      child: Text(LocaleKeys.MONITORING_WECONTINOUSLYEMAILADRESS.tr(),
                        ),
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: AppColors.primary)),
                  ),
                SizedBox(
                  height: 25.h,
                ),
                if (!Provider.of<MainProvider>(context).isLoading)
                  InkWell(
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen:RDWDLlinkedScreen() ,
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                      // Navigator.push(
                      //     context,
                      //     PageRouteBuilder( pageBuilder: (context, animation1,
                      //         animation2) =>NavbarScreen(
                      //       selectedPageIndex: 6,
                      //     )));
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return NavbarScreen(
                      //     selectedPageIndex: 6,
                      //   );
                      // }));
                    },
                    child: Container(
                      constraints: BoxConstraints(minHeight: 55),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary,
                      ),
                      child: InkWell(
                        onTap: ()  {
                          pushNewScreen(
                            context,
                            screen:MonitoringScreen2() ,
                            withNavBar: true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );

                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Spacer(
                              flex: 3,
                            ),
                            Text(
                              LocaleKeys.MONITORING_ENABLEMONITORING.tr(),
                              style:
                              AppFont.identityButtonFont.copyWith(
                                color: AppColors.clearWhite,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            // widget.loading
                            //     ? SizedBox(
                            //   width: 20,
                            //   height: 20,
                            //   child: CircularProgressIndicator(
                            //     color: AppColors.clearWhite
                            //         .withOpacity(0.6),
                            //     strokeWidth: 3,
                            //   ),
                            // )
                            //     : Container(),

                            SizedBox(
                              width: 15.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
