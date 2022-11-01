import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/widgets/globalWidgets.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:provider/provider.dart';

class ChangeEmailScreen extends StatefulWidget {
  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  TextEditingController emailTag = TextEditingController();

  @override
  void initState() {
    setState(() {
      emailTag.text = userEmail;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading:
               InkWell(
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
                  LocaleKeys.NAVBARCONTENT_EMAIL.tr(),
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
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          LabelField(
            title: LocaleKeys.ACCOUNT_EMAIL_EMAILADDRESS.tr(),
            controller: emailTag,
            disabled: true,
            scrollPadding: EdgeInsets.only(bottom: SCREENHEIGHT.h * 0.4),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                color: AppColors.lightPrimaryStrip,
              ),
              padding: EdgeInsets.all(20.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //!
                children: [
                  SvgPicture.asset(
                    'assets/svgs/info.svg',
                    height: 50.h,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  SizedBox(
                    width: SCREENWIDTH.w * 0.63,
                    child: Text(
                      LocaleKeys.ACCOUNT_EMAIL_CONTENT.tr(),
                      style: AppFont.s1,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
