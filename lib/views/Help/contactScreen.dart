import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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
                LocaleKeys.COMMON_CONTACT.tr(),
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
      body: Container(
        child: ListView(
          children: [
            HelpTile(
              title: 'info@ikcheck.com',
              assetSvg: 'atTheRateContact',
              ontap: () async {
                final Uri params = Uri(
                  scheme: 'mailto',
                  path: 'info@ikcheck.com',
                );
                await launchUrl(params);
              },
              color: AppColors.clearBlack,
              height: 28.h,
            ),
            HelpTile(
              title: '(+31) 85 047 01 49',
              assetSvg: 'phoneContact',
              ontap: () async {
                final tel = 'tel:+31850470149';
                await launch(tel);
              },
              color: AppColors.clearBlack,
              height: 25.h,
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
      padding: const EdgeInsets.only(top: 2.0),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 35.w, vertical: 8.h),
            tileColor: Colors.white,
            leading: SvgPicture.asset(
              'assets/svgs/$assetSvg.svg',
              height: height,
              color: color,
            ),
            title: Text(
              title,
              style: AppFont.H3.copyWith(
                  fontWeight: FontWeight.w400, color: AppColors.clearBlack),
            ),
          ),
        ),
      ),
    );
  }
}
