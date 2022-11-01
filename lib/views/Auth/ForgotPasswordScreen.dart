import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/views/Auth/SecondForgotPasswordScreen.dart';
import 'package:iKCHECK/views/Auth/SignInScreen.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Utils/navigation.dart';
import '../../services/apiCallManagement.dart';
import '../../widgets/svgIcons.dart';

bool redstrip = false;
bool showsize = false;
bool isPasswordExpiredG = false;

class ForgotPasswordScreen extends StatefulWidget {
  bool isPasswordExpired;
  String? email;
  ForgotPasswordScreen({Key? key, this.isPasswordExpired=false, this.email}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {


  bool isloadingRecovery = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await storeString('PATH_FOR_IPAD', 'FORGETPASSWORD_1');
    });
    if(widget.isPasswordExpired){
      print('Password is expired');
      print(widget.email);
      emailController.text = widget.email!;
      isPasswordExpiredG = true;
    }
    print('object');
  }

  void showRedStrip() {
    setState(() {
      redstrip = true;
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

  forgotPasswordScreenApi({required String email, bool isPasswordExpired=false}) async {
    email = email.replaceAll(' ', '');
    await storeString('EMAIL_FOR_IPAD', email);
    Map data = {"loginId": email, "type": null};
    var jsonData = null;
    var response = await ApiCallManagement().forgotPasswordScreenApi(data);

    if (response.statusCode == 200) {
      jsonData = jsonEncode(response.body);
      print("Forgot Password" + response.body);
      // Get.to(NewScreen());
      Navigator.push(
          context,
          // MaterialPageRoute(
          //   builder: ((context) {
          //     return SecondForgotPasswordScreen(
          //       email: emailController.text,
          //     );
          //   }),
          // ),
          SliderTransition(SecondForgotPasswordScreen(
            email: email,
            isPasswordExpired: isPasswordExpired,
          )));
    } else {
      showSize();
      showRedStrip();

      print("getting error response");
      print(response.body);

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(response.body.substring(31, 56))));
    }
  }

  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: (){
        isPasswordExpiredG = false;
        return Future.value(true);
      }
    ,
      child: Scaffold(
        backgroundColor: AppColors.clearWhite,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: size.height,
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
                  child: Form(
                    key: formkey,
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
                        Container(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text(
                            widget.isPasswordExpired ? LocaleKeys.LOGINANDREGISTER_RESETPASSWORD.tr() :LocaleKeys.LOGINANDREGISTER_FORGETPASSWORDTITLE.tr(),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 22.sp,
                              ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        redWid(context),
                        SizedBox(
                          height: 40.sp,
                        ),
                        Container(
                          width: 331.w,
                          // height: 55.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp)),
                          child: TextFormField(
                            //initialValue: widget.email ?? null,
                            validator: (email) {
                              if (email!.isEmpty ||
                                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                      .hasMatch(email)) {
                                return LocaleKeys.ALERTMESSAGE_INVALIDEMAIL.tr();
                              } else {
                                return null;
                              }
                            },
                            controller: emailController,
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
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide:
                                        BorderSide(color: AppColors.clearGrey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp)),
                                labelText: LocaleKeys.LOGINANDREGISTER_EMAIL.tr(),
                                labelStyle: GoogleFonts.poppins(
                                  color: AppColors.placeHolderGrey,
                                  fontSize: 16.sp,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        Container(
                          // height: size.height * 0.06,
                          // width: size.width * 0.65,
                          height: 55.h,
                          width: 253.w,
                          // margin: EdgeInsets.symmetric(horizontal: 30.sp),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                setState(() {
                                  isloadingRecovery = true;
                                });
                                await forgotPasswordScreenApi(
                                    email: emailController.text, isPasswordExpired: widget.isPasswordExpired);
                                setState(() {
                                  isloadingRecovery = false;
                                });
                                print("success email");
                                setState(() {
                                  isloadingRecovery = false;
                                });
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         SecondForgotPasswordScreen(email: "",)));
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: ((context) {
                                //       return SecondForgotPasswordScreen();
                                //     }),
                                //   ),
                                // );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: ((context) {
                                //       return SecondForgotPasswordScreen();
                                //     }),
                                //   ),
                                // );
    
                                print("success");
                              }
    
                              // Get.to(SecondForgotPasswordScreen());
                              // if (formkey.currentState!.validate()) {
                              //   SignIn(emailController.text,
                              //       passwordController.text, "password");
                              //   print("success");
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: isloadingRecovery
                                ? Container(
                                    // padding: EdgeInsets.all(22.sp),
                                    child: LoadingAnimationWidget.prograssiveDots(
                                      color: AppColors.clearWhite,
                                      size: 40.sp,
                                    ),
                                  )
                                : Text(
                                    LocaleKeys.LOGINANDREGISTER_GETRCVYCD.tr(),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        Container(
                          // padding: EdgeInsets.only(
                          //   left: size.width * 0.48,
                          // ),
                          child: InkWell(
                            onTap: () {
                              isPasswordExpiredG = false;
                              Navigator.pushReplacement(
                                  context, SliderTransition(SignInScreen()));
                            },
                            child: Text(
                              LocaleKeys.COMMON_CANCEL.tr(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
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
    
                // Positioned(
                //     bottom: 0,
                //     child: Container(
                //       margin: const EdgeInsets.symmetric(horizontal: 20),
                //       padding: const EdgeInsets.all(10),
                //       width: size.width * 0.75,
                //       height: size.height * 0.1,
                //       decoration: BoxDecoration(
                //           color: AppColors.clearWhite,
                //           borderRadius: BorderRadius.circular(12)),
                //       child: GestureDetector(
                //         onTap: () {
                //           Navigator.pushReplacement(
                //               context,
                //               // MaterialPageRoute(
                //               //   builder: ((context) {
                //               //     return SignUpScreen();
                //               //   }),
                //               // ),
                //               SliderTransition(SignInScreen()));
                //         },
                //         child: RichText(
                //             textAlign: TextAlign.center,
                //             text: TextSpan(children: [
                //               TextSpan(
                //                   text:
                //                       "${LocaleKeys.LOGINANDREGISTER_ALREADYACC.tr()} ? ",
                //                   style: GoogleFonts.poppins(
                //                       fontSize: 16.sp, color: AppColors.black1)),
                //               TextSpan(
                //                 text: LocaleKeys.LOGINANDREGISTER_LOGIN.tr(),
                //                 style: GoogleFonts.poppins(
                //                   color: AppColors.primary,
                //                   fontSize: 16.sp,
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //               ),
                //             ])),
                //       ),
                //     )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget redWid(BuildContext context) {
  return Visibility(
    maintainSize: showsize,
    maintainAnimation: true,
    maintainState: true,
    visible: redstrip || isPasswordExpiredG,
    child: Container(
      height: 40,
      width: double.infinity,
      color: AppColors.failureStrip,
      child: Center(
        child: Row(
          children: [
            //Spacer(),
            Container(
                padding: const EdgeInsets.only(left: 45),
                child: SvgPicture.asset("assets/svgs/error.svg")),
            SizedBox(
              width: 10.w,
            ),
            Container(
              width: MediaQuery.of(context).size.width *0.6,
              child: Text(
                //isPasswordExpiredG ? 'Please change password to continue using this App' : LocaleKeys.LOGINANDREGISTER_USERDOESNOTEXIST.tr(),
                isPasswordExpiredG ? LocaleKeys.LOGINANDREGISTER_CHANGEPASSWORD.tr() : LocaleKeys.LOGINANDREGISTER_USERDOESNOTEXIST.tr(),
                textAlign: TextAlign.left,
                //overflow: TextOverflow.clip,
                style: AppFont.normal.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.failureStripForeground,
                    fontSize: 14.sp),
                // textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class NewScreen extends StatelessWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
