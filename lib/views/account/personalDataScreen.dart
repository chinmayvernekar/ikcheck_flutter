import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Models/AccountModel.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/widgets/globalWidgets.dart';
import 'package:provider/provider.dart';

import '../../Utils/globalVariables.dart';

class PersonalDataScreen extends StatefulWidget {
  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  bool alertBool = false;
  bool alertStatus = false;
  String content = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        firstName.text = Provider.of<MainProvider>(context, listen: false)
            .accountDetails
            .firstName ??
            '';
        lastName.text = Provider.of<MainProvider>(context, listen: false)
            .accountDetails
            .lastName ??
            '';
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    alertBool = false;
    alertStatus = false;
    content = '';
    firstName.clear();
    lastName.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading:InkWell(
            onTap: () async {

              Navigator.of(context).pop();

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
                  LocaleKeys.NAVBARCONTENT_PERSONALDATA.tr(),
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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
        //  height:size.height,
          child: Column(
            children: [
              if (alertBool)
                SizedBox(
                  child: stripAlert(alertStatus, content),
                ),
              SizedBox(
                height: 15.h,
              ),
              LabelField(
                title: LocaleKeys.ACCOUNT_PERSONALDATA_FIRSTNAME.tr(),
                controller: firstName,
                placeHolder:
                LocaleKeys.ACCOUNT_PERSONALDATA_ENTERYOURFIRSTNAME.tr(),
                scrollPadding: EdgeInsets.only(bottom: SCREENHEIGHT.h * 0.2),
                restrictChars: 25,
              ),
              LabelField(
                title: LocaleKeys.ACCOUNT_PERSONALDATA_LASTNAME.tr(),
                controller: lastName,
                placeHolder: LocaleKeys.ACCOUNT_PERSONALDATA_ENTERYOURLASTNAME.tr(),
                scrollPadding: EdgeInsets.only(bottom: SCREENHEIGHT.h * 0.2),
                restrictChars: 25,
              ),
              SizedBox(
                height: 35.h,
              ),
              Padding(
               // padding: EdgeInsets.symmetric(horizontal:18.sp, vertical:70.sp),
                padding: EdgeInsets.only(left:18.sp,right:18.sp, bottom:70.sp),
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
                    title: LocaleKeys.ACCOUNT_PERSONALDATA_CHANGE.tr(),
                    ontap: () async {
                      AccountModal data =
                          Provider.of<MainProvider>(context, listen: false)
                              .accountDetails;
                      // if (firstName.text.isNotEmpty ||
                      //     lastName.text.isNotEmpty) {
                        if (firstName.text.isNotEmpty) {
                          data.firstName = firstName.text;
                        }else{
                           setState(() {
                            alertBool = true;
                            alertStatus = false;
                            content =
                            "${LocaleKeys.ACCOUNT_PERSONALDATA_NAMEERRORMSG.tr()}!";
                          });
                          return;
                        }

                        // if (lastName.text.isNotEmpty) {
                          data.lastName = lastName.text;
                        // }

                        data.password = null;
                        Map decodedData = data.toJson();
                        setState(() {
                          isLoadingPD = true;
                        });
                        String res = await ApiCallManagement()
                            .updateAccountDetails(decodedData, context);

                        if (res == 'SUCCESS') {
                        //  await storeString('userid', firstName.text);
                          userNameGlobel = await getString('userid') ?? '';
                          setState(() {
                            userNameGlobel;
                            alertBool = true;
                            alertStatus = true;
                            content = LocaleKeys
                                .ACCOUNT_PERSONALDATA_NAMEHASBEENUPDATED
                                .tr();
                          });
                        } else {
                          setState(() {
                            alertBool = true;
                            alertStatus = false;
                            content =
                            "${LocaleKeys.COMMON_SOMETHINGWENTWRONG.tr()}!";
                          });
                        }
                        setState(() {
                          isLoadingPD = false;
                        });
                      // }
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
}
