import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/services/notificationManagement.dart';
import 'package:iKCHECK/views/Auth/signupScreen.dart';
import 'package:iKCHECK/views/auth/ForgotPasswordScreen.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:launch_review/launch_review.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../widgets/svgIcons.dart';

class NewVersionScreen extends StatefulWidget {
  const NewVersionScreen({Key? key}) : super(key: key);

  @override
  State<NewVersionScreen> createState() => _NewVersionScreenState();
}

class _NewVersionScreenState extends State<NewVersionScreen> {
  @override
  void initState() {
    super.initState();
  }

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.clearWhite,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: SCREENHEIGHT.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: SCREENHEIGHT.h * -0.38,
                  left: SCREENHEIGHT.h * -0.17,
                  child: Image.asset(
                    "assets/images/ec.png",
                    width: SCREENWIDTH.w * 0.85,
                    height: SCREENHEIGHT.h * 0.73,
                    color: AppColors.secondaryBlue,
                  ),
                ),
                Positioned(
                  bottom: SCREENHEIGHT.h * -0.50,
                  right: SCREENHEIGHT.h * -0.32,
                  child: Image.asset(
                    "assets/images/ec.png",
                    width: SCREENWIDTH.w * 1.35,
                    height: SCREENHEIGHT.h * 0.74,
                    alignment: Alignment.center,
                    color: AppColors.teritoryBlue,
                  ),
                ),
                SafeArea(
                  top: true,
                  bottom: true,
                  child: SizedBox(
                    height: SCREENHEIGHT.h * 0.8,
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp),
                              border: Border.all(
                                width: 1.sp,
                                color: AppColors.ashColor,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.sp),
                              child: Image.asset(
                                'assets/images/logoHD.png',
                                height: SCREENHEIGHT.h * 0.15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SCREENHEIGHT.h * 0.15,
                          ),
                          SizedBox(
                            width: 253.w,
                            child: Text(
                              LocaleKeys.LOGINANDREGISTER_NEWVERSIONCONTENT
                                  .tr(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 24.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80.h,
                          ),
                          SizedBox(
                            width: 253.w,
                            height: 55.h,
                            child: ElevatedButton(
                              onPressed: () {
                                LaunchReview.launch(
                                    androidAppId: "check.app",
                                    iOSAppId: "1591429156",
                                    writeReview: false);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                ),
                              ),
                              child: Text(
                                LocaleKeys.COMMON_UPDATE.tr(),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
