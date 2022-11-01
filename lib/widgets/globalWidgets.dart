import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../Utils/styles.dart';

class FilledButton extends StatelessWidget {
  String title;
  final bool iconButton;
  IconData? buttonIcon;
  VoidCallback ontap;
  bool isLoadingFilledBtn;
  FilledButton(
      {required this.title,
      required this.ontap,
      required this.isLoadingFilledBtn})
      : iconButton = false,
        buttonIcon = null;

  FilledButton.iconButton(
      {required this.title,
      required this.buttonIcon,
      required this.ontap,
      required this.isLoadingFilledBtn})
      : iconButton = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width:
          iconButton ? double.infinity : MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
          color: AppColors.primary, borderRadius: BorderRadius.circular(8.sp)),
      child: TextButton(
          onPressed: ontap,
          child: iconButton
              ? Row(
                  children: [Text(title,style: TextStyle(fontSize: 18.sp),), Icon(buttonIcon)],
                )
              : isLoadingFilledBtn
                  ? Container(
                      padding: EdgeInsets.all(10.sp),
                      child: LoadingAnimationWidget.prograssiveDots(
                        color: AppColors.clearWhite,
                        size: 55.sp,
                      ),
                    )
                  : Text(
                      title,
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    )),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  String title;
  Function() ontap;
  SecondaryButton({required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 1),
          // color: AppColors.primary,
          borderRadius: BorderRadius.circular(8)),
      child: TextButton(
          onPressed: ontap,
          child: Text(
            title,
            style: TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w600,fontSize: 18.sp),
          )),
    );
  }
}

class LabelField extends StatefulWidget {
  String title;
  final bool disabled;
  final Widget? trailing;
  TextEditingController? controller;
  String? placeHolder = '';
  bool? ifPassword = false;
  EdgeInsets scrollPadding = EdgeInsets.zero;
  String? onChange;
  int? restrictChars;

  LabelField(
      {required this.title,
      this.disabled = false,
      this.trailing,
      required this.controller,
      this.placeHolder,
      this.ifPassword = false,
      required this.scrollPadding,
      this.onChange,
      this.restrictChars = null,
      });

  @override
  State<LabelField> createState() => _LabelFieldState();
}

class _LabelFieldState extends State<LabelField> {
  bool isPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppFont.s1.copyWith(color: AppColors.clearBlack,fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 60.h,
            decoration: !widget.disabled
                ? BoxDecoration(
                    color: AppColors.clearWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.clearGrey))
                : BoxDecoration(
                    color: AppColors.disableColor,
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.clearGrey)),
            child: TextFormField(
              onChanged: (value) {
                if (widget.onChange != null && widget.onChange! == 'NEW') {
                  RegExp regex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~]).{8,}$');
                  if (!regex.hasMatch(value)) {
                    Provider.of<MainProvider>(context, listen: false)
                        .setPasswordValidatorChangePassword(true);
                  } else {
                    Provider.of<MainProvider>(context, listen: false)
                        .setPasswordValidatorChangePassword(true);
                  }
                } else if (widget.onChange != null &&
                    widget.onChange! == 'OLD') {
                  RegExp regex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~]).{8,}$');
                  if (!regex.hasMatch(value)) {
                    Provider.of<MainProvider>(context, listen: false)
                        .setPasswordValidatorOldChangePassword(true);
                  } else {
                    Provider.of<MainProvider>(context, listen: false)
                        .setPasswordValidatorOldChangePassword(true);
                  }
                }
              },
              style: AppFont.s1.copyWith(color: AppColors.clearBlack, fontWeight: FontWeight.w400),
              controller: widget.controller,
              enabled: !widget.disabled,
              obscureText: (widget.ifPassword != null && widget.ifPassword!)
                  ? isPassword
                  : false,
              textAlign: TextAlign.left,
              maxLength: widget.restrictChars,
              scrollPadding: widget.scrollPadding,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.only(left: 10.sp),
                hintText: widget.placeHolder,
                suffixIcon: widget.trailing != null
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                        child: isPassword
                            ? widget.trailing
                            : Icon(
                                Icons.visibility_off,
                                color: AppColors.iconGrey,
                                size: 20,
                              ))
                    : null,
                border: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  const InfoField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.clearWhite,
            border: Border.all(
              color: AppColors.primary,
            )),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text(
              'Are you sure you want to delete all the data and your account?'),
        ),
      ),
    );
  }
}

class AuthTextfield extends StatelessWidget {
  final String hintTitle;
  final TextEditingController tController;
  final String svgName;
  AuthTextfield(
      {required this.hintTitle,
      required this.svgName,
      required this.tController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
      ),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
        22,
      )),
      child: TextFormField(
        controller: tController,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(
                    0.3,
                  ),
                )),
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.0),
              child: SvgPicture.asset('assets/svgs/$svgName.svg',
                  height: 12, fit: BoxFit.contain, color: AppColors.clearGrey),
            ),
            fillColor: Colors.black.withOpacity(
              0.3,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.black.withOpacity(
                  0.3,
                ))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
              14,
            )),
            labelText: hintTitle,
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.placeHolderGrey,
            )),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final String hintTitle;
  final TextEditingController tController;
  // final String prefixSvg;
  // final String suffixSvg;

  PasswordField({
    required this.hintTitle,
    // required this.prefixSvg,
    required this.tController,
    // required this.suffixSvg
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
      ),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
      child: TextFormField(
        validator: (password) {
          if (password!.isEmpty) {
            return "Enter the password";
          } else {
            return null;
          }
        },
        controller: tController,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.clearGrey,
                )),
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.0),
              child: SvgPicture.asset('assets/svgs/lock.svg',
                  color: AppColors.clearGrey),
            ),
            fillColor: AppColors.clearGrey,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.clearGrey)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            labelText: hintTitle,
            suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svgs/eye.svg',
                    color: AppColors.clearGrey)),
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.placeHolderGrey,
            )),
      ),
    );
  }
}

class labelRow extends StatelessWidget {
  String title;
  String? info;
  final bool recognizedEvent;
  bool? recognized;
  bool? greenClr = false;
  bool? redClr = false;
  bool isBold = false;
  bool isSize = false;

  labelRow({required this.title, required this.info, this.greenClr, this.redClr,this.isBold = false, this.isSize = false}) : recognizedEvent = false;

  labelRow.recognized({
    required this.title,
    required this.recognized,
  }) : recognizedEvent = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // color: Colors.red,
            width: SCREENWIDTH.w * 0.28,
            child: Text(
              '$title:',
              style: isSize? AppFont.rowLabel2 : AppFont.rowLabel,
            ),
          ),
          !recognizedEvent
              ? Expanded(
                child: Text(
                    info!,
                    style: AppFont.rowLabel.copyWith(
                      color: !(greenClr==null) ? Colors.green[600] : !(redClr==null) ? Colors.red : Color(0xff061025).withOpacity(0.8),
                      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
              )
              : recognized!
                  ? Text(
                      LocaleKeys.ALERTS_RECOGNIZED.tr(),
                      style: AppFont.rowLabel.copyWith(
                          color: AppColors.successStripForeground,
                          fontWeight: FontWeight.w700),
                    )
                  : Text(
                      LocaleKeys.ALERTS_NOTRECOGNIZED.tr(),
                      style: AppFont.rowLabel.copyWith(
                          color: AppColors.failureStripForeground,
                          fontWeight: FontWeight.w700,),
                    ),
          // Text(info,
          //     style: recognized!
          //         ? AppFont.rowLabel.copyWith(color: Colors.red)
          //         : AppFont.rowLabel.copyWith(color: Colors.green))
        ],
      ),
    );
  }
}

Widget stripAlert(bool succesBool, String content) {
  return Container(
    padding: EdgeInsets.all(10.sp),
    width: double.infinity,
    color: succesBool ? AppColors.successStrip : AppColors.failureStrip,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
          ),
          succesBool
              ? SvgPicture.asset(
                  "assets/svgs/check.svg",
                  height: 20.h,
                )
              : SvgPicture.asset(
                  "assets/svgs/error.svg",
                  height: 20.h,
                ),
          SizedBox(
            width: 20.w,
          ),
          SizedBox(
            width: SCREENWIDTH.w * 0.7,
            child: Text(
              content,
              textAlign: TextAlign.left,
              style: AppFont.normal.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: succesBool
                    ? AppColors.successStripForeground
                    : AppColors.failureStripForeground,
              ),
              // textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
