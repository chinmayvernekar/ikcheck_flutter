import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/icons/icons.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/Auth/ForgotPasswordScreen.dart';
import 'package:iKCHECK/views/Auth/SignInScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../widgets/svgIcons.dart';

bool greenstrip = false;
bool redstrip = false;
bool showsize = false;

class SecondForgotPasswordScreen extends StatefulWidget {
  final String email;
  final bool isPasswordExpired;
  SecondForgotPasswordScreen({required this.email, this.isPasswordExpired = false});

  @override
  State<SecondForgotPasswordScreen> createState() =>
      _SecondForgotPasswordScreenState();
}

class _SecondForgotPasswordScreenState
    extends State<SecondForgotPasswordScreen> {
  bool isLoadingResetPd = false;
  bool obsurePassword = false;
  String stripContent = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await storeString('PATH_FOR_IPAD', 'FORGETPASSWORD_2');
      await storeString('EMAIL_FOR_IPAD', widget.email);
    });
  }
  void showgreenStripAgain() {
    setState(() {
      greenstrip = true;
    });
  }

  void showSize() {
    setState(() {
      showsize = true;
    });
  }

  void dontshowSize() {
    setState(() {
      showsize = false;
    });
  }

  Widget redWid(BuildContext context) {
    return Visibility(
      maintainSize: showsize,
      maintainAnimation: true,
      maintainState: true,
      visible: redstrip,
      child: Container(
        height: 40,
        width: double.infinity,
        color: AppColors.failureStrip,
        child: Center(
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 45),
                  child: SvgPicture.asset("assets/svgs/error.svg")),
              SizedBox(
                width: 10.w,
              ),
              Text(
                stripContent,
                textAlign: TextAlign.center,
                style: AppFont.normal.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.failureStripForeground,
                    fontSize: 14.sp),
                // textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  forgotPasswordScreenApi(String email, String type) async {
    Map data = {"loginId": email, "type": null};
    var jsonData = null;
    var response = await ApiCallManagement().forgotPasswordScreenApi(data);

    if (response.statusCode == 200) {
      jsonData = jsonEncode(response.body);
      print("Forgot Password" + response.body);
      showgreenStripAgain();
      Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: greenstrip,
        child: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 50.sp),
          width: double.infinity,
          color: AppColors.successStrip,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/svgs/tick.svg"),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                child: Text(
                  '${LocaleKeys.LOGINANDREGISTER_CODESENTTO.tr()} ${widget.email}',
                  style: AppFont.normal.copyWith(
                    color: AppColors.successStripForeground,

                    fontSize: 13.sp,
                    // fontWeight: FontWeight.bold),
                    // textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      print("getting error response");
      print(response.body);
      showSize();

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(response.body.substring(31, 56))));
    }
  }

  void showRedStrip() {
    setState(() {
      redstrip = true;
    });
  }

  void hideRedStrip() {
    setState(() {
      stripContent = '';
      redstrip = false;
    });
  }

  TextEditingController passcodeController = TextEditingController();
  TextEditingController recoverController = TextEditingController();
  TextEditingController reenterpasswordController = TextEditingController();
  bool passwordValidator = false;
  resetPassword(String mail, String password, String passcode) async {
    Map body = {
      'loginId': widget.email,
      'password': password,
      'passcode': passcode
    };
    var jsonData = null;
    var response = await ApiCallManagement().resetPassword(body);

    if (response.statusCode == 200) {
      jsonData = jsonEncode(response.body);
      print("reset password" + response.body);
      passcodeController.clear();
      recoverController.clear();
      reenterpasswordController.clear();
      setState(() {
        passwordValidator = false;
      });
      // Get.to(NewScreen());
      var route = PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => SignInScreen(
          stripContent: LocaleKeys.LOGINANDREGISTER_PASSWORDHASBEENRESET.tr(),
          stripStatus: true,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
      Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) {
        return route.isFirst;
      });
    } else if (response.statusCode == 404) {
      showRedStrip();
      stripContent = LocaleKeys.LOGINANDREGISTER_RECOVERYCODEINVALID.tr();
    } else {
      print("getting error response");
      print(response.body);
      showRedStrip();
      stripContent = LocaleKeys.LOGINANDREGISTER_PWMISMATCH.tr();

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(response.body.substring(31, 56))));
    }
  }

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Widget GreenWid(BuildContext context) {
      return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: greenstrip,
        child: Container(
          width: SCREENWIDTH.w,
          // width: SCREENWIDTH.w,
          color: AppColors.successStrip,
          child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 50.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/svgs/tick.svg"),
                SizedBox(
                  width: 10.w,
                ),
                Flexible(
                  child: Text(
                    '${LocaleKeys.LOGINANDREGISTER_CODESENTTO.tr()} ${widget.email}',
                    softWrap: true,
                    style: AppFont.normal.copyWith(
                      color: AppColors.successStripForeground,
                      fontSize: 13.sp,
                      // fontWeight: FontWeight.bold),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    print("getting email" + widget.email);
    Size size = MediaQuery.of(context).size;
    final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: AppColors.clearWhite,
      body: Container(
        width: double.infinity,
        height: size.height,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: size.height * -0.38,
                left: size.height * -0.17,
                child: Image.asset(
                  "assets/images/ec.png",
                  width: size.width * 0.85,
                  height: size.height * 0.73,
                  color: AppColors.secondaryBlue,
                ),
              ),
              Positioned(
                bottom: size.height * -0.50,
                right: size.height * -0.32,
                child: Image.asset(
                  "assets/images/ec.png",
                  width: size.width * 1.35,
                  height: size.height * 0.74,
                  alignment: Alignment.center,
                  color: AppColors.teritoryBlue,
                ),
              ),
              SafeArea(
                bottom: true,
                top: true,
                child: SizedBox(
                  // height: size.height * 0.8,
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 70.h,
                        ),
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
                          height: 65.h,
                        ),
                        Text(
                          isPasswordExpiredG ? LocaleKeys.LOGINANDREGISTER_RESETPASSWORD.tr() :LocaleKeys.LOGINANDREGISTER_FORGETPASSWORDTITLE.tr(),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 22.sp),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        greenstrip ? GreenWid(context) : redWid(context),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          width: 331.w,
                          // height: 55.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp)),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (code) {
                              if (code!.isEmpty ||
                                  !RegExp(r'^[0-9]{1,6}$').hasMatch(code)) {
                                return LocaleKeys.ALERTMESSAGE_INVALIDPC.tr();
                              } else {
                                return null;
                              }
                            },
                            controller: recoverController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.sp,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide: BorderSide(
                                      color: AppColors.clearGrey,
                                    )),
                                prefixIcon: Icon(
                                  IkCheckKey.keyIcon,
                                  size: 18,
                                  color: AppColors.clearGrey,
                                ),
                                fillColor: AppColors.clearGrey,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide:
                                        BorderSide(color: AppColors.clearGrey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp)),
                                labelText:
                                    LocaleKeys.LOGINANDREGISTER_RCVYCD.tr(),
                                labelStyle: GoogleFonts.poppins(
                                  color: AppColors.placeHolderGrey,
                                  fontSize: 16.sp,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 331.w,
                          child: GestureDetector(
                            onTap: () {
                              recoverController.clear();
                              hideRedStrip();
                              forgotPasswordScreenApi(
                                  widget.email, "activation code");
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: ((context) {
                              //       return SecondForgotPasswordScreen();
                              //     }),
                              //   ),
                              // );
                            },
                            child: Text(
                              LocaleKeys.LOGINANDREGISTER_REQNEWCD.tr(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        Container(
                          width: 331.w,
                          // height: 55.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp)),
                          child: TextFormField(
                            // validator: (email) {
                            //   RegExp regex = RegExp(
                            //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~]).{8,}$');
                            //   // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\%$&*~]).{8,}$');
                            //   if (email!.isEmpty) {
                            //     return LocaleKeys.ALERTMESSAGE_INVALIDPW.tr();
                            //   } else if (!regex.hasMatch(email)) {
                            //     return '${LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA1.tr()}' +
                            //         '\n' +
                            //         '${LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA2.tr()}' +
                            //         '\n' +
                            //         '${LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA3.tr()}';
                            //   } else {
                            //     return null;
                            //   }
                            // },
                            // validator: (value) {
                            //   RegExp regex = RegExp(
                            //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~]).{8,}$');
                            //   if (value!.isEmpty) {
                            //     setState(() {
                            //       passwordValidator = false;
                            //     });
                            //     return LocaleKeys.ALERTMESSAGE_INVALIDPW.tr();
                            //   } else {
                            //     setState(() {
                            //       passwordValidator = true;
                            //     });
                            //   }
                            // },
                            onChanged: (value) {
                              // formkey.currentState!.validate();
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~]).{8,}$');
                              if (!regex.hasMatch(value)) {
                                setState(() {
                                  passwordValidator = true;
                                });
                              } else {
                                setState(() {
                                  passwordValidator = true;
                                });
                              }
                            },
                            controller: passcodeController,
                            obscureText: !obsurePassword,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.sp),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide: BorderSide(
                                        color: (passcodeController.text.isEmpty &&
                                                passwordValidator)
                                            ? AppColors.errorRed
                                            : AppColors.clearGrey)),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(bottom: 3.sp),
                                  child: lockSvg,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obsurePassword = !obsurePassword;
                                    });
                                  },
                                  child: obsurePassword
                                      ? eyeSvg
                                      : Icon(
                                          Icons.visibility_off,
                                          color: AppColors.iconGrey,
                                          size: 20,
                                        ),
                                ),
                                fillColor: AppColors.clearGrey,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide: BorderSide(
                                        color:
                                            (passcodeController.text.isEmpty &&
                                                    passwordValidator)
                                                ? AppColors.errorRed
                                                : AppColors.clearGrey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide: BorderSide(
                                        color:
                                            (passcodeController.text.isEmpty &&
                                                    passwordValidator)
                                                ? AppColors.errorRed
                                                : AppColors.clearGrey)),
                                labelText: LocaleKeys.LOGINANDREGISTER_NEWPW.tr(),
                                labelStyle: GoogleFonts.poppins(color: AppColors.placeHolderGrey, fontSize: 16.sp)),
                          ),
                        ),
                        if (passwordValidator)
                          Container(
                            width: 338.w,
                            child: passcodeController.text.isEmpty
                                ? Container(
                                    padding: EdgeInsets.only(top: 10.sp),
                                    child: Text(
                                      LocaleKeys.ALERTMESSAGE_INVALIDPW.tr(),
                                      style: AppFont.errorText.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.errorRed,
                                      ),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (passcodeController.text.length <= 7)
                                              ? Icon(
                                                  Icons.close,
                                                  color: AppColors.errorRed,
                                                  size: 20.sp,
                                                )
                                              : Icon(
                                                  Icons.done,
                                                  size: 20.sp,
                                                  color: AppColors
                                                      .successStripForeground,
                                                ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            LocaleKeys
                                                .ALERTMESSAGE_PASSWORDPATTERN_DATA1
                                                .tr(),
                                            softWrap: true,
                                            style: AppFont.errorText.copyWith(
                                              color: (passcodeController
                                                          .text.length <=
                                                      7)
                                                  ? AppColors.errorRed
                                                  : AppColors
                                                      .successStripForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])')
                                                  .hasMatch(
                                                      passcodeController.text))
                                              ? Icon(
                                                  Icons.done,
                                                  size: 20.sp,
                                                  color: AppColors
                                                      .successStripForeground,
                                                )
                                              : Icon(
                                                  Icons.close,
                                                  color: AppColors.errorRed,
                                                  size: 20.sp,
                                                ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            LocaleKeys
                                                .ALERTMESSAGE_PASSWORDPATTERN_DATA2
                                                .tr(),
                                            style: AppFont.errorText.copyWith(
                                              color: (RegExp(
                                                          r'^(?=.*?[A-Z])(?=.*?[a-z])')
                                                      .hasMatch(
                                                          passcodeController
                                                              .text))
                                                  ? AppColors
                                                      .successStripForeground
                                                  : AppColors.errorRed,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (RegExp(r'^(?=.*?[0-9])')
                                                      // r'^(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                                      .hasMatch(
                                                          passcodeController
                                                              .text) &&
                                                  RegExp(r'(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                                      .hasMatch(
                                                          passcodeController
                                                              .text))
                                              ? Icon(
                                                  Icons.done,
                                                  size: 20.sp,
                                                  color: AppColors
                                                      .successStripForeground,
                                                )
                                              : Icon(
                                                  Icons.close,
                                                  color: AppColors.errorRed,
                                                  size: 20.sp,
                                                ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            replaceSpecials(LocaleKeys
                                                .ALERTMESSAGE_PASSWORDPATTERN_DATA3
                                                .tr()),
                                            style: AppFont.errorText.copyWith(
                                              color: (RegExp(r'^(?=.*?[0-9])')
                                                          // r'^(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                                          .hasMatch(
                                                              passcodeController
                                                                  .text) &&
                                                      RegExp(r'(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                                          .hasMatch(
                                                              passcodeController
                                                                  .text))
                                                  ? AppColors
                                                      .successStripForeground
                                                  : AppColors.errorRed,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          width: 331.w,
                          // height: 55.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp)),
                          child: TextFormField(
                            scrollPadding:
                                EdgeInsets.only(bottom: size.height * 0.5),
                            validator: (email) {
                              if (email!.isEmpty ||
                                  passcodeController.text !=
                                      reenterpasswordController.text) {
                                return LocaleKeys.ALERTMESSAGE_INVALIDPW.tr();
                              } else {
                                return null;
                              }
                            },
                            obscureText: !obsurePassword,
                            controller: reenterpasswordController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.sp),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide: BorderSide(
                                      color: AppColors.clearGrey,
                                    )),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(bottom: 3.sp),
                                  child: lockSvg,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obsurePassword = !obsurePassword;
                                    });
                                  },
                                  child: obsurePassword
                                      ? eyeSvg
                                      : Icon(
                                          Icons.visibility_off,
                                          color: AppColors.iconGrey,
                                          size: 20,
                                        ),
                                ),
                                fillColor: AppColors.clearGrey,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide:
                                        BorderSide(color: AppColors.clearGrey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp)),
                                labelText: LocaleKeys
                                    .LOGINANDREGISTER_NEWPWCONFIRM
                                    .tr(),
                                labelStyle: GoogleFonts.poppins(
                                  color: AppColors.placeHolderGrey,
                                  fontSize: 16.sp,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Container(
                          // height: size.height * 0.065,
                          // width: size.width * 0.6,
                          height: 55.h,
                          width: 253.w,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                passwordValidator = true;
                              });
                              if (formkey.currentState!.validate()) {
                                setState(() {
                                  isLoadingResetPd = true;
                                });
                                await resetPassword(
                                    widget.email,
                                    passcodeController.text,
                                    recoverController.text);
                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(builder: (context) {
                                //   return NavbarScreen(0);
                                // }));
                                setState(() {
                                  isLoadingResetPd = false;
                                });
                                print("success");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: isLoadingResetPd
                                ? Container(
                                    // padding: EdgeInsets.all(22.sp),
                                    child:
                                        LoadingAnimationWidget.prograssiveDots(
                                      color: AppColors.clearWhite,
                                      size: 40.sp,
                                    ),
                                  )
                                : Text(
                                    LocaleKeys.LOGINANDREGISTER_RESETPW.tr(),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 160.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  // bottom: -45,
                  child: GestureDetector(
                    onTap: () {

                      Navigator.pushReplacement(
                          context,
                          // MaterialPageRoute(
                          //   builder: ((context) {
                          //     return SignInScreen();
                          //   }),
                          // ),

                          SliderTransition(SignInScreen()));
                    },
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 20),
                      // padding: EdgeInsets.all(10),
                      // width: size.width * 0.75,
                      // height: size.height * 0.105,
                      width: 362.w,
                      height: 56.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.sp),
                          topLeft: Radius.circular(16.sp),
                        ),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${LocaleKeys.LOGINANDREGISTER_ALREADYACC.tr()} ? ",
                              style: GoogleFonts.poppins(
                                color: AppColors.black1,
                                fontSize: 16.sp,
                              ),
                            ),
                            TextSpan(
                              text: LocaleKeys.LOGINANDREGISTER_LOGIN.tr(),
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
