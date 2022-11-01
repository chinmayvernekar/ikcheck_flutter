import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppColors {
  static Color primary = Color(0xff2374f5);
  //static Color primary = Color(0xFFff4e00 );
  // static Color primary = Color(0xff2474F5);
  static Color primaryLight = Color(0xffA8C6FA);
  static Color lightPrimaryStrip = Color(0xffBDD3FF).withOpacity(0.4);
  static Color unselectedIcon = Color(0xff000000).withOpacity(0.5);
  static Color labelBorder = Color(0xff000000).withOpacity(0.3);
  static Color clearWhite = Color(0xffFFFFFF);
  static Color clearBlack = Color(0xff000000);
  static Color background = Color(0xffF7F7FA);
  static Color successStrip = Color(0xffD4EDDA);
  static Color failureStrip = Color(0xffF8D7DA);
  static Color failureStripForeground = Color(0xffDC3545);
  static Color successStripForeground = Color(0xff28A745);
  static Color alertStrip = Color(0xffFD0002);
  static Color fraudRed = Color(0xfffd0103);
  static Color ashColor = Color(0xffE5E5E5);
  static Color lgRed = Color(0xFFFCC4C4);
  static Color dkRed = Color(0xffDC3545);
  static Color lgBlue = Color(0xFFE0E9FC);
  static Color slachtofferPurple = Color(0xffA237BC);
  static Color clearGrey = const Color(0xffB3B3B3);
  static Color placeHolderGrey = const Color(0xff808080);
  static Color iconGrey = const Color(0xffcccccc);
  static Color iconGrey1 = const Color(0xffB9B9BC);
  static Color msgIconBorder = const Color(0xffbfbfbf);
  static Color disableColor = const Color(0xffDEDEE1);
  static Color black1 = const Color(0xff474747);
  static Color black2 = const Color(0xff4a4a4b);
  static Color black3 = const Color(0xff333333);
  static Color secondaryBlue = const Color(0xffdcebfc);
  static Color teritoryBlue = const Color(0xffc4d9fc);
  static Color warningColor = const Color(0xffffc107);
  static Color transparent = Colors.transparent;
  static Color errorRed = Color(0xffd32f2f);
}

abstract class AppFont {
  static TextStyle H1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 35.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.clearBlack,
  );
  static TextStyle H2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle H3 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle normal = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle iconLabel = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle s1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle messageTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle messageSubtitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle question = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.clearBlack,
  );

  static TextStyle rowLabel = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle rowLabel2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle defaulsmalltHeading = TextStyle(
      fontFamily: 'Poppins', fontSize: 20.sp, fontWeight: FontWeight.w600);

  static TextStyle vtmSupportText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle errorText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle identityButtonFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );
}
