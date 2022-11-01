import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/Auth/SignInScreen.dart';
import 'package:iKCHECK/views/account/changeEmailScreen.dart';
import 'package:iKCHECK/views/account/changeLanguageScreen.dart';
import 'package:iKCHECK/views/account/changePasswordScreen.dart';
import 'package:iKCHECK/views/account/clearDataAccountScreen.dart';
import 'package:iKCHECK/views/account/deleteAccountScreen.dart';
import 'package:iKCHECK/views/account/personalDataScreen.dart';
import 'package:iKCHECK/widgets/globalWidgets.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool lang = false;
  bool personalDataprocessing = false;
  @override
  void didChangeDependencies() {
    if (context.locale == Locale('nl')) {
      lang = false;
    } else {
      lang = true;
    }
    // if (Provider.of<MainProvider>(context, listen: false).accStripBool) {
    //   // Future.delayed(Duration(seconds: 6), () {
    //     Provider.of<MainProvider>(context, listen: false)
    //         .setAccStrip(false, false, '');
    //   // });
    // }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          // leading:InkWell(
          //   onTap: () async {
          //     Navigator.of(context).pop();
          //
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.all(10.sp),
          //     child: SvgPicture.asset(
          //       'assets/svgs/arrowLeft.svg',
          //     ),
          //   ),
          //
          // ),
          toolbarHeight: 100.h,
          backgroundColor: AppColors.clearWhite,
          elevation: 0,
          title: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.DASHBOARD_ACCOUNT.tr(),
                  style: AppFont.H3.copyWith(
                    fontSize: 24.sp,
                    color: AppColors.clearBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
          child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          if (Provider.of<MainProvider>(context).accStripBool)
            SizedBox(
              child: stripAlert(
                  Provider.of<MainProvider>(context).accStripStatusBool,
                  Provider.of<MainProvider>(context).accStripContent),
            ),

          AccountTile(
            icoHeight: 25.5.sp,
            title: LocaleKeys.ACCOUNT_PERSONALDATA_PERSONALDATA.tr(),
            assetSvg: 'a_personal',
            isPersonalData:
                Provider.of<MainProvider>(context, listen: false).isnameloading,
            ontap: () async {
              if (personalDataprocessing == false) {
                try {
                  setState(() {
                    personalDataprocessing = true;
                  });
                  Provider.of<MainProvider>(context, listen: false)
                      .setPersonalLoading(true);
                  await ApiCallManagement().getAccountDetails(context);
                  Provider.of<MainProvider>(context, listen: false)
                      .setPersonalLoading(false);
                  setState(() {
                    personalDataprocessing = false;
                  });
                  pushNewScreen(
                    context,
                    screen: PersonalDataScreen(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  setState(() {
                    personalDataprocessing = false;
                  });
                } catch (e) {
                  setState(() {
                    personalDataprocessing = false;
                  });
                }
              }
            },
          ),
          AccountTile(
            isPersonalData: false,
            icoHeight: 23.sp,
            title: LocaleKeys.NAVBARCONTENT_EMAIL.tr(),
            assetSvg: 'accountMail',
            ontap: () {
              pushNewScreen(
                context,
                screen: ChangeEmailScreen(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          AccountTile(
            isPersonalData: false,
            icoHeight: 29.sp,
            title: LocaleKeys.ACCOUNT_PASSWORD_PASSWORD.tr(),
            assetSvg: 'lock',
            // assetSvg: 'a_lock',
            ontap: () {
              pushNewScreen(
                context,
                screen: ChangePasswordScreen(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          AccountTile(
            isPersonalData: false,
            icoHeight: 24.sp,
            title: LocaleKeys.COMMON_LANGUAGE.tr(),
            assetSvg: 'flagAccount',
            ontap: () {
              pushNewScreen(
                context,
                screen: ChangeLanguageScreen(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          AccountTile(
            isPersonalData: false,
            icoHeight: 32.sp,
            title: LocaleKeys.ACCOUNT_CLEARDATA_CLEARDATA.tr(),
            assetSvg: 'delete',
            ontap: () {
              pushNewScreen(
                context,
                screen: ClearDataAccountScreen(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          AccountTile.isDelete(
            isPersonalData: false,
            icoHeight: 32.sp,
            title: LocaleKeys.ACCOUNT_DELETEACCOUNT_DELETEACCOUNT.tr(),
            assetSvg: 'delete',
            ontap: () {
              pushNewScreen(
                context,
                screen: DeleteAccountScreen(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),

          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
          //   child: ListTile(
          //     title: Text(
          //       'Dutch/English',
          //       style: AppFont.normal.copyWith(fontSize: 20.sp),
          //     ),
          //     trailing: CupertinoSwitch(
          //       value: lang,
          //       onChanged: (value) {
          //         setState(() {
          //           if (lang) {
          //             context.setLocale(Locale('nl'));
          //           } else {
          //             context.setLocale(Locale('en'));
          //           }
          //         });
          //       },
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 40.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.sp, vertical: 23.sp),
            child: FilledButton(
              isLoadingFilledBtn: false,
              title: LocaleKeys.ACCOUNT_LOGOUT.tr(),
              ontap: () async {
                // String firstTimeUser = await getString('firstTimeUser') ?? '';
                String currentLang = await getString('LANG') ?? '';
                await clearStorage();
                await storeString('LANG', currentLang);
                // if (firstTimeUser == 'YES') {
                //   await storeString('firstTimeUser', 'YES');
                // } else if (firstTimeUser == 'NO') {
                //   await storeString('firstTimeUser', 'NO');
                // }
                pushNewScreen(
                  context,
                  screen: SignInScreen(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => SignInScreen(),
                //   ),
                // );
                // Navigator.of(context).pushAndRemoveUntil(
                //   CupertinoPageRoute(
                //     builder: (BuildContext context) {
                //       return SignInScreen();
                //     },
                //   ),
                //       (_) => false,
                // );
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     'loginRoute', (Route<dynamic> route) => false);
              },
            ),
          )
        ],
      )),
    );
  }
}

class AccountTile extends StatelessWidget {
  String title;
  String assetSvg;
  VoidCallback ontap;
  double icoHeight;
  final isDelete;
  bool isPersonalData;
  AccountTile(
      {required this.title,
      required this.assetSvg,
      required this.ontap,
      required this.isPersonalData,
      required this.icoHeight})
      : isDelete = false;

  AccountTile.isDelete(
      {required this.title,
      required this.assetSvg,
      required this.ontap,
      required this.isPersonalData,
      required this.icoHeight})
      : isDelete = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.5.sp,
            color: AppColors.ashColor,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          color: !isDelete ? AppColors.clearWhite : Color(0xffF8D7DA),
          height: 85.h,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 30.w,
              ),
              SizedBox(
                width: 40.w,
                child: SvgPicture.asset(
                  'assets/svgs/$assetSvg.svg',
                  height: icoHeight,
                  color: !isDelete
                      ? 
                      assetSvg == 'flagAccount' || assetSvg == 'lock'
                          // ? AppColors.clearBlack
                          // : AppColors.clearBlack
                          ? Color(0XFF373237)
                          : AppColors.clearBlack
                      : Color(0xffDC3545),
                ),
              ),
              SizedBox(
                width: 25.w,
              ),
              Text(title,
                  style: !isDelete
                      ? AppFont.H3.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.clearBlack)
                      : AppFont.H3.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffDC3545),
                        )),
              Spacer(),
              isPersonalData
                  ? LoadingAnimationWidget.prograssiveDots(
                      color: AppColors.primary,
                      size: 40.sp,
                    )
                  : SvgPicture.asset(
                      'assets/svgs/arrowRight.svg',
                      height: 25.sp,
                      color:
                          isDelete ? Color(0xffDC3545) : AppColors.clearBlack,
                    ),
              SizedBox(
                width: 25.w,
              ),
            ],
          ),

          // child: ListTile(
          //   contentPadding:
          //       EdgeInsets.symmetric(horizontal: 30.sp, vertical: 8.sp),
          //   tileColor: !isDelete ? Colors.white : Color(0xffF8D7DA),
          //   leading: Container(
          //     height: icoHeight,
          //     width: 25.w,
          //     child: SvgPicture.asset(
          //       'assets/svgs/$assetSvg.svg',
          //       // height: 32.h,
          //       color: !isDelete
          //           ? assetSvg == 'flagAccount' || assetSvg == 'lock'
          //               ? AppColors.black3.withOpacity(0.75)
          //               : AppColors.black3
          //           : Color(0xffDC3545),
          //     ),
          //   ),
          //   trailing: SvgPicture.asset(
          //     'assets/svgs/arrowRight.svg',
          //     height: 25.sp,
          //     color: isDelete ? Color(0xffDC3545) : AppColors.black3,
          //   ),
          //   title: Text(title,
          //       style: !isDelete
          //           ? AppFont.H3.copyWith(
          //               fontSize: 20.sp,
          //               fontWeight: FontWeight.w400,
          //               color: AppColors.clearBlack)
          //           : AppFont.H3.copyWith(
          //               fontSize: 20.sp,
          //               fontWeight: FontWeight.w400,
          //               color: Color(0xffDC3545),
          //             )))
        ),
      ),
    );
  }
}
