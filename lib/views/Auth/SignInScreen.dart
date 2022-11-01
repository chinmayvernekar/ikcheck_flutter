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
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/codegen_loader.g.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/services/notificationManagement.dart';
import 'package:iKCHECK/views/Auth/NavigatorSignIn.dart';
import 'package:iKCHECK/views/Auth/signupScreen.dart';
import 'package:iKCHECK/views/Auth/ForgotPasswordScreen.dart';
import 'package:iKCHECK/views/home/dashboardScreen.dart';
import 'package:iKCHECK/widgets/globalWidgets.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/svgIcons.dart';

var tempval;
var tempTokenAcess;

bool greenstrip = false;
late String tempvarofuserid;

var temptext;

class SignInScreen extends StatefulWidget {
  bool isLoading = false;
  bool? versionCheck;
  String? stripContent;
  bool? stripStatus;
  SignInScreen({
    this.versionCheck,
    this.stripContent,
    this.stripStatus,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await storeString('EMAIL_FOR_IPAD', widget.email)
      await storeString('PATH_FOR_IPAD', 'SIGNIN');
    });
    // TODO: implement initState
    super.initState();
  }

  void showWidget() {
    setState(() {
      viewVisible = true;
      widget.stripContent = '';
      widget.stripStatus = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.stripContent = '';
    widget.stripStatus = false;
  }

  bool viewVisible = false;
  bool _passwordVisible = false;
  SignIn(String email, String password, String grantType) async {
    email = email.replaceAll(' ', '');
    Map data = {
      'username': email,
      'password': password,
      'grant_type': "password"
    };
    var jsonData;
    var response = await ApiCallManagement().signInApiCall(data);

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey("isFirstTime")){
        print("SHAREDPREF NOT SET");
      }else{
        prefs.setBool("isFirstTime", true);
      }
      jsonData = jsonDecode(response.body);
      print(response.body);
      print("This is jti  " + jsonData['id']);
      tempTokenAcess = jsonData['access_token'];
      await storeString('access_token', tempTokenAcess);
      await storeString('user_email', email);
      await ApiCallManagement().userDetailApi(context);
      try {
        if (Platform.isAndroid || Platform.isIOS) {
          ApiCallManagement().postFirebaseToken(
              await FCM().getTokenValue(), 'T.D.LOGIN', context);
        }
      } catch (e) {
        print(e);
      }
      // final SharedPreferences sharedPreferences =
      //     await SharedPreferences.getInstance();
      // sharedPreferences.setString('token', emailController.text);
      // Get.to(NewScreen());


      await storeString('firstTimeUser', 'NO');
      await storeString('firstTimeIdentity', 'NO');
      await ApiCallManagement().getDashboardDetails(context);
      emailController.clear();
      passwordController.clear();
      setState(() {
        widget.isLoading = false;
      });
      navvigatorfunction(context);

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavbarScreen(apiCallString: 'getDashboardDetails'), ));
      // await   pushNewScreen(
      //   context,
      //   screen:NavbarScreen(apiCallString: 'getDashboardDetails'),
      //   withNavBar: true, // OPTIONAL VALUE. True by default.
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      // );
      await ApiCallManagement().getDashboardDetails(context);
    } else {
      print("getting error response");
      print(response.body);
      Map decodedResponse = jsonDecode(response.body);
      if(decodedResponse['code'][0]=="L_206"){
        print('here');
        //Get.to(()=>Forgot);
        Navigator.push(
          context,
          SliderTransition(ForgotPasswordScreen(isPasswordExpired: true, email: email,),
          ),
        );
      }
      temptext = response.body;
      showWidget();

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(response.body.substring(31, 56))));
    }
  }

  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: AppColors.clearWhite,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
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
                    top: true,
                    bottom: true,
                    child: SizedBox(
                      height: size.height * 0.8,
                      child: Form(
                        key: formkey,
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
                              height: 65.h,
                            ),
                            Text(
                                 LocaleKeys.LOGINANDREGISTER_SIGNIN.tr(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 24.sp,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (widget.stripContent != null &&
                                widget.stripContent!.isNotEmpty)
                              SizedBox(
                                height: 15.h,
                              ),
                            if (widget.stripContent != null &&
                                widget.stripContent!.isNotEmpty)
                              stripAlert(
                                widget.stripStatus!,
                                widget.stripContent!,
                              ),
                            if (viewVisible)
                              SizedBox(
                                height: 15.h,
                              ),
                            Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: viewVisible,
                              child: Container(
                                height: 40.h,
                                width: double.infinity,
                                color: AppColors.failureStrip,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // SizedBox(
                                      //   width: 30.w,
                                      // ),
                                      SvgPicture.asset(
                                        "assets/svgs/error.svg",
                                        height: 20.h,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        LocaleKeys.ALERTMESSAGE_INVALIDUNPW
                                            .tr(),
                                        style: AppFont.normal.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              AppColors.failureStripForeground,
                                          fontSize: 14.sp,
                                        ),
                                        // textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            AutofillGroup(
                              child: Column(
                                children: [
                                  Container(
                                    width: 331.w,
                                    // // height: 55.h,
                                    // decoration: BoxDecoration(
                                    //     borderRadius:
                                    //         BorderRadius.circular(8.sp)),
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
                                      keyboardType: TextInputType.emailAddress,
                                      autofillHints: const [
                                        AutofillHints.email
                                        // AutofillHints.username
                                      ],
                                      onEditingComplete: () {
                                        try {
                                          TextInput.finishAutofillContext();
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        // contentPadding: EdgeInsets.symmetric(
                                        //     vertical: 20.sp),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.sp),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.sp),
                                            borderSide: BorderSide(
                                              // color: AppColors.clearGrey,
                                              color: AppColors.clearGrey,
                                            )),
                                        // prefixIcon: Image.asset(
                                        //   "assets/images/mail.png",
                                        //   scale: 2.2.sp,
                                        //   color: AppColors.clearGrey,
                                        // ),
                                        prefixIcon: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 3.sp),
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
                                        labelText: LocaleKeys
                                            .LOGINANDREGISTER_EMAIL
                                            .tr(),
                                        labelStyle: GoogleFonts.poppins(
                                          fontSize: 16.sp,
                                          color: AppColors.placeHolderGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    width: 331.w,
                                    // // height: 55.h,
                                    // margin: EdgeInsets.symmetric(
                                    //   horizontal: 25.sp,
                                    // ),
                                    // padding: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.sp)),
                                    child: TextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      autofillHints: const [
                                        AutofillHints.password
                                      ],
                                      onEditingComplete: () {
                                        try {
                                          TextInput.finishAutofillContext();
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      // TextInput.finishAutofillContext(
                                      //     shouldSave: true),
                                      scrollPadding: EdgeInsets.only(
                                          bottom: size.height * 0.25),
                                      obscureText: !_passwordVisible,
                                      validator: (password) {
                                        if (password!.isEmpty) {
                                          return LocaleKeys
                                              .ALERTMESSAGE_INVALIDPW
                                              .tr();
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.sp),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.sp),
                                            borderSide: BorderSide(
                                              color: AppColors.clearGrey,
                                            )),
                                        prefixIcon: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 3.sp),
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
                                            .LOGINANDREGISTER_PASSWORD
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
                                          fontSize: 16.sp,
                                          color: AppColors.placeHolderGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              // margin: const EdgeInsets.symmetric(
                              //   horizontal: 35,
                              // ),
                              // padding:
                              //     const EdgeInsets.symmetric(horizontal: 13),
                              width: 331.w,
                              // height: 30.h,
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      // MaterialPageRoute(
                                      //   builder: ((context) {
                                      //     return ForgotPasswordScreen();
                                      //   }),
                                      // ),
                                      SliderTransition(ForgotPasswordScreen()));
                                },
                                child: Text(
                                  LocaleKeys.LOGINANDREGISTER_FORGETPASSWORD
                                      .tr(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.primary,fontSize: 18.sp,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            SizedBox(
                              // height: size.height * 0.06,
                              // width: size.width * 0.65,
                              width: 253.w,
                              height: 55.h,
                              // height: size.height * 0.07,
                              // margin: EdgeInsets.symmetric(horizontal: 30.sp),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    setState(() {
                                      widget.isLoading = true;
                                    });
                                    TextInput.finishAutofillContext();

                                    await SignIn(emailController.text,
                                        passwordController.text, "password");
                                    // setState(() {
                                       widget.isLoading = false;
                                    // });

                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                  ),
                                ),
                                child: widget.isLoading
                                    ? Container(
                                        // padding: EdgeInsets.symmetric(
                                        //     horizontal: 22.sp),
                                        child: LoadingAnimationWidget
                                            .prograssiveDots(
                                          color: AppColors.clearWhite,
                                          size: 40.sp,
                                        ),
                                      )
                                    : Text(
                                        LocaleKeys.LOGINANDREGISTER_LOGIN.tr(),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,

                              SliderTransition(SignUpScreen()));
                        },
                        child: Container(
                          width: 362.w,
                          height: 56.h,
                          alignment: Alignment.center,
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          // padding: EdgeInsets.all(10),
                          // width: size.width * 0.8,
                          // height: size.height * 0.08,
                          decoration: BoxDecoration(
                            color: AppColors.clearWhite,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.sp),
                              topLeft: Radius.circular(16.sp),
                            ),
                          ),
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      "${LocaleKeys.LOGINANDREGISTER_DONTHAVEANACCOUNTYET.tr()}? ",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.black1,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: LocaleKeys.LOGINANDREGISTER_SIGNUP.tr(),
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primary,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ])),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
