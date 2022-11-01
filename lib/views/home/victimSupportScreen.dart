import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Utils/styles.dart';

class VictimSupportScreen extends StatefulWidget {
  @override
  State<VictimSupportScreen> createState() => _VictimSupportScreenState();
}

class _VictimSupportScreenState extends State<VictimSupportScreen> {
  int dropIndex = -1; // for expansion tiles

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
                  LocaleKeys.NAVBARCONTENT_VICTIMSUPPORT.tr(),
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
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 31.w),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/victimsupport.png',
                  height: 180.h,
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
                        'Hulp na identiteitsfraude',
                        // LocaleKeys.VICTIMSUPPORT_TITLE.tr(),
                        style: AppFont.H3,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        LocaleKeys.VICTIMSUPPORT_COTNENT.tr(),
                        style: AppFont.messageTitle
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                  key: Key('builder ${dropIndex.toString()}'), //attention

                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Theme(
                          data: ThemeData()
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            key: Key(index.toString()), //attention
                            initiallyExpanded: index == dropIndex, //attention
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
                            trailing: dropIndex == index
                                ? SvgPicture.asset('assets/svgs/arrowUp.svg')
                                : SvgPicture.asset(
                                    'assets/svgs/arrowDown.svg',
                                    // color: AppColors.placeHolderGrey,
                                  ),
                            collapsedIconColor: Colors.black.withOpacity(0.5),
                            collapsedBackgroundColor: Colors.white,
                            backgroundColor: AppColors.slachtofferPurple,
                            childrenPadding: EdgeInsets.zero,
                            iconColor: AppColors.clearWhite,
                            collapsedTextColor: Colors.black,
                            textColor: Colors.white,
                            tilePadding: EdgeInsets.symmetric(
                                horizontal: 34.w, vertical: 15.sp),
                            title: Text(
                                index == 0
                                    ? LocaleKeys.VICTIMSUPPORT_SUBTITLE1.tr()
                                    : LocaleKeys.COMMON_CONTACT.tr(),
                                style: AppFont.H3.copyWith(
                                  fontWeight: FontWeight.w500,
                                )),
                            children: <Widget>[
                              index == 0
                                  ? Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 28.w, vertical: 20.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('-'),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SizedBox(
                                                  width: SCREENWIDTH.w * 0.8,
                                                  child: Text(
                                                      LocaleKeys
                                                          .VICTIMSUPPORT_S1P1
                                                          .tr(),
                                                      style: AppFont
                                                          .vtmSupportText
                                                          .copyWith(
                                                        color: AppColors
                                                            .clearBlack,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('-'),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SizedBox(
                                                  width: SCREENWIDTH.w * 0.8,
                                                  child: Text(
                                                      LocaleKeys
                                                          .VICTIMSUPPORT_S1P2
                                                          .tr(),
                                                      style: AppFont
                                                          .vtmSupportText
                                                          .copyWith(
                                                        color: AppColors
                                                            .clearBlack,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('-'),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SizedBox(
                                                  width: SCREENWIDTH.w * 0.8,
                                                  child: Text(
                                                      LocaleKeys
                                                          .VICTIMSUPPORT_S1P3
                                                          .tr(),
                                                      style: AppFont
                                                          .vtmSupportText
                                                          .copyWith(
                                                        color: AppColors
                                                            .clearBlack,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('-'),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SizedBox(
                                                  width: SCREENWIDTH.w * 0.8,
                                                  child: Text(
                                                      LocaleKeys
                                                          .VICTIMSUPPORT_S1P4
                                                          .tr(),
                                                      style: AppFont
                                                          .vtmSupportText
                                                          .copyWith(
                                                        color: AppColors
                                                            .clearBlack,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('-'),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SizedBox(
                                                  width: SCREENWIDTH.w * 0.8,
                                                  child: Text(
                                                      LocaleKeys
                                                          .VICTIMSUPPORT_S1P5
                                                          .tr(),
                                                      style: AppFont
                                                          .vtmSupportText
                                                          .copyWith(
                                                        color: AppColors
                                                            .clearBlack,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            RichText(
                                                softWrap: true,
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "${LocaleKeys.VICTIMSUPPORT_S1P6.tr()} ",
                                                      style: AppFont
                                                          .vtmSupportText
                                                          .copyWith(
                                                        color: AppColors
                                                            .clearBlack,
                                                      )),
                                                  TextSpan(
                                                      text: LocaleKeys
                                                          .VICTIMSUPPORT_S1P7
                                                          .tr(),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              final url =
                                                                  'https://www.slachtofferhulp.nl/gebeurtenissen/fraude/identiteitsfraude/';
                                                              await launch(url);
                                                            },
                                                      style: AppFont
                                                          .vtmSupportText
                                                          .copyWith(
                                                              color: AppColors
                                                                  .primary,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline))
                                                ]))
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 28.w,
                                                  vertical: 20.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  RichText(
                                                    softWrap: true,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: LocaleKeys
                                                                .VICTIMSUPPORT_S2P1
                                                                .tr(),
                                                            style: AppFont
                                                                .messageTitle
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black)),
                                                        TextSpan(
                                                            text:
                                                                '${LocaleKeys.FRAUDHELPDESK_CALL.tr()} ',
                                                            style: AppFont
                                                                .messageTitle
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black)),
                                                        TextSpan(
                                                            text: '0900-0101',
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap =
                                                                      () async {
                                                                    final phoneNumber =
                                                                        '0900-0101';
                                                                    final tel =
                                                                        'tel:$phoneNumber';
                                                                    await launch(
                                                                        tel);
                                                                  },
                                                            style: AppFont
                                                                .vtmSupportText
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .primary,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline)),
                                                        TextSpan(
                                                            text:
                                                                " ${LocaleKeys.VICTIMSUPPORT_S2P2.tr()} ",
                                                            style: AppFont
                                                                .messageTitle
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black)),
                                                        TextSpan(
                                                            text:
                                                                '${LocaleKeys.VICTIMSUPPORT_S2P3.tr()}',
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap =
                                                                      () async {
                                                                    final url =
                                                                        'https://www.slachtofferhulp.nl/gebeurtenissen/fraude/identiteitsfraude/';
                                                                    await launch(
                                                                        url);
                                                                  },
                                                            style: AppFont
                                                                .vtmSupportText
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .primary,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
              // Consumer<MainProvider>(
              //   builder: (context, value, child) {
              //     return Theme(
              //       data:
              //           ThemeData().copyWith(dividerColor: Colors.transparent),
              //       child: ExpansionTile(
              //         key: Key('1'), //attention

              //         onExpansionChanged: (value) {
              //           setState(() {
              //             Provider.of<MainProvider>(context, listen: false)
              //                 .setDropIndex(1);
              //           });
              //         },
              //         collapsedIconColor: Colors.black.withOpacity(0.5),
              //         collapsedBackgroundColor: Colors.white,
              //         backgroundColor: AppColors.slachtofferPurple,
              //         childrenPadding: EdgeInsets.zero,
              //         iconColor: AppColors.clearWhite,
              //         collapsedTextColor: Colors.black,
              //         textColor: Colors.white,
              //         tilePadding: EdgeInsets.symmetric(horizontal: 34.w),
              //         title: Text(LocaleKeys.VICTIMSUPPORT_SUBTITLE1.tr(),
              //             style: AppFont.H3.copyWith(
              //               fontWeight: FontWeight.w500,
              //             )),
              //         children: <Widget>[
              //           Container(
              //             color: Colors.white,
              //             child: Padding(
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: 28.w, vertical: 20.h),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.stretch,
              //                 children: [
              //                   RichText(
              //                       softWrap: true,
              //                       text: TextSpan(children: [
              //                         TextSpan(
              //                             text: LocaleKeys.VICTIMSUPPORT_S1P1
              //                                 .tr(),
              //                             style:
              //                                 AppFont.vtmSupportText.copyWith(
              //                               color: AppColors.clearBlack,
              //                             )),
              //                         TextSpan(
              //                             text: LocaleKeys.VICTIMSUPPORT_S1P2
              //                                 .tr(),
              //                             style:
              //                                 AppFont.vtmSupportText.copyWith(
              //                               color: AppColors.clearBlack,
              //                             )),
              //                         TextSpan(
              //                             text: LocaleKeys.VICTIMSUPPORT_S1P3
              //                                 .tr(),
              //                             style:
              //                                 AppFont.vtmSupportText.copyWith(
              //                               color: AppColors.clearBlack,
              //                             )),
              //                         TextSpan(
              //                             text: LocaleKeys.VICTIMSUPPORT_S1P4
              //                                 .tr(),
              //                             style:
              //                                 AppFont.vtmSupportText.copyWith(
              //                               color: AppColors.clearBlack,
              //                             )),
              //                         TextSpan(
              //                             text: LocaleKeys.VICTIMSUPPORT_S1P5
              //                                 .tr(),
              //                             style:
              //                                 AppFont.vtmSupportText.copyWith(
              //                               color: AppColors.clearBlack,
              //                             )),
              //                         TextSpan(
              //                             text:
              //                                 ' ${LocaleKeys.VICTIMSUPPORT_S1P6.tr()}',
              //                             recognizer: TapGestureRecognizer()
              //                               ..onTap = () async {
              //                                 final url =
              //                                     'https://www.slachtofferhulp.nl/gebeurtenissen/fraude/identiteitsfraude/';
              //                                 await launch(url);
              //                               },
              //                             style: AppFont.vtmSupportText
              //                                 .copyWith(
              //                                     color: AppColors.primary,
              //                                     decoration:
              //                                         TextDecoration.underline))
              //                       ]))
              //                 ],
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     );
              //   },
              // ),
              // Consumer<MainProvider>(
              //   builder: (context, value, child) {
              //     return ExpansionTile(
              //       key: Key('2'), //attention
              //       initiallyExpanded: 2 == value.dropIndex, //
              //       onExpansionChanged: (value) {
              //         Provider.of<MainProvider>(context, listen: false)
              //             .setDropIndex(2);
              //       },
              //       childrenPadding: EdgeInsets.zero,
              //       collapsedIconColor: Colors.black.withOpacity(0.5),
              //       collapsedBackgroundColor: Colors.white,
              //       iconColor: Colors.white,
              //       backgroundColor: AppColors.slachtofferPurple,
              //       collapsedTextColor: Colors.black,
              //       textColor: Colors.white,
              //       tilePadding: EdgeInsets.symmetric(horizontal: 34.w),
              //       title: Text(LocaleKeys.COMMON_CONTACT.tr(),
              //           style: AppFont.H3.copyWith(
              //             fontWeight: FontWeight.w500,
              //           )),
              //       children: <Widget>[
              //         Container(
              //           color: Colors.white,
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.stretch,
              //             children: [
              //               Container(
              //                 color: Colors.white,
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       horizontal: 28.w, vertical: 20.h),
              //                   child: Column(
              //                     crossAxisAlignment:
              //                         CrossAxisAlignment.stretch,
              //                     children: [
              //                       RichText(
              //                           softWrap: true,
              //                           text: TextSpan(children: [
              //                             TextSpan(
              //                                 text: LocaleKeys
              //                                     .VICTIMSUPPORT_S2P1
              //                                     .tr(),
              //                                 style: AppFont.messageTitle
              //                                     .copyWith(
              //                                         fontWeight:
              //                                             FontWeight.w400,
              //                                         color: Colors.black)),
              //                             TextSpan(
              //                                 text: LocaleKeys
              //                                     .FRAUDHELPDESK_CALL
              //                                     .tr(),
              //                                 style: AppFont.messageTitle
              //                                     .copyWith(
              //                                         fontWeight:
              //                                             FontWeight.w400,
              //                                         color: Colors.black)),
              //                             TextSpan(
              //                                 text: ' 0900-0101 ',
              //                                 recognizer: TapGestureRecognizer()
              //                                   ..onTap = () async {
              //                                     final phoneNumber =
              //                                         '0900-0101';
              //                                     final tel =
              //                                         'tel:$phoneNumber';
              //                                     await launch(tel);
              //                                   },
              //                                 style: AppFont.vtmSupportText
              //                                     .copyWith(
              //                                         color: AppColors.primary,
              //                                         decoration: TextDecoration
              //                                             .underline)),
              //                             TextSpan(
              //                                 text: LocaleKeys
              //                                     .VICTIMSUPPORT_S2P2
              //                                     .tr(),
              //                                 style: AppFont.messageTitle
              //                                     .copyWith(
              //                                         fontWeight:
              //                                             FontWeight.w400,
              //                                         color: Colors.black)),
              //                             TextSpan(
              //                                 text:
              //                                     ' ${LocaleKeys.VICTIMSUPPORT_S2P3.tr()}',
              //                                 recognizer: TapGestureRecognizer()
              //                                   ..onTap = () async {
              //                                     final url =
              //                                         'https://www.slachtofferhulp.nl/gebeurtenissen/fraude/identiteitsfraude/';
              //                                     await launch(url);
              //                                   },
              //                                 style: AppFont.vtmSupportText
              //                                     .copyWith(
              //                                         color: AppColors.primary,
              //                                         decoration: TextDecoration
              //                                             .underline)),
              //                           ]))
              //                     ],
              //                   ),
              //                 ),
              //               )
              //             ],
              //           ),
              //         )
              //       ],
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
