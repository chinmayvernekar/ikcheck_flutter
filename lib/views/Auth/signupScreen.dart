import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';

import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/Auth/ActivationScreen.dart';
import 'package:iKCHECK/views/Auth/SignInScreen.dart';
import 'package:iKCHECK/widgets/globalWidgets.dart';

import 'package:iKCHECK/widgets/svgIcons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/globalFunctions.dart';

bool showsize = false;

class SignUpScreen extends StatefulWidget {
  bool? deleteAccount;
  String? email;
  String? name;
  SignUpScreen({this.deleteAccount, this.email, this.name});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoadingSignUP = false;

  @override
  void showRedStrip() {
    setState(() {
      redstrip = true;
      widget.deleteAccount = false;
    });
  }

  void showSize() {
    setState(() {
      showsize = true;
    });
  }

  void dontShow() {
    setState(() {
      showsize = false;
    });
  }

  void stopRedStrip() {
    setState(() {
      redstrip = false;
    });
  }

  signUp(
      String email, String password, String firstName, String lastName) async {
    email = email.replaceAll(' ', '');
    await storeString('EMAIL_FOR_IPAD', email);
    Map data = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': ""
    };
    var jsonData = null;
    var response = await ApiCallManagement().signUpApiCall(data);

    if (response.statusCode == 201) {
      jsonData = json.decode(response.body);
      print(response.body);
      nameController.clear();
      passwordController.clear();
      repeatpasswordController.clear();
      setState(() {
        passwordValidator = false;
      });
      stopRedStrip();
      dontShow();
      // Get.to(NewScreen());
      Navigator.push(
          context,
          // MaterialPageRoute(
          //   builder: ((context) {
          //     return ActivationScreen(mail: mailController.text);
          //   }),
          // ),
          SliderTransition(ActivationScreen(
            mail: email,
          )));
    } else {
      print("getting error response");
      print(response.body);
      showRedStrip();
      showSize();

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(response.body.substring(31, 56))));
    }
  }

  // Signup() async {
  //   Map data = {
  //     'password': passwordController.text,
  //     'email': mailController.text,
  //     'firstName': nameController.text,
  //     'lastName': '',
  //   };
  //   var response = await ApiCallManagement().signUpApiCall(data);
  //   var body = json.decode(response.body);
  //   if (body['emailStatus']) {
  //     Navigator.of(context)
  //         .push(MaterialPageRoute(builder: (context) => SignInScreen()));
  //   } else {
  //     print("error");
  //   }
  // }

  bool _passwordVisible = false;
  final formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController mailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController repeatpasswordController = TextEditingController();

  bool passwordValidator = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await storeString('EMAIL_FOR_IPAD', widget.email)
      await storeString('PATH_FOR_IPAD', 'SIGNUP');
    });
    // TODO: implement initState
    super.initState();
    if (widget.name != null) {
      nameController.text = widget.name!;
    }
    if (widget.email != null) {
      mailController.text = widget.email!;
    }

    deepLinkDecodedData = {};
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    redstrip = false;
    widget.deleteAccount = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.clearWhite,
      // resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: size.height,
            width: double.infinity,
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
                      child: Form(
                        key: formkey,
                        child: AutofillGroup(
                          child: Column(
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
                                LocaleKeys.LOGINANDREGISTER_SIGNUP.tr(),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22.sp),
                              ),

                              // Container(
                              //   width: double.infinity,
                              //   color: Colors.red,
                              //   height: 42,
                              // ),
                              if (widget.deleteAccount != null &&
                                  widget.deleteAccount!)
                                SizedBox(
                                height: 22.h,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              if (widget.deleteAccount != null &&
                                  widget.deleteAccount!)
                                stripAlert(
                                    true,
                                    LocaleKeys
                                        .LOGINANDREGISTER_ACCHASBEENDELETED
                                        .tr()),
                              if (widget.deleteAccount != null &&
                                  widget.deleteAccount!)
                              SizedBox(
                                height: 15.h,
                              ),
                              redWid(context),
                              SizedBox(
                                height: 22.h,
                              ),

                              Container(
                                width: 331.w,
                                // height: 55.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.sp)),
                                child: TextFormField(
                                  // obscureText: !_passwordVisible,
                                  validator: (name) {
                                    if (name!.isEmpty ||
                                        !RegExp(r'^[a-z A-Z 0-9 \x7f-\xff -]+$')
                                            .hasMatch(name)) {
                                      return LocaleKeys
                                          .LOGINANDREGISTER_CRCTNAME
                                          .tr();
                                    } else {
                                      return null;
                                    }
                                  },
                                  maxLength: 25,
                                  controller: nameController,
                                  autofillHints: const [AutofillHints.username],
                                  decoration: InputDecoration(
                                    counterText: '',
                                    // counterStyle: GoogleFonts.poppins(
                                    //     color: AppColors.placeHolderGrey,
                                    //     fontSize: 13.sp),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.sp),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
                                        borderSide: BorderSide(
                                          color: AppColors.clearGrey,
                                        )),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(bottom: 3.sp),
                                      child: personSvg,
                                    ),
                                    fillColor: AppColors.clearGrey,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
                                        borderSide: BorderSide(
                                            color: AppColors.clearGrey)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp)),
                                    labelText:
                                        LocaleKeys.LOGINANDREGISTER_NAME.tr(),
                                    labelStyle: GoogleFonts.poppins(
                                        color: AppColors.placeHolderGrey,
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                // margin: EdgeInsets.symmetric(
                                //     horizontal: 35.sp, vertical: 10.sp),
                                width: 331.w,
                                // height: 50.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.sp)),
                                child: TextFormField(
                                  validator: (email) {
                                    if (email!.isEmpty ||
                                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                            .hasMatch(email)) {
                                      return LocaleKeys
                                          .ALERTMESSAGE_INVALIDEMAIL
                                          .tr();
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: mailController,
                                  autofillHints: const [AutofillHints.email],
                                  onEditingComplete: () {
                                    try {
                                      TextInput.finishAutofillContext();
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.sp),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
                                        borderSide: BorderSide(
                                          color: AppColors.clearGrey,
                                        )),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(bottom: 3.sp),
                                      child: Transform.scale(
                                        scale: 0.4,
                                        child: SvgPicture.asset(
                                          "assets/svgs/mail.svg",
                                          color: AppColors.clearGrey,
                                        ),
                                      ),
                                    ),
                                    fillColor: AppColors.clearGrey,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
                                        borderSide: BorderSide(
                                            color: AppColors.clearGrey)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp)),
                                    labelText:
                                        LocaleKeys.LOGINANDREGISTER_EMAIL.tr(),
                                    labelStyle: GoogleFonts.poppins(
                                      color: AppColors.placeHolderGrey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                // margin: EdgeInsets.symmetric(
                                //     horizontal: 35.sp, vertical: 10.sp),
                                width: 331.w,
                                // height: 55.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.sp)),
                                child: TextFormField(
                                  obscureText: !_passwordVisible,
                                  // validator: (value) {
                                  //   RegExp regex = RegExp(
                                  //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~]).{8,}$');
                                  //   if (value!.isEmpty) {
                                  //     setState(() {
                                  //       passwordValidator = false;
                                  //     });
                                  //     return LocaleKeys.ALERTMESSAGE_INVALIDPW
                                  //         .tr();
                                  //   } else {
                                  //     setState(() {
                                  //       passwordValidator = true;
                                  //     });
                                  //   }
                                  //   // else {
                                  //   //   // if (!regex.hasMatch(value)) {
                                  //   //   //   // setState(() {
                                  //   //   //   //   passwordValidator = true;
                                  //   //   //   // });
                                  //   //   //   // return '${LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA1.tr()}' +
                                  //   //   //   //     '\n' +
                                  //   //   //   //     '${LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA2.tr()}' +
                                  //   //   //   //     '\n' +
                                  //   //   //   //     '${LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA3.tr()}';
                                  //   //   // } else {
                                  //   //   return null;
                                  //   //   // }
                                  //   // }
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
                                  autofillHints: const [AutofillHints.password],
                                  onEditingComplete: () {
                                    try {
                                      TextInput.finishAutofillContext();
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 10.sp),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.sp),
                                          borderSide: BorderSide(
                                              color: (passwordController.text.isEmpty &&
                                                      passwordValidator)
                                                  ? AppColors.errorRed
                                                  : AppColors.clearGrey)),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(bottom: 3.sp),
                                        child: lockSvg,
                                      ),
                                      fillColor: AppColors.clearGrey,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.sp),
                                          borderSide: BorderSide(
                                              color: (passwordController
                                                          .text.isEmpty &&
                                                      passwordValidator)
                                                  ? AppColors.errorRed
                                                  : AppColors.clearGrey)),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
                                        borderSide: BorderSide(
                                            color: (passwordController
                                                        .text.isEmpty &&
                                                    passwordValidator)
                                                ? AppColors.errorRed
                                                : AppColors.clearGrey),
                                      ),
                                      labelText: LocaleKeys.LOGINANDREGISTER_PASSWORD
                                          .tr(),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                          icon: _passwordVisible
                                              ? eyeSvg
                                              : Icon(
                                                  Icons.visibility_off,
                                                  color: AppColors.iconGrey,
                                                  size: 20,
                                                )),
                                      labelStyle: GoogleFonts.poppins(
                                          color: AppColors.placeHolderGrey,
                                          fontSize: 16.sp)),
                                ),
                              ),

                              if (passwordValidator)
                                Container(
                                  width: 338.w,
                                  child: passwordController.text.isEmpty
                                      ? Container(
                                          padding: EdgeInsets.only(top: 10.sp),
                                          child: Text(
                                            LocaleKeys.ALERTMESSAGE_INVALIDPW
                                                .tr(),
                                            style: AppFont.errorText.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.errorRed,
                                            ),
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                (passwordController
                                                            .text.length <=
                                                        7)
                                                    ? Icon(
                                                        Icons.close,
                                                        color:
                                                            AppColors.errorRed,
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
                                                Expanded(
                                                  child: Text(
                                                    LocaleKeys
                                                        .ALERTMESSAGE_PASSWORDPATTERN_DATA1
                                                        .tr(),
                                                    softWrap: true,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,

                                                    style: AppFont.errorText
                                                        .copyWith(
                                                      color: (passwordController
                                                                  .text.length <=
                                                              7)
                                                          ? AppColors.errorRed
                                                          : AppColors
                                                              .successStripForeground,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])')
                                                        .hasMatch(
                                                            passwordController
                                                                .text))
                                                    ? Icon(
                                                        Icons.done,
                                                        size: 20.sp,
                                                        color: AppColors
                                                            .successStripForeground,
                                                      )
                                                    : Icon(
                                                        Icons.close,
                                                        color:
                                                            AppColors.errorRed,
                                                        size: 20.sp,
                                                      ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    LocaleKeys
                                                        .ALERTMESSAGE_PASSWORDPATTERN_DATA2
                                                        .tr(),
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppFont.errorText
                                                        .copyWith(
                                                      color: (RegExp(
                                                                  r'^(?=.*?[A-Z])(?=.*?[a-z])')
                                                              .hasMatch(
                                                                  passwordController
                                                                      .text))
                                                          ? AppColors
                                                              .successStripForeground
                                                          : AppColors.errorRed,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (RegExp(r'^(?=.*?[0-9])')
                                                            // r'^(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                                            .hasMatch(
                                                                passwordController
                                                                    .text) &&
                                                        RegExp(r'(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                                            .hasMatch(
                                                                passwordController
                                                                    .text))
                                                    ? Icon(
                                                        Icons.done,
                                                        size: 20.sp,
                                                        color: AppColors
                                                            .successStripForeground,
                                                      )
                                                    : Icon(
                                                        Icons.close,
                                                        color:
                                                            AppColors.errorRed,
                                                        size: 20.sp,
                                                      ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    replaceSpecials(LocaleKeys
                                                        .ALERTMESSAGE_PASSWORDPATTERN_DATA3
                                                        .tr()),
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppFont.errorText
                                                        .copyWith(
                                                      color: (RegExp(
                                                                      r'^(?=.*?[0-9])')
                                                                  // r'^(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                                                  .hasMatch(
                                                                      passwordController
                                                                          .text) &&
                                                              // RegExp(r'(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                                              RegExp(r'(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                                                  .hasMatch(
                                                                      passwordController
                                                                          .text))
                                                          ? AppColors
                                                              .successStripForeground
                                                          : AppColors.errorRed,
                                                    ),
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
                                // margin: EdgeInsets.symmetric(
                                //     horizontal: 35.sp, vertical: 10.sp),
                                width: 331.w,
                                // height: 55.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.sp)),
                                child: TextFormField(
                                  scrollPadding: EdgeInsets.only(
                                      bottom: size.height * 0.25),
                                  obscureText: !_passwordVisible,
                                  validator: (password) {
                                    if (password!.isEmpty ||
                                        passwordController.text !=
                                            repeatpasswordController.text) {
                                      return LocaleKeys
                                          .ALERTMESSAGE_INVALIDCONFIRMPASSWORD
                                          .tr();
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: repeatpasswordController,
                                  autofillHints: const [AutofillHints.password],
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 10.sp),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.sp),
                                          borderSide: BorderSide(
                                            color: AppColors.clearGrey,
                                          )),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(bottom: 3.sp),
                                        child: lockSvg,
                                      ),
                                      fillColor: AppColors.clearGrey,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.sp),
                                          borderSide: BorderSide(
                                              color: AppColors.clearGrey)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.sp)),
                                      labelText: LocaleKeys
                                          .LOGINANDREGISTER_PASSWORDCONFIRM
                                          .tr(),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                          icon: _passwordVisible
                                              ? eyeSvg
                                              : Icon(
                                                  Icons.visibility_off,
                                                  color: AppColors.iconGrey,
                                                  size: 20,
                                                )),
                                      labelStyle: GoogleFonts.poppins(
                                          color: AppColors.placeHolderGrey,
                                          fontSize: 16.sp)),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                // height: size.height * 0.07,
                                // width: size.width * 0.65,
                                height: 55.h,
                                width: 253.w,

                                // margin: EdgeInsets.symmetric(horizontal: 30.sp),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      passwordValidator = true;
                                    });

                                    if (formkey.currentState!.validate()) {
                                      setState(() {
                                        isLoadingSignUP = true;
                                      });
                                      TextInput.finishAutofillContext();

                                      final SharedPreferences
                                          sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      sharedPreferences.setString(
                                          'password', passwordController.text);
                                      sharedPreferences.setString(
                                          'mail',
                                          mailController.text
                                              .replaceAll(' ', ''));
                                      var passwordtest = await sharedPreferences
                                          .getString('password');

                                      await signUp(
                                          mailController.text,
                                          passwordController.text,
                                          nameController.text,
                                          "");
                                      print(passwordtest);

                                      print("success");
                                      setState(() {
                                        isLoadingSignUP = false;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                  child: isLoadingSignUP
                                      ? Container(
                                          // padding: EdgeInsets.all(22.sp),
                                          child: LoadingAnimationWidget
                                              .prograssiveDots(
                                            color: AppColors.clearWhite,
                                            size: 40.sp,
                                          ),
                                        )
                                      : Text(
                                          LocaleKeys.LOGINANDREGISTER_CREATEACC
                                              .tr(),
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.sp),
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 180.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              // bottom: -45,
              child: GestureDetector(
                onTap: () {
                  stopRedStrip();
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
    );
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
                LocaleKeys.ALERTMESSAGE_USEREXISTS.tr(),
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

  // void signUp(
  //     String password, String email, String firstName, String lastName) async {
  //   Map data = {
  //     'password': password,
  //     'email': email,
  //     'firstName': firstName,
  //     'lastName': ""
  //   };

  //   try {
  //     http.Response response = await http.post(
  //         Uri.parse("$BASE_URL/user-service/users"),
  //         body: data);
  //     if (response.statusCode == 201) {
  //       Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (context) => SignInScreen()));
  //     } else {
  //       print("failed");
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
