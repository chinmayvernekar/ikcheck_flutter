import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/Auth/NavigatorSignIn.dart';

import 'package:iKCHECK/widgets/globalWidgets.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:provider/provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({Key? key}) : super(key: key);

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

enum language { en, nl }

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  language radioValue = language.en;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      if (context.locale == Locale('nl')) {
        radioValue = language.nl;
      } else {
        radioValue = language.en;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading:
               InkWell(
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
                       Provider.of<MainProvider>(context).language ==
                      Locale('nl')
                      ? LocaleKeys.COMMON_LANGUAGE.tr()
                      : LocaleKeys.COMMON_LANGUAGE.tr(),

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
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                radioValue = language.nl;
              });
            },
            child: ListTile(
              title: Text(LocaleKeys.COMMON_DUTCH.tr(),style:TextStyle(fontSize: 18.sp)),
              leading: Radio(
                value: language.nl,
                groupValue: radioValue,
                onChanged: (language? value) {
                  setState(() {
                    radioValue = value!;
                  });
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                radioValue = language.en;
              });
            },
            child: ListTile(
              title: Text(LocaleKeys.COMMON_ENGLISH.tr(),style:TextStyle(fontSize: 18.sp)),
              leading: Radio(
                value: language.en,
                groupValue: radioValue,
                onChanged: (language? value) {
                  setState(() {
                    radioValue = value!;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 35.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0.sp),
            child: Container(
              width: double.infinity,
              child: FilledButton(
                  isLoadingFilledBtn: false,
                  title: LocaleKeys.ACCOUNT_PERSONALDATA_CHANGE.tr(),
                  ontap: () async {
                    print("radiovalue is $radioValue");
                    if (radioValue == language.nl) {
                      await storeString('LANG', 'nl');
                    } else {
                      await storeString('LANG', 'en');
                    }

                    setState(() {
                      if (radioValue == language.nl) {
                        context.setLocale(Locale('nl'));

                         context.setLocale(Locale( 'nl'));
                        languageFunction();

                      } else {
                        context.setLocale(Locale('en'));
                        languageFunctionen();
                      }
                    });
                    Provider.of<MainProvider>(context, listen: false)
                        .setLanguageTitle(context.locale);

                    // Navigator.pushReplacement(
                    //   context,
                    //   PageRouteBuilder(
                    //     pageBuilder: (context, animation1, animation2) =>
                    //         NavbarScreen(
                    //       selectedPageIndex: 26,
                    //     ),
                    //     transitionDuration: Duration.zero,
                    //     reverseTransitionDuration: Duration.zero,
                    //   ),
                    // );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
