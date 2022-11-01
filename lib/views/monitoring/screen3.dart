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
import 'package:iKCHECK/views/monitoring/breachesFound.dart';
import 'package:iKCHECK/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Utils/styles.dart';
import '../../widgets/navbar.dart';


class MonitoringScreen3 extends StatefulWidget {
  const MonitoringScreen3({Key? key}) : super(key: key);

  @override
  State<MonitoringScreen3> createState() => _MonitoringScreen3State();
}

class _MonitoringScreen3State extends State<MonitoringScreen3> {

  bool _driversLicenseAlertValue = false;
  bool greenstrip =true;
  List<List<String>> _data = [
    ["As kuf fu c gt t t thhnt ", "hlhcrhckuer crc reuv reu rvb rv","h kjghkg uyg yu g k g ggy k", "bkuf t k  k "],
    ["hkuy gkufr  gtktg tv","hk  k k g  g h jhg"],
  ];


  @override
  Widget build(BuildContext context) {
    int dropIndex = -1;
    return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   color: AppColors.successStrip,
              //   padding: EdgeInsets.symmetric(vertical: 15,horizontal: 18),
              //   child: Row(
              //     children: [
              //       SvgPicture.asset(
              //         'assets/svgs/tick.svg',
              //         height: 22,
              //       ),
              //       SizedBox(width: 15,),
              //       Text(   LocaleKeys.MONITORING_DATALBREACHALERTSDISABLED.tr(),style:TextStyle(color:AppColors.successStripForeground,fontWeight: FontWeight.w700))
              //     ],
              //   ),
              // ),
              InkWell(onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => alert(),));
                Navigator.push(context, MaterialPageRoute(builder: (context) => BreachesFound(),));
              },
                child: GreenWid(context),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   color: AppColors.successStrip,
                //   padding: EdgeInsets.symmetric(vertical: 15,horizontal: 18),
                //   child: Row(
                //     children: [
                //       SvgPicture.asset(
                //         'assets/svgs/tick.svg',
                //         height: 22,
                //       ),
                //       SizedBox(width: 15,),
                //       Text("Datalek alerts ultgeschakeld",style:TextStyle(color:AppColors.successStripForeground,fontWeight: FontWeight.w700))
                //     ],
                //   ),
                // ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 46.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.MONITORING_DATAMONITOR.tr(),
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

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 11),
                                child: Text("jaron@upfront-security.com",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0,left: 11),
                                child: Text("Last scan: 14 April 2022"),
                              ),
                            ),
                            Divider(
                              thickness: 1.sp,
                              height: 1.sp,
                              color: AppColors.ashColor,
                            ),
                            ListView.builder(
                              key: Key(
                                  'builder ${dropIndex.toString()}'), //attention

                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Column(children: <Widget>[
                                  Divider(
                                    thickness: 1.sp,
                                    height: 0,
                                    color:
                                    AppColors.clearBlack.withOpacity(0.1),
                                  ),
                                  Theme(
                                    data: ThemeData().copyWith(
                                        dividerColor: AppColors.primary),
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

                                      collapsedBackgroundColor: Colors.white,
                                      backgroundColor: AppColors.primary,

                                      collapsedTextColor: Colors.black,
                                      textColor: Colors.white,
                                      trailing: dropIndex == index
                                          ? SvgPicture.asset(
                                          'assets/svgs/arrowUp.svg')
                                          : SvgPicture.asset(
                                        'assets/svgs/arrowDown.svg',
                                        // color: AppColors.placeHolderGrey,
                                      ),
                                      initiallyExpanded:
                                      index == dropIndex, //atten
                                      tilePadding: EdgeInsets.symmetric(
                                          horizontal: 30.sp, vertical: 10.sp),
                                      // childrenPadding: EdgeInsets.only(),
                                      // backgroundColor: AppColors.primary,
                                      title: Text(
                                          index == 0
                                              ? LocaleKeys.MONITORING_ACTIVITIES
                                              .tr()
                                              : LocaleKeys.MONITORING_OVER.tr(),
                                          style: AppFont.H3.copyWith(
                                            fontWeight: FontWeight.w500,
                                          )),

                                      children: <Widget>[
                                        Container(
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
                                              for(int i=0; i<_data[index].length; i++)
                                                Padding(
                                                  padding: EdgeInsets.only(top: 10.h),
                                                  child: Text(_data[index][i]),
                                                )
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
                              height: 1.sp,
                              color: AppColors.ashColor,
                            ),
                            Container(
                              color: AppColors.lightPrimaryStrip,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.sp, vertical: 12.sp),
                                child: InkWell(
                                  onTap: () {

                                  },
                                  child: ListTile(
                                    tileColor: AppColors.lightPrimaryStrip,
                                    title: Text(
                                      LocaleKeys.MONITORING_DATALBREACHALERTS.tr(),
                                      style: AppFont.H3.copyWith(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: CupertinoSwitch(
                                      value: _driversLicenseAlertValue,
                                      onChanged: (value) {
                                        if (value) {
                                          setState((){
                                            _driversLicenseAlertValue = !_driversLicenseAlertValue;
                                          });

                                        } else {

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
  Widget GreenWid(BuildContext context) {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: greenstrip,
      child: Container(
        height: 40,
        width: double.infinity,
        color: AppColors.successStrip,

        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset("assets/svgs/tick.svg"),
            ),
            SizedBox(
              width: 10.w,
            ),
            Flexible(
              child: Text(
                  LocaleKeys.MONITORING_DATALBREACHALERTSDISABLED.tr(),
                  style: AppFont.normal.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.successStripForeground)),
            )
          ],
        ),
      ),
    );
  }
}

// String Dlnumber = '*******4075';

