import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/RDW/dlLinked.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/styles.dart';

class UnlinkDriverLicenseScreen extends StatelessWidget {
  const UnlinkDriverLicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  LocaleKeys.DASHBOARD_IDENTITIES.tr(),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 46.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.IDENTITIES_DRIVERSLICENSE.tr(),
                    style: AppFont.H1.copyWith(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.clearBlack),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SvgPicture.asset(
                    'assets/svgs/identity.svg',
                    height: 60.sp,
                  )
                ],
              ),
            ),
            Container(
                width: double.infinity,
                // height: 290.h,
                color: AppColors.lightPrimaryStrip,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 38.h, horizontal: 28.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.UNLINKDRIVERS_CONTENT.tr(),
                      ),
                      // 'Link your drivers license and receive alerts when your drivers license is checked by an organization. Now you can act on fraudulent events surrounding your drivers license.'),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/digidlogo.png'),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                // Navigator.pushReplacement(
                                //   context,
                                //   SliderTransition(
                                //     NavbarScreen(
                                //       selectedPageIndex: 4,
                                //     ),
                                //   ),
                                // );
                                await ApiCallManagement()
                                    .rdwRegisterUnregister(2, context)
                                    .then((value) async {
                                  await storeString(
                                      'US_RDW_UUID', value['uuid']);
                                  var uuidJson = {
                                    'type': 'CONSENTRETURN',
                                    'subscriptionId': value['uuid']
                                  };
                                  String link = await createDeepLink(
                                    value['uuid'],
                                    uuidJson,
                                    RDW_REVOKE_URL,
                                  );
                                  if (await canLaunch(link)) {
                                    await launch(link,
                                        forceWebView: false,
                                        forceSafariVC: false);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('home',
                                            (Route<dynamic> route) => false);
                                  } else {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('home',
                                            (Route<dynamic> route) => false);
                                    throw 'Could not launch $link';
                                  }

                                });
                              },
                              child: Container(
                                constraints: BoxConstraints(minHeight: 55),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: AppColors.primary, width: 1)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Spacer(
                                      flex: 3,
                                    ),
                                    Text(
                                      LocaleKeys.UNLINKDRIVERS_UNLINKDRLICENSE
                                          .tr(),
                                      style:
                                          AppFont.identityButtonFont.copyWith(
                                        color: AppColors.primary,fontSize: 18.sp
                                      ),
                                    ),
                                    Spacer(
                                      flex: 2,
                                    ),
                                    SvgPicture.asset(
                                        'assets/svgs/goOutRDW.svg'),
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 75,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                // pushNewScreen(
                                //   context,
                                //   screen:RDWDLlinkedScreen() ,
                                //   withNavBar: true, // OPTIONAL VALUE. True by default.
                                //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                // );
                              },
                              child: Container(
                                constraints: BoxConstraints(minHeight: 55),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.primary,
                                ),
                                child: Center(
                                    child: Text(
                                  LocaleKeys.UNLINKDRIVERS_KEEPMEPROTECTED.tr(),
                                  style: AppFont.identityButtonFont
                                      .copyWith(color: AppColors.clearWhite,fontSize: 18.sp),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
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
                    LocaleKeys.IDENTITIES_INPARTNERSHIPWITH.tr(),
                    style: AppFont.H3.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Image.asset(
                    'assets/images/rdw.png',
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




// Container(
//                       constraints: BoxConstraints(minHeight: 55),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.transparent,
//                           border: Border.all(color: Colors.blue, width: 2)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Text('Unlink Drivers license'),
//                           Icon(Icons.open_in_new_rounded),
//                         ],
//                       ),
//                     )