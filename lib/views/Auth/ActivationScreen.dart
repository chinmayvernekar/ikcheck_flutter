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
import 'package:iKCHECK/icons/icons.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/services/notificationManagement.dart';
import 'package:iKCHECK/views/Auth/SignInScreen.dart';
// import 'package:iKCHECK/views/Auth/SignInScreen.dart';
import 'package:iKCHECK/views/Auth/signupScreen.dart';
import 'package:iKCHECK/views/home/dashboardScreen.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/navigation.dart';

var tempval;
var temptext;
var storeToken;

bool redstrip = false;
bool greenstrip = true;

class ActivationScreen extends StatefulWidget {
  final String mail;
  ActivationScreen({required this.mail});
  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String? finalid = "";
  String? finalmail = "";
  bool isLoadingActivate = false;
  Future getUserId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? tempid = sharedPreferences.getString('password');
    String? mailid = sharedPreferences.getString('mail');
    setState(() {
      finalid = tempid;
    });
    setState(() {
      finalmail = mailid;
    });
  }

  forgotPasswordScreenApi(String email, String type) async {
    Map data = {"loginId": email, "type": "activation code"};
    var jsonData;
    var response = await ApiCallManagement().forgotPasswordScreenApi(data);

    if (response.statusCode == 200) {
      jsonData = jsonEncode(response.body);
      showgreenStripAgain();

      Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: greenstrip,
        child: Container(
          height: 40,
          width: double.infinity,
          color: AppColors.successStrip,
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/svgs/tick.svg"),
                SizedBox(
                  width: 10.w,
                ),
                Flexible(
                  child: Text(
                    '${LocaleKeys.LOGINANDREGISTER_CODESENTTO.tr()} ${widget.mail}',
                    style: AppFont.normal.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.successStripForeground,
                        fontSize: 13.sp),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      print("getting error response");
      print(response.body);

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(response.body.substring(31, 56))));
    }
  }

  signIn(String email, String password, String grant_type) async {
    Map data = {
      'username': email,
      'password': password,
      'grant_type': "password"
    };
    var jsonData = null;
    var response = await ApiCallManagement().signInApiCall(data);

    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      storeToken = jsonData["access_token"];
      await storeString('access_token', storeToken);
      await ApiCallManagement().userDetailApi(context);
      await ApiCallManagement()
          .postFirebaseToken(await FCM().getTokenValue(), 'T.D.LOGIN', context);
      await storeString('firstTimeUser', 'YES');
      await storeString('firstTimeIdentity', 'YES');
      await ApiCallManagement().getDashboardDetails(context);
      await   pushNewScreen(
        context,
        screen: NavbarScreen(),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
      await ApiCallManagement().getDashboardDetails(context);
    } else {
      print("getting error response");
      print(response.body);
      temptext = response.body;
    }
  }

  activationScreenApi(String email, String passcode) async {
    Map body = {'loginId': email, 'passcode': passcode};
    var jsonData = null;
    var response = await ApiCallManagement().confirmPasscode(body);
    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isFirstTime", true);
      await storeString('user_email', email);
      jsonData = jsonEncode(response.body);
      await signIn(finalmail.toString(), finalid.toString(), "password");
      passcodecontroller.clear();
    } else {
      showRedStrip();
      showgreenStrip();
      print("getting error response");
      print(response.body);

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(response.body.substring(31, 56))));
    }
  }

  void showRedStrip() {
    setState(() {
      redstrip = true;
    });
  }

  void showgreenStrip() {
    setState(() {
      greenstrip = false;
    });
  }

  void showgreenStripAgain() {
    setState(() {
      greenstrip = true;
    });
  }

  void disableStrips() {
    setState(() {
      greenstrip = false;
      redstrip = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await storeString('PATH_FOR_IPAD', 'SIGNUP_ACTIVATE');
      await storeString('EMAIL_FOR_IPAD', widget.mail);
    });
    super.initState();
    getUserId();
  }

  final formkey = GlobalKey<FormState>();
  TextEditingController passcodecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Widget GreenWid(BuildContext context) {
      return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: greenstrip,
        child: Container(
          height: 40,
          width: double.infinity,
          color: AppColors.successStrip,
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/svgs/tick.svg"),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                child: Text(
                    '${LocaleKeys.LOGINANDREGISTER_CODESENTTO.tr()} ${widget.mail}',
                    style: AppFont.normal.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.successStripForeground)),
              )
            ],
          ),
        ),
      );
    }

    Size size = MediaQuery.of(context).size;
    final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
    return Scaffold(
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
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          LocaleKeys.LOGINANDREGISTER_ACTIVATION.tr(),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 22),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      greenstrip ? GreenWid(context) : redWid(context),
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(
                        width: 331.w,
                        // height: 55.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.sp)),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (email) {
                            if (email!.isEmpty) {
                              return LocaleKeys.ALERTMESSAGE_INVALIDCODE.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: passcodecontroller,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.sp),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.sp),
                                borderSide: BorderSide(
                                  color: AppColors.clearGrey,
                                )),
                            prefixIcon: Icon(
                              IkCheckKey.keyIcon,
                              size: 18,
                              color: AppColors.iconGrey1,
                            ),
                            fillColor: AppColors.clearGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.sp),
                                borderSide:
                                    BorderSide(color: AppColors.clearGrey)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.sp)),
                            labelText:
                                LocaleKeys.LOGINANDREGISTER_ACTIVATIONCODE.tr(),
                            labelStyle: GoogleFonts.poppins(
                                color: AppColors.placeHolderGrey,
                                fontSize: 16.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          passcodecontroller.clear();
                          disableStrips();
                          forgotPasswordScreenApi(
                              widget.mail, "activation code");
                          // showgreenStripAgain();

                          Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: true,
                            child: Container(
                              height: 20.h,
                              width: double.infinity,
                              color: AppColors.successStrip,
                              padding: EdgeInsets.symmetric(horizontal: 10.sp),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/svgs/tick.svg"),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      '${LocaleKeys.LOGINANDREGISTER_CODESENTTO.tr()} ${widget.mail}',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.successStripForeground,
                                        fontSize: 13.sp,
                                        // fontWeight: FontWeight.bold),
                                        // textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 331.w,
                          alignment: Alignment.centerRight,
                          child: Text(
                            LocaleKeys.LOGINANDREGISTER_REQNEWCD.tr(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(
                        height: 55.h,
                        width: 253.w,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                isLoadingActivate = true;
                              });
                              await activationScreenApi(finalmail.toString(),
                                  passcodecontroller.text);
                              // SignIn(finalmail.toString(), finalid.toString(),
                              //     "password");
                              setState(() {
                                isLoadingActivate = false;
                              });
                              print("success email");
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) =>
                              //         SecondForgotPasswordScreen()));
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
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                          ),
                          child: isLoadingActivate
                              ? Container(
                                  // padding: EdgeInsets.all(22.sp),
                                  child: LoadingAnimationWidget.prograssiveDots(
                                    color: AppColors.clearWhite,
                                    size: 40.sp,
                                  ),
                                )
                              : Text(
                                  LocaleKeys.LOGINANDREGISTER_ACTIVATEACC.tr(),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
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
            ],
          ),
        ),
      ),
    );
  }
}

Widget redWid(BuildContext context) {
  return Visibility(
    maintainSize: true,
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
              LocaleKeys.ALERTMESSAGE_INVALIDACCCODE.tr(),
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
