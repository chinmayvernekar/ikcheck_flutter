import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/styles.dart';

String svgicon1 = 'assets/svgs/person.svg';
final Widget personSvg = SvgPicture.asset(svgicon1,
    color:  AppColors.clearGrey,fit: BoxFit.scaleDown, height: 15, width: 15);

String svgicon3 = 'assets/svgs/lock.svg';
final Widget lockSvg = SvgPicture.asset(
  svgicon3,
  color: AppColors.clearGrey,
  fit: BoxFit.scaleDown,
  height: 8.h,
  // width: 18.w,
);

String svgicon4 = 'assets/svgs/eye.svg';
final Widget eyeSvg = SvgPicture.asset(
  svgicon4,
  color: AppColors.iconGrey,
  fit: BoxFit.scaleDown,
  height: 15,
  width: 15,
);

String svgicon5 = 'assets/svgs/keys.svg';
final Widget keySvg = SvgPicture.asset(
  svgicon5,
  color: Colors.red,

// width: 10,
);
