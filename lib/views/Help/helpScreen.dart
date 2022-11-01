import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/views/Help/TermsAndConditionScreen.dart';
import 'package:iKCHECK/views/Help/contactScreen.dart';
import 'package:iKCHECK/views/Help/faqScreen.dart';
import 'package:iKCHECK/views/Help/privacyPolicyScreen.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HelpScreen extends StatefulWidget {
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  LocaleKeys.HELP_HELP.tr(),
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
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HelpTile(
                  title: LocaleKeys.HELP_FAQHEADER.tr(),
                  assetSvg: 'questionHelp',
                  ontap: () {
                    pushNewScreen(
                      context,
                      screen:FAQ() ,
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  color: AppColors.clearBlack,
                  height: 35.sp,
                ),
                HelpTile(
                  title: LocaleKeys.COMMON_CONTACT.tr(),
                  assetSvg: 'mailHelp',
                  ontap: () {
                    pushNewScreen(
                      context,
                      screen:ContactScreen() ,
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  color: AppColors.clearBlack,
                  height: 25.sp,
                ),
                HelpTile(
                  title: LocaleKeys.HELP_TERMSANDCONDITIONS.tr(),
                  assetSvg: 'fileHelp',
                  ontap: () {
                    pushNewScreen(
                      context,
                      screen:TermsAndConditionScreen() ,
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  color: AppColors.clearBlack,
                  height: 32.sp,
                ),
                HelpTile(
                  title: LocaleKeys.HELP_PRIVACYPOLICY.tr(),
                  assetSvg: 'fileHelp',
                  ontap: () {
                    pushNewScreen(
                      context,
                      screen:PrivacyPolicyScreen() ,
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  color: AppColors.clearBlack,
                  height: 32.sp,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: Text(
                '${LocaleKeys.HELP_VERSION.tr()} ${_packageInfo.version}',
                style: AppFont.s1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpTile extends StatelessWidget {
  String title;
  String assetSvg;
  VoidCallback ontap;
  double height;
  Color color;
  HelpTile(
      {required this.title,
      required this.assetSvg,
      required this.ontap,
      required this.height,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.5),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          color: AppColors.clearWhite,
          height: 85.h,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 30.w,
              ),
              SizedBox(
                width: 40.w,
                child: SvgPicture.asset(
                  'assets/svgs/$assetSvg.svg',
                  height: height,
                  color: color,
                ),
              ),
              SizedBox(
                width: 25.w,
              ),
              Text(
                title,
                style: AppFont.H3.copyWith(
                    fontWeight: FontWeight.w400, color: AppColors.clearBlack),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios_rounded),
              SizedBox(
                width: 25.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
