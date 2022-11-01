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
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/RDW/dlLinked.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../widgets/navbar.dart';

var storeUuid;

class IdentityPage extends StatefulWidget {
  bool loading = false;

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  String? finalid = "";
  Future getUserId() async {
    String? tempid = await getString('localuserid') ?? '';
    setState(() {
      finalid = tempid;
    });
    print("Got the value" + finalid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
      ),
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
                color: AppColors.lgBlue,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 38.h, horizontal: 28.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.LINKDRIVERS_CONTENT.tr(),
                      ),
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
                            child: InkWell(
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: RDWDLlinkedScreen(),
                                  withNavBar:
                                      true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
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
                                  onTap: () async {
                                    await ApiCallManagement()
                                        .rdwRegisterUnregister(1, context)
                                        .then((value) async {
                                      setState(() {
                                        widget.loading = true;
                                      });
                                      await storeString('firstTimeUser', 'NO');
                                      await storeString(
                                          'US_RDW_UUID', value['uuid']);
                                      var uuidJson = {
                                        'type': 'CONSENTRETURN',
                                        'subscriptionId': value['uuid']
                                      };
                                      String link = await createDeepLink(
                                        value['uuid'],
                                        uuidJson,
                                        RDW_CONSENT_URL,
                                      );

                                      if (await canLaunch(link)) {
                                        await launch(link,
                                            forceWebView: false,
                                            forceSafariVC: false);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                'home',
                                                (Route<dynamic> route) =>
                                                    false);
                                      } else {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                'home',
                                                (Route<dynamic> route) =>
                                                    false);
                                        throw 'Could not launch $link';
                                      }

                                      // if (!await launchUrl(Uri.parse(link))) {
                                      //   throw 'Could not launch ${Uri.parse(link)}}';
                                      // }
                                      setState(() {
                                        widget.loading = false;
                                      });
                                    });
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
                                        LocaleKeys.LINKDRIVERS_LINKDRLICENSE
                                            .tr(),
                                        style:
                                            AppFont.identityButtonFont.copyWith(
                                          color: AppColors.clearWhite,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Spacer(
                                        flex: 2,
                                      ),
                                      widget.loading
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: AppColors.clearWhite
                                                    .withOpacity(0.6),
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              'assets/svgs/goOutRDW.svg',
                                              color: AppColors.clearWhite,
                                            ),
                                      SizedBox(
                                        width: 15.w,
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






// Padding(
//               padding: EdgeInsets.symmetric(vertical: 38.h, horizontal: 32.w),
//               child: Container(
//                 color: Colors.amber,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Text(
//                       'Link your drivers license and receive alerts when your drivers license is checked by an organization. Now you can act on fraudulent events surrounding your drivers license. ',
//                       maxLines: 4,
//                     ),

//                     // Row(children: [
//                     //   Image.asset(
//                     //     'assets/images/digidlogo.png',
//                     //     scale: 55,
//                     //   ),

//                     // ])
//                     // Container(
//                     //   width: double.infinity,
//                     //   child: Row(
//                     //     children: [
//                     //       FilledButton(
//                     //         title: 'Link Drivers license',
//                     //         // buttonIcon: Icons.open_in_new,
//                     //       )
//                     //     ],
//                     //   ),
//                     // )
//                   ],
//                 ),
//               ),
//             ),