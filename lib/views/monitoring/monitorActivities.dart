import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/monitoring/alert.dart';
import 'package:iKCHECK/views/monitoring/breachesFound.dart';
import 'package:iKCHECK/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/styles.dart';
import '../../widgets/navbar.dart';



class MonitoringScreen2 extends StatefulWidget {
  bool greenStrip = false;
  bool navigater = false;
  MonitoringScreen2({Key? key, this.greenStrip=false, this.navigater = true}) : super(key: key);

  @override
  State<MonitoringScreen2> createState() => _MonitoringScreen2State();
}

class _MonitoringScreen2State extends State<MonitoringScreen2> {
  bool over = true;
  bool greenstrip =true;
  bool isVisibleGreenMonitoring = false;
  int dropIndex = -1;
    bool navigateronce = true;


  @override
  initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getActivities();
      try{
        setState((){
          showGreenStrip = widget.greenStrip;
          navigateronce = widget.navigater;
        });
      }catch(e){}

    });
  super.initState();
  }



  getActivities()async{

    String userId =
    await getString('US_user_id') ?? '';
    Map object = {
    'alertId': 0,
    'content': null,
    'fromDate': null,
    'page': 1,
    'read': null,
    'sort': "Date time",
    'source': "US",
    'status': null,
    'toDate': null,
    'type': null,
    'userId': userId,
    };
    await ApiCallManagement().getIdentityEnquiryDetails(globelContext!, object, "enquiryItemsOnMonitoring");
  //  print("MyResp ${Provider.of<MainProvider>(context, listen: false).enquiryItemsOnMonitoring}");

  }


  bool showGreenStrip = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar:PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: AppBar(
            automaticallyImplyLeading: false,
            leading: navigateronce ?InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: SvgPicture.asset(
                  'assets/svgs/arrowLeft.svg',
                ),
              ),
             ) :InkWell(
              onTap: () async {
                Navigator.pop(context);
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
                    LocaleKeys.MONITORING_DATAMONITOR.tr(),
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
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: showGreenStrip,
                // visible: Provider.of<MainProvider>(context,listen: false).datalet==false && isVisibleGreenMonitoring,
                child: GreenWid(context, Provider.of<MainProvider>(context,listen: false).datalet ? LocaleKeys.MONITORING_DATALBREACHALERTSENABLED.tr() : LocaleKeys.MONITORING_DATALBREACHALERTSDISABLED.tr()),
              ),
              // InkWell(onTap: (){
              //   // Navigator.push(context, MaterialPageRoute(builder: (context) => alert(),));
              //    Navigator.push(context, MaterialPageRoute(builder: (context) => BreachesFound(),));
              // },
              //   child: GreenWid(context),
              //   // Container(
              //   //   width: MediaQuery.of(context).size.width,
              //   //   color: AppColors.successStrip,
              //   //   padding: EdgeInsets.symmetric(vertical: 15,horizontal: 18),
              //   //   child: Row(
              //   //     children: [
              //   //       SvgPicture.asset(
              //   //         'assets/svgs/tick.svg',
              //   //         height: 22,
              //   //       ),
              //   //       SizedBox(width: 15,),
              //   //       Text("Datalek alerts ultgeschakeld",style:TextStyle(color:AppColors.successStripForeground,fontWeight: FontWeight.w700))
              //   //     ],
              //   //   ),
              //   // ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 46.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.MONITORING_DATAMONITOR.tr(),
                        style: AppFont.H1.copyWith(
                            fontSize: 29.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.clearBlack),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 8,),
                    SvgPicture.asset('assets/svgs/Vector.svg',height: 70.sp),
                   // Image.asset("assets/images/Vector.png",height: 60.sp),
                    const SizedBox(width: 8,)
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
                                child: Text(emailInfoMonitoring,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22.sp)),
                              ),
                              subtitle: lastScanId==null ?  Padding(
                                padding: const EdgeInsets.only(bottom: 8.0,left: 11),
                                child: Text(LocaleKeys.MONITORING_SCANISSTARTED.tr()),
                              ) : Padding(
                                padding: const EdgeInsets.only(bottom: 8.0,left: 11),
                                child: Text("${LocaleKeys.MONITORING_LASTSCAN.tr()} ${dateTranslate(getFormatedDateOnlyTrimmed(DateTime.fromMillisecondsSinceEpoch(lastScanId!).toString(),
                                //  'dmy', true
                                 )
                                )}",style:TextStyle(fontSize: 15.sp)),

                              ),
                            ),
                            Divider(
                              thickness: 1.sp,
                              height: 0.6.sp,
                              color: AppColors.ashColor,
                            ),
                            ListView.builder(
                              key: Key(
                                  'builder ${dropIndex.toString()}'), //attention

                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
                                    data:ThemeData().copyWith(
                                        dividerColor: AppColors.disableColor),
                                    child: ExpansionTile(
                                      onExpansionChanged: ((newState) {
                                        print("newState $newState");
                                        if (newState) {
                                          setState(() {
                                            dropIndex = index;
                                          });
                                        } else {
                                          setState(() {
                                            dropIndex = -1;
                                          });
                                        }
                                      }),

                                      collapsedBackgroundColor: Colors.white,
                                      backgroundColor: AppColors.primary,
                                      collapsedTextColor: Colors.black,
                                      iconColor: Colors.black ,
                                      textColor: Colors.white,
                                      trailing:  dropIndex == index?  SvgPicture.asset(
                                          'assets/svgs/arrowUp.svg',
                                          color: Colors.white
                                        // color:  Colors.white,
                                      )
                                          : SvgPicture.asset(
                                        'assets/svgs/arrowDown.svg',

                                      ),
                                      initiallyExpanded:
                                      index == dropIndex,
                                      tilePadding: EdgeInsets.symmetric(
                                          horizontal: 30.sp, vertical: 10.sp),
                                      // childrenPadding: EdgeInsets.only(),
                                      // backgroundColor: AppColors.primary,
                                      title: Text(
                                          index == 0
                                              ? LocaleKeys.IDENTITIES_ACTIVITIES
                                              .tr()
                                              : LocaleKeys.MONITORING_OVER.tr(),

                                          style: AppFont.H3.copyWith(
                                            fontWeight: FontWeight.w500,
                                          )),

                                      children: <Widget>[
                                        index == 0
                                            ? Consumer<MainProvider>(
                                          builder:
                                              (context, value, child) {
                                            List items =
                                                value.enquiryItemsOnMonitoring[
                                                'items'] ??
                                                    [];

                                            return items.isNotEmpty
                                                ? Container(
                                              // height:
                                              // SCREENHEIGHT.h *
                                              //     0.15 *
                                              //     items.length,
                                              child:
                                              ListView.builder(
                                                shrinkWrap:true ,
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
                                                  //       height: SCREENHEIGHT
                                                  //           .h *
                                                  // 0.160,
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
                                                                json.decode(items[index]["reference"])["breaches"].length==0 ? alertTranslate(items[index]['details']) : alertTranslate(items[index]['details']) +" "+ "(" +json.decode(items[index]["reference"])["breaches"].length.toString()+")",
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
                                                                  (json.decode(items[index]["reference"])["breaches"].length==0)?SvgPicture.asset(
                                                    'assets/svgs/tick.svg',
                                                    height: 15.h,
                                                  ):SvgPicture.asset(
                                                    'assets/svgs/error.svg',
                                                  //  color: AppColors.warningColor,
                                                    height: 15.h,
                                                  ),

                                                                 // getSvgBasedonStatus(items[index]['status']),
                                                                  SizedBox(
                                                                    width: 5.w,
                                                                  ),
                                                                  Text(
                                                                    !(json.decode(items[index]["reference"])["breaches"].length==0)?LocaleKeys.MONITORING_PASSWORDCRACKED.tr() :LocaleKeys.MONITORING_NOTHINGFOUND1.tr(),
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
                                                      (items.length -1) != index ?   Divider(
                                                        thickness:
                                                        1.sp,
                                                        height:
                                                        1.sp,
                                                        color: AppColors
                                                            .ashColor,
                                                      ):Container()
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
                                              vertical: 30.sp),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                LocaleKeys.MONITORING_OVERDATA.tr() ,softWrap: true,

                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize: 18.sp,
                                                  color:
                                                  Color(0xff061025),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20.h,
                                              ),

                                              InkWell(
                                                onTap: () async {

                                                },
                                                child: Container(
                                                  constraints: BoxConstraints(minHeight: 55),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: AppColors.clearWhite,
                                                    border: Border.all(color: AppColors.primary,width: 1.5)
                                                  ),
                                                  child: InkWell(
                                                    onTap: ()  async{
                                                      //String link = "www.google.com";
                                                      String url="";
                                                      url = LocaleKeys.MONITORING_OVERLINK.tr();

                                                      if (await canLaunch(url))
                                                        await launch(url,forceWebView: false,
                                                            forceSafariVC: false);
                                                      else

                                                        throw "Could not launch $url";
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 15.0),
                                                          child: Icon(Icons.launch,color: Colors.white.withOpacity(0.0)),
                                                        ),
                                                        Text(
                                                         LocaleKeys.MONITORING_NAARSS.tr(),
                                                          style:
                                                          AppFont.identityButtonFont.copyWith(
                                                            color: AppColors.primary,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 15.0),
                                                          child: Icon(Icons.launch,color: AppColors.primary),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
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
                                      value: Provider.of<MainProvider>(context,listen: true).datalet,
                                      onChanged: (value) async{
                                        bool dataLetTemp = Provider.of<MainProvider>(context,listen: false).datalet;
                                        //  if (value) {
                                       //    setState((){
                                       //      datalet= !datalet;
                                     //      print(datalet);
                                       //      _driversLicenseAlertValue = !_driversLicenseAlertValue;
                                       //    });
                                         if(!(dataLetTemp)) {
                                           var resp = await ApiCallManagement().enableSubscription(context);
                                           print("resp if $resp");
                                           if(resp["success"]=="true"){
                                             setState((){
                                               isVisibleGreenMonitoring = true;
                                             });
                                             Provider.of<MainProvider>(context,listen: false).setdataletvalue(!dataLetTemp);
                                             final SharedPreferences prefs = await SharedPreferences.getInstance();
                                             prefs.setBool("alertsOnOf", !dataLetTemp);
                                             prefs.setBool("isFirstTime", false);
                                           }
                                         }else{
                                           var resp = await ApiCallManagement().disableSubscription(context);
                                           print("resp else $resp");
                                           if(resp["success"]=="true"){
                                             setState((){
                                               isVisibleGreenMonitoring = true;
                                             });
                                             Provider.of<MainProvider>(context,listen: false).setdataletvalue(!dataLetTemp);
                                             final SharedPreferences prefs = await SharedPreferences.getInstance();
                                             prefs.setBool("alertsOnOf", !dataLetTemp);
                                             prefs.setBool("isFirstTime", false);
                                           }
                                         }
                                        setState((){
                                          showGreenStrip = true;
                                        });
                                       //
                                       //  } else {
                                         // ApiCallManagement().disableSubscription(context);

                                          // Navigator.push(
                                          //   context,
                                          //   SliderTransition(
                                          //     NavbarScreen(
                                          //       selectedPageIndex: 30,
                                          //     ),
                                          //   ),
                                          // );
                                       // }
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
  Widget GreenWid(BuildContext context, String str) {
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
                  str,
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
    }else if(item == "NF_INFO"){
      returnString = LocaleKeys.IDENTITIES_USERFRAUDALERT.tr();
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
    } else if (item == 'NF_CLOSE' || item =='NF_INFO') {
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

  // String Dlnumber = '*******4075';

