import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/views/RDW/identityScreen.dart';
import 'package:iKCHECK/views/RDW/unlinkDLScreen.dart';
import 'package:iKCHECK/views/home/dashboardScreen.dart';
import 'package:iKCHECK/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/styles.dart';
import '../../widgets/navbar.dart';

class RDWDLlinkedScreen extends StatefulWidget {
  const RDWDLlinkedScreen({Key? key}) : super(key: key);

  @override
  State<RDWDLlinkedScreen> createState() => _RDWDLlinkedScreenState();
}

class _RDWDLlinkedScreenState extends State<RDWDLlinkedScreen> {
  int dropIndex = -1;
  // String Dlnumber = '*******4075';

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (Provider.of<MainProvider>(context, listen: false)
    //       .enquiryItems
    //       .isNotEmpty) {
    //     Dlnumber = Provider.of<MainProvider>(context, listen: false)
    //                 .enquiryItems['items'] !=
    //             null
    //         ? "*******${Provider.of<MainProvider>(context, listen: false).enquiryItems['items'][0]['reference']}"
    //         : '';
    //     setState(() {
    //       Dlnumber;
    //     });
    //   }
    // });
    super.initState();
  }

  String getLatestConsentLicenseNo(List listData) {
// [0]['reference']
    try {
      print("Hello $listData");
      var data = listData.firstWhere((element) => (element['type'] ==
              'RDW_DL_CON' &&
          (element['reference'] != null && element['reference'].isNotEmpty)));
      data['reference'] == 'null' ? "" : data['reference'] ?? "";
      print("Hello Return $data");
      return data['reference'] == 'null' ? "" : data['reference'] ?? "";
    } catch (e) {
      print("YHHHHHHH $e");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: AppBar(
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () async {
                Navigator.pop(context);
                // Navigator.pushNamedAndRemoveUntil(
                //     context, 'rdwLinkedBack', (route) => false);
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
                    LocaleKeys.DASHBOARD_IDENTITIES.tr(),
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 46.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.IDENTITIES_DRIVERSLICENSE.tr(),
                      style: AppFont.H1.copyWith(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.clearBlack),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SvgPicture.asset(
                      'assets/svgs/identity.svg',
                      height: 60.sp,
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1.sp,
                height: 0,
                color: AppColors.clearBlack.withOpacity(0.1),
              ),
              Container(
                  width: double.infinity,
                  // height: 290.h,

                  color: Colors.white,
                  child: Container(
                    // padding: EdgeInsets.only(
                    //   top: Provider.of<MainProvider>(context)
                    //               .enquiryItems
                    //               .isNotEmpty &&
                    //           Provider.of<MainProvider>(context, listen: false)
                    //                   .enquiryItems['items'] !=
                    //               null
                    //       ? 38.h
                    //       : 0.h,
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // if (getValueBasedonAuthStatus(context))
                        //   Divider(
                        //     height: 2,
                        //     color: AppColors.clearBlack.withOpacity(0.1),
                        //   ),
                        if (getValueBasedonAuthStatus(context))
                          Provider.of<MainProvider>(context)
                                      .enquiryItems
                                      .isNotEmpty &&
                                  Provider.of<MainProvider>(context,
                                              listen: false)
                                          .enquiryItems['items'] !=
                                      null
                              ? getLatestConsentLicenseNo(
                                          Provider.of<MainProvider>(context)
                                              .enquiryItems['items'])
                                      .isNotEmpty
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30.sp,
                                      ),
                                      height: 74.5,
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${LocaleKeys.IDENTITIES_DLNO.tr()}',
                                              style: AppFont.H3.copyWith(
                                                fontSize: 23.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            //  if(getValidLicenseNo(Provider.of<MainProvider>(context,listen: false).enquiryItems['items'][0]['reference']))

                                            Text(
                                              "*******${getLatestConsentLicenseNo(Provider.of<MainProvider>(context).enquiryItems['items'])}",
                                              style: AppFont.H3.copyWith(
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()
                              : SizedBox(
                                  width: SCREENWIDTH.w,
                                  child: buildSkeletonAnimation(),
                                ),
                        // if (getValueBasedonAuthStatus(context))
                        // SizedBox(
                        //   height: 30.h,
                        // ),
                        Divider(
                          thickness: 0.6,
                          height: 1,
                          color: AppColors.ashColor,
                        ),
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            ListView.builder(
                              key: Key(
                                  'builder ${dropIndex.toString()}'), //attention

                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Column(children: <Widget>[
                                  Theme(
                                    data: ThemeData().copyWith(
                                        dividerColor: AppColors.disableColor),
                                    child: ExpansionTile(
                                      onExpansionChanged: ((newState) {
                                        print(newState);
                                        if (newState)
                                          setState(() {
                                            dropIndex = index;
                                          });
                                        else
                                          setState(() {
                                            dropIndex = -1;
                                          });
                                      }),

                                      collapsedBackgroundColor: Colors.white,
                                      backgroundColor: AppColors.primary,
                                      collapsedTextColor: Colors.black,
                                      textColor: Colors.white,
                                      trailing: dropIndex == index
                                          ? SvgPicture.asset(
                                              'assets/svgs/arrowUp.svg',
                                              color: Colors.white
                                              // color:  Colors.white,
                                              )
                                          : SvgPicture.asset(
                                              'assets/svgs/arrowDown.svg',
                                            ),
                                      initiallyExpanded:
                                          index == dropIndex, //atten
                                      tilePadding: EdgeInsets.symmetric(
                                          horizontal: 30.sp, vertical: 10.sp),
                                      // childrenPadding: EdgeInsets.only(),
                                      // backgroundColor: AppColors.primary,
                                      title: Text(
                                          index == 0
                                              ? LocaleKeys.IDENTITIES_ACTIVITIES
                                                  .tr()
                                              : LocaleKeys.COMMON_DATA.tr(),
                                          style: AppFont.H3.copyWith(
                                            fontWeight: FontWeight.w500,
                                          )),

                                      children: <Widget>[
                                        index == 0
                                            ? Consumer<MainProvider>(
                                                builder:
                                                    (context, value, child) {
                                                  List items =
                                                      value.enquiryItems[
                                                              'items'] ??
                                                          [];

                                                  return items.isNotEmpty
                                                      ? Container(
                                                          color: AppColors
                                                              .clearWhite,
                                                          // height:
                                                          //     SCREENHEIGHT.h *
                                                          //         0.152 *
                                                          //         items.length,

                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                                items.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Column(
                                                                children: [
                                                                  Container(
                                                                    // height: SCREENHEIGHT
                                                                    //         .h *
                                                                    //     0.152,
                                                                    color: Colors
                                                                        .white,
                                                                    // color: Colors.white,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            30.sp,
                                                                        vertical:
                                                                            20.sp,
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Text(
                                                                            alertTranslate(items[index]['details']),
                                                                            style:
                                                                                AppFont.normal.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18.sp,
                                                                              color: Color(0xff061025),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            getFormatedDateTime(items[index]['time']),
                                                                            style:
                                                                                AppFont.messageSubtitle.copyWith(
                                                                              fontSize: 18.sp,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: AppColors.clearBlack.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: <Widget>[
                                                                              // items[index]['status'] == 'To Be Attended'
                                                                              //     ? SvgPicture.asset(
                                                                              //         'assets/svgs/tick.svg',
                                                                              //         height: 15.h,
                                                                              //       )
                                                                              //     : SvgPicture.asset(
                                                                              //         'assets/svgs/fraud.svg',
                                                                              //         height: 15.h,
                                                                              //       ),
                                                                              getSvgBasedonStatus(items[index]['status']),
                                                                              SizedBox(
                                                                                width: 5.w,
                                                                              ),
                                                                              Text(
                                                                                getStatusString(items[index]['status']),
                                                                                // items[index]['status'] == 'To Be Attended' ? LocaleKeys.IDENTITIES_USERCHECKEDALERT.tr() : LocaleKeys.IDENTITIES_USERFRAUDALERT.tr(),
                                                                                style: AppFont.normal.copyWith(
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontSize: 18.sp,
                                                                                  color: Color(0xff061025),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  (items.length -
                                                                              1) !=
                                                                          index
                                                                      ? Divider(
                                                                          thickness:
                                                                              1.sp,
                                                                          height:
                                                                              1.sp,
                                                                          color:
                                                                              AppColors.ashColor,
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : Container();
                                                },
                                              )
                                            : Container(
                                                width: SCREENWIDTH.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30.sp,
                                                    vertical: 10.sp),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      LocaleKeys
                                                          .IDENTITIES_DATA1
                                                          .tr(),
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18.sp,
                                                        color:
                                                            Color(0xff061025),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(width: 10),
                                                        Text('-'),
                                                        SizedBox(
                                                          width: SCREENWIDTH.w *
                                                              0.8,
                                                          child: Text(
                                                            LocaleKeys
                                                                .IDENTITIES_DATA2
                                                                .tr(),
                                                            softWrap: true,
                                                            style: AppFont
                                                                .normal
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18.sp,
                                                              color: Color(
                                                                  0xff061025),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(width: 10),
                                                        Text('-'),
                                                        SizedBox(
                                                          width: SCREENWIDTH.w *
                                                              0.8,
                                                          child: Text(
                                                            LocaleKeys
                                                                .IDENTITIES_DATA3
                                                                .tr(),
                                                            softWrap: true,
                                                            style: AppFont
                                                                .normal
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18.sp,
                                                              color: Color(
                                                                  0xff061025),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(width: 10),
                                                        Text('-'),
                                                        SizedBox(
                                                          width: SCREENWIDTH.w *
                                                              0.8,
                                                          child: Text(
                                                            LocaleKeys
                                                                .IDENTITIES_DATA4
                                                                .tr(),
                                                            style: AppFont
                                                                .normal
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18.sp,
                                                              color: Color(
                                                                  0xff061025),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1.sp,
                                    height: 1.sp,
                                    color: AppColors.ashColor,
                                  ),
                                ]);
                              },
                            ),
                            Container(
                              color: AppColors.lightPrimaryStrip,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.sp, vertical: 12.sp),
                                child: InkWell(
                                  onTap: () {
                                    pushNewScreen(
                                      context,
                                      screen: UnlinkDriverLicenseScreen(),
                                      withNavBar:
                                          true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  child: ListTile(
                                    tileColor: AppColors.lightPrimaryStrip,
                                    title: Text(
                                      LocaleKeys.IDENTITIES_DRIVERSLICENSEALERTS
                                          .tr(),
                                      style: AppFont.H3.copyWith(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: CupertinoSwitch(
                                      value: getValueBasedonAuthStatus(context),
                                      onChanged: (value) {
                                        if (value) {
                                          pushNewScreen(
                                            context,
                                            screen: IdentityPage(),
                                            withNavBar:
                                                true, // OPTIONAL VALUE. True by default.
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                        } else {
                                          pushNewScreen(
                                            context,
                                            screen: UnlinkDriverLicenseScreen(),
                                            withNavBar:
                                                true, // OPTIONAL VALUE. True by default.
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
  }

  bool getValueBasedonAuthStatus(BuildContext context) {
    MainProvider providerRef =
        Provider.of<MainProvider>(context, listen: false);
    if (providerRef.identityStatus['status'] == 'AUTHORIZED') {
      return true;
    } else {
      return false;
    }
  }

  String getStatusString(item) {
    String returnString = '';
    if (item == 'F_RPT') {
      returnString = LocaleKeys.IDENTITIES_USERFRAUDALERT.tr();
    } else if (item == 'NF_CLOSE') {
      returnString = LocaleKeys.IDENTITIES_USERNFCLOSE.tr();
    } else if (item == 'F_NORPT') {
      returnString = LocaleKeys.IDENTITIES_USERFNORPT.tr();
    } else if (item == 'To Be Attended') {
      returnString = LocaleKeys.IDENTITIES_USERCHECKEDALERT.tr();
    }
    return returnString;
  }

  Widget getSvgBasedonStatus(item) {
    Widget returnSvg = SvgPicture.asset(
      'assets/svgs/fraud.svg',
      height: 15.h,
      color: AppColors.primary,
    );
    if (item == 'F_RPT') {
      returnSvg = SvgPicture.asset(
        'assets/svgs/fraud.svg',
        color: AppColors.primary,
        height: 15.h,
      );
    } else if (item == 'NF_CLOSE') {
      returnSvg = SvgPicture.asset(
        'assets/svgs/tick.svg',
        height: 15.h,
      );
    } else if (item == 'F_NORPT') {
      returnSvg = SvgPicture.asset(
        'assets/svgs/fraud.svg',
        color: AppColors.warningColor,
        height: 15.h,
      );
    } else if (item == 'To Be Attended') {
      returnSvg = SvgPicture.asset(
        'assets/svgs/fraud.svg',
        height: 15.h,
      );
    }
    return returnSvg;
  }
}
