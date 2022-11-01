import 'package:dbcrypt/dbcrypt.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Models/AccountModel.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:provider/provider.dart';
import '../../widgets/globalWidgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool alertBool = false;
  bool alertStatus = false;
  String content = '';

  @override
  void dispose() {
    alertBool = false;
    alertStatus = false;
    content = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
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
                  LocaleKeys.ACCOUNT_PASSWORD_PASSWORD.tr(),
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
      body: SingleChildScrollView(
        child:
           SizedBox(

            height: SCREENHEIGHT.h,
            child: ListView(
              shrinkWrap: true,
              controller: _scrollController,
              children: [
                if (alertBool)
                  stripAlert(
                    alertStatus,
                    content,
                  ),
                SizedBox(
                  height: 15.h,
                ),
                LabelField(
                  title: LocaleKeys.ACCOUNT_PASSWORD_CURRENTPW.tr(),
                  controller: currentPassword,
                  onChange: 'OLD',
                  trailing: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: SvgPicture.asset(
                      'assets/svgs/eye.svg',
                      color: AppColors.iconGrey,
                    ),
                  ),
                  ifPassword: true,
                  placeHolder:
                      LocaleKeys.ACCOUNT_PASSWORD_ENTERYOURCURRENTPASSWORD.tr(),
                  scrollPadding: EdgeInsets.only(bottom: 0),
                ),
                if (Provider.of<MainProvider>(context)
                    .passwordValidatorOldChangePassword)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (currentPassword.text.length <= 7)
                                ? Icon(
                                    Icons.close,
                                    color: AppColors.errorRed,
                                    size: 20.sp,
                                  )
                                : Icon(
                                    Icons.done,
                                    size: 20.sp,
                                    color: AppColors.successStripForeground,
                                  ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA1.tr(),
                              softWrap: true,
                              style: AppFont.errorText.copyWith(
                                color: (currentPassword.text.length <= 7)
                                    ? AppColors.errorRed
                                    : AppColors.successStripForeground,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])')
                                    .hasMatch(currentPassword.text))
                                ? Icon(
                                    Icons.done,
                                    size: 20.sp,
                                    color: AppColors.successStripForeground,
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
                              LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA2.tr(),
                              style: AppFont.errorText.copyWith(
                                color: (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])')
                                        .hasMatch(currentPassword.text))
                                    ? AppColors.successStripForeground
                                    : AppColors.errorRed,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (RegExp(r'^(?=.*?[0-9])')
                                        .hasMatch(currentPassword.text) &&
                                    RegExp(r'(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                        .hasMatch(currentPassword.text))
                                ? Icon(
                                    Icons.done,
                                    size: 20.sp,
                                    color: AppColors.successStripForeground,
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
                                            .hasMatch(currentPassword.text) &&
                                        RegExp(r'(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                            .hasMatch(currentPassword.text))
                                    ? AppColors.successStripForeground
                                    : AppColors.errorRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                LabelField(
                  title: LocaleKeys.ACCOUNT_PASSWORD_NEWPW.tr(),
                  controller: newPassword,
                  onChange: 'NEW',
                  trailing: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: SvgPicture.asset(
                      'assets/svgs/eye.svg',
                      color: AppColors.iconGrey,
                    ),
                  ),
                  ifPassword: true,
                  placeHolder:
                      LocaleKeys.ACCOUNT_PASSWORD_ENTERYOURNEWPASSWORD.tr(),
                  scrollPadding: EdgeInsets.only(bottom: 0),
                ),
                if (Provider.of<MainProvider>(context)
                    .passwordValidatorChangePassword)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (newPassword.text.length <= 7)
                                ? Icon(
                                    Icons.close,
                                    color: AppColors.errorRed,
                                    size: 20.sp,
                                  )
                                : Icon(
                                    Icons.done,
                                    size: 20.sp,
                                    color: AppColors.successStripForeground,
                                  ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA1.tr(),
                              softWrap: true,
                              style: AppFont.errorText.copyWith(
                                color: (newPassword.text.length <= 7)
                                    ? AppColors.errorRed
                                    : AppColors.successStripForeground,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])')
                                    .hasMatch(newPassword.text))
                                ? Icon(
                                    Icons.done,
                                    size: 20.sp,
                                    color: AppColors.successStripForeground,
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
                              LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA2.tr(),
                              style: AppFont.errorText.copyWith(
                                color: (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])')
                                        .hasMatch(newPassword.text))
                                    ? AppColors.successStripForeground
                                    : AppColors.errorRed,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (RegExp(r'^(?=.*?[0-9])')
                                        // r'^(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                        .hasMatch(newPassword.text) &&
                                    RegExp(r'(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                        .hasMatch(newPassword.text))
                                ? Icon(
                                    Icons.done,
                                    size: 20.sp,
                                    color: AppColors.successStripForeground,
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
                                            .hasMatch(newPassword.text) &&
                                        RegExp(r'(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~])')
                                            .hasMatch(newPassword.text))
                                    ? AppColors.successStripForeground
                                    : AppColors.errorRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                LabelField(
                  title: LocaleKeys.ACCOUNT_PASSWORD_CONFIRMPW.tr(),
                  controller: confirmPassword,
                  trailing: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: SvgPicture.asset(
                      'assets/svgs/eye.svg',
                      color: AppColors.iconGrey,
                    ),
                  ),
                  placeHolder:
                      LocaleKeys.ACCOUNT_PASSWORD_RENTERYOURCONFIRMPASSWORD.tr(),
                  scrollPadding: EdgeInsets.only(bottom: SCREENHEIGHT.h * 0.2),
                  ifPassword: true,
                ),
                SizedBox(
                  height: SCREENHEIGHT.h * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0.sp),
                  child: Container(
                    width: double.infinity,
                    child: isLoadingPD
                        ? FilledButton(
                            title: '',
                            ontap: () {},
                            isLoadingFilledBtn: true,
                          )
                        : FilledButton(
                            isLoadingFilledBtn: false,
                            title: LocaleKeys.ACCOUNT_PASSWORD_CHANGEPW.tr(),
                            ontap: () async {
                              AccountModal data =
                                  Provider.of<MainProvider>(context, listen: false)
                                      .accountDetails;
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!”#$%&’()*+,-./:;<=>?@[\]^_`{|}~]).{8,}$');
                              if (newPassword.text.isEmpty ||
                                  confirmPassword.text.isEmpty ||
                                  currentPassword.text.isEmpty) {
                                setState(() {
                                  alertBool = true;
                                  alertStatus = false;
                                  content = LocaleKeys
                                      .ACCOUNT_PASSWORD_INVALIDNEWCONPW
                                      .tr();
                                });
                                // } else if (!getBcryptComparision(currentPassword.text)) {
                                //   setState(() {
                                //     alertBool = true;
                                //     alertStatus = false;
                                //     content =
                                //         LocaleKeys.ACCOUNT_PASSWORD_INVALIDCURRENTPW.tr();
                                //   });
                              } else if (newPassword.text != confirmPassword.text) {
                                setState(() {
                                  alertBool = true;
                                  alertStatus = false;
                                  content = LocaleKeys
                                      .ACCOUNT_PASSWORD_INVALIDMATCHNEWCONPW
                                      .tr();
                                });
                              } else if (!regex.hasMatch(newPassword.text) ||
                                  !regex.hasMatch(currentPassword.text)) {
                                Provider.of<MainProvider>(context, listen: false)
                                    .setPasswordValidatorChangePassword(true);
                                // alertBool = true;
                                // alertStatus = false;
                                // content = '${LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA1.tr()}' +
                                //     '\n' +
                                //     '${LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA2.tr()}' +
                                //     '\n' +
                                //     '${LocaleKeys.ALERTMESSAGE_PASSWORDPATTERN_DATA3.tr()}';
                              } else {
                                setState(() {
                                  isLoadingPD = true;
                                });
                                data.password = newPassword.text;
                                Map decodedData = data.toJson();
                                decodedData['oldPassword'] = currentPassword.text;
                                String res = await ApiCallManagement()
                                    .updateAccountDetails(decodedData, context);
                                if (res == 'SUCCESS') {
                                  currentPassword.clear();
                                  newPassword.clear();
                                  confirmPassword.clear();
                                  Provider.of<MainProvider>(context, listen: false)
                                      .setPasswordValidatorChangePassword(false);
                                  Provider.of<MainProvider>(context, listen: false)
                                      .setPasswordValidatorOldChangePassword(false);
                                  setState(() {
                                    alertBool = true;
                                    alertStatus = true;
                                    content = LocaleKeys
                                        .ACCOUNT_PASSWORD_PASSWORDCHANGED
                                        .tr();
                                  });
                                } else if (res == 'Old password incorrect') {
                                  setState(() {
                                    alertBool = true;
                                    alertStatus = false;
                                    content = LocaleKeys
                                        .ACCOUNT_PASSWORD_INVALIDMATCHOLDPW
                                        .tr();
                                  });
                                } else {
                                  setState(() {
                                    alertBool = true;
                                    alertStatus = false;
                                    content =
                                        LocaleKeys.COMMON_SOMETHINGWENTWRONG.tr();
                                  });
                                }
                                setState(() {
                                  isLoadingPD = false;
                                });
                              }
                            },
                          ),
                  ),
                )
              ],
            ),
          ),

      ),
    );
  }

  // bool getBcryptComparision(String text) {
  //   DBCrypt dBCrypt = DBCrypt();
  //   bool _x = true;
  //   // assert(
  //   _x = dBCrypt.checkpw(
  //       // 'US@NL$text',
  //       Provider.of<MainProvider>(context, listen: false)
  //           .accountDetails
  //           .password
  //           .toString());
  //   // true);
  //   return _x;
  // }
}
