import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';

import '../../Utils/styles.dart';
import '../../widgets/globalWidgets.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

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
          child: ListView(
        children: [
          HelpTile(
            title: 'FAQ',
            assetSvg: 'h_question',
            ontap: () {},
          ),
          HelpTile(
            title: 'Contact',
            assetSvg: 'a_mail',
            ontap: () {},
          ),
          HelpTile(
            title: 'Terms & Conditions',
            assetSvg: 'h_terms',
            ontap: () {},
          ),
        ],
      )),
    );
  }
}

class HelpTile extends StatelessWidget {
  String title;
  String assetSvg;
  VoidCallback ontap;

  HelpTile({required this.title, required this.assetSvg, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 8.h),
          tileColor: Colors.white,
          leading: Container(
            height: 24.h,
            width: 25.w,
            child: SvgPicture.asset(
              'assets/svgs/$assetSvg.svg',
              height: 32.h,
              color: Colors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          title: Text(title,
              style: AppFont.H3.copyWith(
                  fontWeight: FontWeight.w400, color: AppColors.clearBlack)),
        ),
      ),
    );
  }
}
