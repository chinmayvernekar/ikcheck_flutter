
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/views/monitoring/alert.dart';
import 'package:iKCHECK/widgets/globalWidgets.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:provider/provider.dart';

import 'alert.dart';
bool loading = false;

class BreachesFound extends StatefulWidget {
  const BreachesFound({Key? key}) : super(key: key);

  @override
  State<BreachesFound> createState() => _BreachesFoundState();
}

class _BreachesFoundState extends State<BreachesFound> {
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
                                Expanded(child: Text(LocaleKeys.MONITORING_NODATABREACHFOUND.tr(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)))
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
                              title: LocaleKeys.MONITORING_AANTAL.tr(),
                              info: "3 datalek",
                            ),
                            labelRow(
                              title: LocaleKeys.MONITORING_WACHTWOORD.tr(),
                              info: "GEKRAAK",
                              redClr: true,
                              isBold: true,
                            ),
                            labelRow(
                              title:  LocaleKeys.MONITORING_SITES.tr(),
                              info: "Linkedin.com TunedGlobal.com onionadr.darkweb",
                            ),

                            SizedBox(height: 20.h),
                            Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {

                                    },
                                    child: SvgPicture.asset(
                                      'assets/svgs/down.svg',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    LocaleKeys.MONITORING_MOREINFORMATION.tr(),
                                    style: AppFont.s1
                                        .copyWith(fontSize: 12.sp),
                                  ),
                                ],
                              )
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
                      child: Text( LocaleKeys.MONITORING_WECONTINOUSLYEMAILADRESS.tr(),
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
                      Navigator.push(
                          context,
                          SliderTransition(NavbarScreen(
                            selectedPageIndex: 6,
                          )));
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
                          Navigator.push(
                            context,
                            SliderTransition(
                              NavbarScreen(
                                selectedPageIndex: 28,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Icon(Icons.launch,color: Colors.white.withOpacity(0.0)),
                            ),
                            Text(
                              LocaleKeys.MONITORING_LOGIN.tr(),
                              style:
                              AppFont.identityButtonFont.copyWith(
                                color: AppColors.clearWhite,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Icon(Icons.launch,color: Colors.white,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: (){},
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 55),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                      border: Border.all(color: AppColors.primary)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.MONITORING_SHUTDOWN.tr(),
                          style:
                          AppFont.identityButtonFont.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
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
