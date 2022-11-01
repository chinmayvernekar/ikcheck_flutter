import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/Auth/NavigatorSignIn.dart';
import 'package:iKCHECK/views/Auth/SignInScreen.dart';
import 'package:iKCHECK/views/Auth/signupScreen.dart';
import 'package:iKCHECK/widgets/globalWidgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool alertBool = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading:  InkWell(
            onTap: () async {
              Navigator.pop(context);

            },
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: SvgPicture.asset(
                'assets/svgs/arrowLeft.svg',
              ),
            ),
            // child: Padding(
            //   padding: EdgeInsets.all(10.sp),
            //   child: Icon(
            //     Icons.arrow_back_ios_new_rounded,
            //     color: AppColors.clearBlack,
            //   ),
            // child: Icon(
            //   Icons.arrow_back_ios_new_rounded,
            //   color: AppColors.clearBlack,
            // ),
            // ),
          ),
          toolbarHeight: 100.h,
          backgroundColor: AppColors.clearWhite,
          elevation: 0,
          title: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.ACCOUNT_DELETEACCOUNT_DELETEACCOUNT.tr(),
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
        height: SCREENHEIGHT.h,
        child: Column(
          children: <Widget>[
            if (alertBool)
              SizedBox(
                child: stripAlert(
                    false, '${LocaleKeys.COMMON_SOMETHINGWENTWRONG.tr()}!'),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.lightPrimaryStrip,
                    borderRadius: BorderRadius.circular(20.sp)),
                padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/warning.svg',
                            height: 60.h,
                            color: AppColors.primaryLight,
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          Expanded(
                            // width: SCREENWIDTH.w * 0.5,
                            child: Text(
                              "${LocaleKeys.ACCOUNT_DELETEACCOUNT_PERMENENTLY.tr()}" +
                                  ' \n' +
                                  "${LocaleKeys.ACCOUNT_DELETEACCOUNT_DELDATA.tr()}",
                                  softWrap: true,
                              style: AppFont.H3.copyWith(fontSize: 22.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20.sp),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${LocaleKeys.ACCOUNT_DELETEACCOUNT_WARNING.tr().toUpperCase()}: '+" ",
                              style: AppFont.normal.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.clearBlack,
                              ),
                            ),
                            TextSpan(
                              text: LocaleKeys
                                  .ACCOUNT_DELETEACCOUNT_WARNINGCONTENT
                                  .tr(),
                              style: AppFont.s1.copyWith(
                                fontSize: 15.sp,
                                color: AppColors.clearBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
              child: Container(
                padding: EdgeInsets.all(15.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  color: AppColors.clearWhite,
                  border: Border.all(
                    width: 1,
                    color: AppColors.primaryLight,
                  ),
                ),
                child:  Text(
    LocaleKeys.ACCOUNT_DELETEACCOUNT_DATA.tr(),
    style: AppFont.s1.copyWith(fontSize: 16.sp),
    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      title: LocaleKeys.COMMON_YES.tr().toUpperCase(),
                      ontap: () async {
                        setState(() {
                          alertBool = false;
                        });
                        String res =
                            await ApiCallManagement().deleteAccount(context);
                        if (res == 'SUCCESS') {
                          // String firstTimeUser =
                          //     await getString('firstTimeUser') ?? '';
                          String currentLang = await getString('LANG') ?? '';
                          await clearStorage();
                          await storeString('LANG', currentLang);
                          deleteAccountNav();
                          pushNewScreen(
                            context,
                            screen: SignUpScreen(deleteAccount: true),
                            withNavBar: false,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );

                        } else {
                          setState(() {
                            alertBool = true;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: FilledButton(
                      isLoadingFilledBtn: false,
                      title: LocaleKeys.COMMON_NO.tr().toUpperCase(),
                      ontap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
