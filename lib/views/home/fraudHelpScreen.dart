import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FraudHelpDesk extends StatelessWidget {
  final url = 'https://www.fraudehelpdesk.nl/';
  final phoneNumber = '0887867272';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading:InkWell(
            onTap: () async {
              Navigator.pop(context);

            },
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: SvgPicture.asset(
                'assets/svgs/arrowLeft.svg',
              ),
            ),

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
                LocaleKeys.NAVBARCONTENT_FRAUDHELPDESK.tr(),
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
      ) ,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: SCREENWIDTH.w,
                height: SCREENHEIGHT.h * 0.15,
                padding: EdgeInsets.all(25.sp),
                color: AppColors.background,
                child: Image.asset(
                  'assets/images/fraudhelpdesk.png',
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 31.w, vertical: 25.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        LocaleKeys.FRAUDHELPDESK_TITLE1.tr(),
                        style: AppFont.H3,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        LocaleKeys.FRAUDHELPDESK_COTNENT.tr(),
                        style: AppFont.messageTitle
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final url =
                            'https://www.fraudehelpdesk.nl/fraude-melden/';
                        await launch(url);
                      },
                      child: fhAlertStrip(
                        msg: LocaleKeys.FRAUDHELPDESK_SUBTITLE1.tr(),
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final url =
                            'https://www.fraudehelpdesk.nl/valse-e-mail-melden/';
                        await launch(url);
                      },
                      child: fhAlertStrip(
                        msg: LocaleKeys.FRAUDHELPDESK_SUBTITLE2.tr(),
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 31.w, vertical: 5.h),
                      child: Text(
                        LocaleKeys.COMMON_CONTACT.tr(),
                        style: AppFont.defaulsmalltHeading,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 31.w, vertical: 5.h),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          style: AppFont.messageTitle.copyWith(
                              fontWeight: FontWeight.w400, color: Colors.black),
                          text: LocaleKeys.FRAUDHELPDESK_CONTENT2.tr(),
                        ),
                        TextSpan(
                            text: "${LocaleKeys.FRAUDHELPDESK_CALL.tr() } "+" ",
                            style: AppFont.messageTitle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        TextSpan(
                            text: '088-7867272',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final tel = 'tel:$phoneNumber';
                                await launch(tel);
                              },
                            style: AppFont.messageTitle.copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary)),
                        TextSpan(
                            text: LocaleKeys.FRAUDHELPDESK_CONTENT2PART.tr(),
                            style: AppFont.messageTitle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        TextSpan(
                            text: 'www.fraudehelpdesk.nl',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://www.fraudehelpdesk.nl/';
                                await launch(url);
                              },
                            // () async {
                            //   if (!await launchUrl(Uri.parse(url))) {
                            //     throw 'Could not launch ${Uri.parse(url)}}';
                            //   }
                            // },
                            style: AppFont.messageTitle.copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary))
                      ])),
                    )
                  ],
                ),
              ),
              Container(
                height: 100,
                // color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class fhAlertStrip extends StatelessWidget {
  String msg;
  fhAlertStrip({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fraudRed,
      height: 75,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 21.w,
          ),
          SvgPicture.asset(
            'assets/svgs/alertfh.svg',
            color: Colors.white,
          ),
          SizedBox(
            width: 21.w,
          ),
          Text(
            msg,
            style: AppFont.messageSubtitle.copyWith(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20.sp),
          )
        ],
      ),
    );
  }
}

void _launchUrl() async {
  final url = 'https://www.fraudehelpdesk.nl/';
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch ${Uri.parse(url)}}';
  }
}



//  if (!await launchUrl(Uri.parse(link))) {
//                                         throw 'Could not launch ${Uri.parse(link)}}';
//                                       }