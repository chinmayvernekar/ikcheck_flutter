import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
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
                  bottom: true,
                  top: true,
                  child: SizedBox(
                    height: SCREENHEIGHT.h * 0.8,
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          LoadingAnimationWidget.prograssiveDots(
                            color: AppColors.primary,
                            size: 40.sp,
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
