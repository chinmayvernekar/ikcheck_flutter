import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/globalVariables.dart';
import '../../Utils/navigation.dart';
import '../../Utils/styles.dart';
import '../../generated/locale_keys.g.dart';
import '../../widgets/navbar.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  int dropIndex = -1;
  List faqQA = [];

  @override
  void didChangeDependencies() {
    faqQA = [
      {
        'question': LocaleKeys.HELP_FAQ_QUESTION1.tr(),
        'content': LocaleKeys.HELP_FAQ_CONTENT1.tr(),
        'linkText': '',
        'linkAddress': "",
        'link': '',
      },
      {
        'question': LocaleKeys.HELP_FAQ_QUESTION2.tr(),
        'content': LocaleKeys.HELP_FAQ_CONTENT2.tr(),
        'linkText': '',
        'linkAddress': "",
        'link': '',
      },
      {
        'question': LocaleKeys.HELP_FAQ_QUESTION3.tr(),
        'content': LocaleKeys.HELP_FAQ_CONTENT3.tr(),
        'linkText': '',
        'linkAddress': "",
        'link': '',
      },
      {
        'question': LocaleKeys.HELP_FAQ_QUESTION4.tr(),
        'content': LocaleKeys.HELP_FAQ_CONTENT4.tr(),
        'linkText': '',
        'linkAddress': "",
        'link': '',
        // 'linkAddress': "https://ikcheck.app",
        // 'link': 'https://ikcheck.app',
      },
      {
        'question': LocaleKeys.HELP_FAQ_QUESTION5.tr(),
        'content': LocaleKeys.HELP_FAQ_CONTENT5.tr(),
        'linkText': '',
        'linkAddress': "",
        'link': '',
      },
      {
        'question': LocaleKeys.HELP_FAQ_QUESTION6.tr(),
        'content': LocaleKeys.HELP_FAQ_CONTENT6.tr(),
        'linkText': '',
        'linkAddress': "",
        'link': '',
      },
      {
        'question': LocaleKeys.HELP_FAQ_QUESTION7.tr(),
        'content': LocaleKeys.HELP_FAQ_CONTENT7.tr(),
        'link': '',
        'linkText': '',
        'linkAddress': "",
      },
      {
        'question': LocaleKeys.HELP_FAQ_QUESTION8.tr(),
        'content': LocaleKeys.HELP_FAQ_CONTENT8.tr(),
        'linkText': LocaleKeys.HELP_FAQ_LINKTEXT8.tr(),
        'linkAddress': "mailto:info@ikcheck.com",
        // 'linkAddress': "mailto:info@ikcheck.app",
        'link': 'info@ikcheck.com'
      },
    ];

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
                  LocaleKeys.HELP_FAQHEADER.tr(),
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
        child: Container(
          // height: SCREENHEIGHT.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListView.builder(
                key: Key('builder ${dropIndex.toString()}'), //attention

                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: faqQA.length,
                itemBuilder: (context, index) {
                  return Column(children: <Widget>[
                    Divider(
                      thickness: 1.sp,
                      height: 1.h,
                    ),
                    Theme(
                      data:
                          ThemeData().copyWith(dividerColor: AppColors.ashColor),
                      child: ExpansionTile(
                        onExpansionChanged: ((newState) {
                          if (newState)
                            setState(() {
                              dropIndex = index;
                            });
                          else
                            setState(() {
                              dropIndex = -1;
                            });
                        }),
                        collapsedIconColor: Colors.black.withOpacity(0.5),
                        collapsedBackgroundColor: Colors.white,
                        backgroundColor: AppColors.primary,
                        collapsedTextColor: Colors.black,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        trailing: dropIndex==index?
                        SvgPicture.asset(
                            'assets/svgs/arrowUp.svg',
                             color:  Colors.white,
                        ):SvgPicture.asset(
                            'assets/svgs/arrowDown.svg',
                            color: Colors.black
                          // color:  Colors.white,
                        ),
                        initiallyExpanded: index == dropIndex, //atten
                        tilePadding: EdgeInsets.symmetric(
                            horizontal: 20.sp, vertical: 15.sp),
                        // childrenPadding: EdgeInsets.only(),
                        // backgroundColor: AppColors.primary,
                        title: Text(faqQA[index]['question'],
                            style: AppFont.H3.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            )),

                        children: <Widget>[
                          Container(
                            width: SCREENWIDTH.w,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.sp, vertical: 30.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  faqQA[index]['content'],
                                  softWrap: true,
                                  style: AppFont.s1.copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.clearBlack,
                                  ),
                                ),
                                if (faqQA[index]['link'].isNotEmpty)
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        if (faqQA[index]['linkText'].isNotEmpty)
                                          TextSpan(
                                              text:
                                                  faqQA[index]['linkText'] + ' ',
                                              style:
                                                  AppFont.vtmSupportText.copyWith(
                                                color: AppColors.clearBlack,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w400,
                                              )),
                                        TextSpan(
                                          text: faqQA[index]['link'],
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url =
                                                  faqQA[index]['linkAddress'];
                                              await launch(url);
                                            },
                                          style: AppFont.vtmSupportText.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     if (faqQA[index]['linkText'].isNotEmpty)
                                //       Text(
                                //         faqQA[index]['linkText'] + ' ',
                                //         softWrap: true,
                                //       ),
                                //     SizedBox(
                                //       width: SCREENWIDTH.w * 0.4,
                                //       child: Text(
                                //         faqQA[index]['link'],
                                //         softWrap: true,
                                //         style: AppFont.normal.copyWith(
                                //           fontWeight: FontWeight.w400,
                                //           fontSize: 16.sp,
                                //           color: AppColors.primary,
                                //         ),
                                //       ),
                                //     )
                                //   ],
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]);
                },
              ),
              Divider(
                thickness: 1.sp,
                height: 1.h,
              ),
              SizedBox(
                height: 100.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
