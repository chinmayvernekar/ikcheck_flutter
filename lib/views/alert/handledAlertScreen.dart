import 'package:easy_localization/easy_localization.dart';
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
import 'package:iKCHECK/views/alert/hadledAlertViewScreen.dart';
import 'package:iKCHECK/widgets/loader.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../Utils/styles.dart';

class HandledAlertScreen extends StatefulWidget {
  const HandledAlertScreen({Key? key}) : super(key: key);

  @override
  State<HandledAlertScreen> createState() => _HandledAlertScreenState();
}

class _HandledAlertScreenState extends State<HandledAlertScreen> {
  bool handleLoadingBool = false;
  bool alertLoadingBool = false;
  int indexforload =0;
  bool handledAlertprocessing = false;
  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> alertHandledList = [
    //   {'title': 'Driver License Checked', 'Date': '08 March 2022, 10:16'},
    //   {'title': 'Driver License Linked', 'Date': '08 March 2022, 12:14'},
    // ];
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
                  LocaleKeys.NAVBARCONTENT_HANDLEDALERTS.tr(),
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
      body: Provider.of<MainProvider>(context).isLoadingAlert
          ? ListView.builder(
              itemCount: 3,
              itemBuilder: ((context, index) {
                return buildSkeletonAnimation();
              }),
            )
          : Consumer<MainProvider>(
              builder: (context, value, child) {
                List alertHandledList =
                    (value.handledAlertEnquiryItems.isEmpty &&
                            value.handledAlertEnquiryItems['items'] == null)
                        ? []
                        : value.handledAlertEnquiryItems['items'] ?? [];

                if (alertHandledList == null) {
                  alertHandledList = [];
                }
                return alertHandledList.isNotEmpty
                    ? RefreshIndicator(
                        displacement: 20.sp,
                        onRefresh: () async {
                          setState(() {
                            handleLoadingBool = true;
                          });
                          String userId = await getString('US_user_id') ?? '';
                          Map object = {

                            "userId": userId,
                            "alertId": 0,
                            "status": null,
                            "read": 'READ',
                            "type": null,
                            "fromDate": null,
                            "toDate": null,
                            "content": null,
                            "source": null,
                            "sort": "Date time",
                            "page": 1


                          };
                          await ApiCallManagement().getIdentityEnquiryDetails(
                            context,
                            object,
                            'handledAlertEnquiryItems',
                          );
                          setState(() {
                            handleLoadingBool = false;
                          });
                        },
                        child: AnimatedContainer(
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 250),
                          padding: handleLoadingBool
                              ? EdgeInsets.only(top: 100.sp)
                              : EdgeInsets.zero,
                          child:
                          ListView.builder(

                            shrinkWrap: true,
                            itemCount: alertHandledList.length,
                            itemBuilder: (context, index) {
                              return
                                AlertTile(alertType:alertHandledList[index]['orgId'] ,
                                  alertLoading: alertLoadingBool && index== indexforload ,
                                title:
                                // LocaleKeys.ALERTS_ORG.tr()=="Organization" ? 
                                alertTranslate(value.handledAlertEnquiryItems[
                                'items'][index]['details']),
                                //  : value.handledAlertEnquiryItems[
                                // 'items'][index]['details'],


                                Datetime: getFormatedDateTime(
                                    alertHandledList[index]['time']),
                                ontap: () async {
                                  if(handledAlertprocessing ==false){
                                    try{
                                      setState((){
                                        alertLoadingBool = true;
                                        indexforload = index;
                                        handledAlertprocessing =true;
                                      });
                                      String userId =
                                          await getString('US_user_id') ?? '';

                                      Map object = {
                                        'alertId': alertHandledList[index]['id'],
                                        'content': null,
                                        'fromDate': null,
                                        'page': 1,
                                        'read': null,
                                        'sort': "Date time",
                                        'source': null,
                                        'status': null,
                                        'toDate': null,
                                        'type': null,
                                        'userId': userId,
                                      };

                                      Map object1 = {
                                        'alertId': alertHandledList[index]['id'],
                                        'alertTypeId': alertHandledList[index]
                                        ['type'],
                                        'userId': userId,
                                      };

                                      await ApiCallManagement().fraudDetailsApiCall(
                                        object1,
                                        context,
                                        'pickedFraudDetails',
                                      );
                                      print("valuee ${value.pickedAlertEnquiryItems}");
                                      await ApiCallManagement().getIdentityEnquiryDetails(
                                        context,
                                        object,
                                        'pickedhandledAlertEnquiryItems',
                                      );
                                      setState((){
                                        handledAlertprocessing = false;
                                      });
                                      pushNewScreen(
                                        context,
                                        screen:HandledAlertView() ,
                                        withNavBar: false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      );
                                      setState((){
                                        alertLoadingBool = false;
                                        handledAlertprocessing =false;
                                      });
                                    }catch(e){
                                      setState(() {
                                        handledAlertprocessing = false;
                                      });
                                    }
                                  }

                                },
                              );
                            },
                          ),
                        ),
                      )
                    : Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.sp,
                        ),
                        width: double.infinity,
                        height: SCREENHEIGHT.sp * 0.55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50.h,
                            ),
                            SvgPicture.asset(
                                'assets/svgs/empty_alert.svg',height:150.sp),
                            SizedBox(
                              height: 50.h,
                            ),
                            Text(
                              LocaleKeys.COMMON_NODATAAVAILABLE.tr(),
                              textAlign: TextAlign.center,
                              style: AppFont.normal.copyWith(
                                fontWeight: FontWeight.w400,

                              ),
                            )
                          ],
                        ),
                      ),
                    );
              },
            ),
    );
  }
}

class AlertTile extends StatelessWidget {
  String title;
  String alertType;
  String Datetime;
  VoidCallback ontap;
  bool alertLoading;
  AlertTile({required this.title, required this.alertType,required this.Datetime, required this.ontap,required this.alertLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: EdgeInsets.only(top: 2),
        child: Container(
          color: AppColors.clearWhite,
          child: ListTile(
            contentPadding:
                EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 4.sp,top: 4.sp),
            dense: true,
            visualDensity: VisualDensity(vertical: 1),
            title: Text(
              title,
                style: AppFont.messageTitle
              //style: AppFont.messageTitle.copyWith(fontSize: 18.sp,fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              Datetime,
                style: AppFont.messageSubtitle
             // style: AppFont.messageSubtitle.copyWith(fontSize: 18.sp,fontWeight: FontWeight.w400),
            ),
            trailing:alertLoading? LoadingAnimationWidget.prograssiveDots(
              color: AppColors.primary,
              size: 40.sp,): Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.clearGrey,
              size: 28,
            ),
            leading: Container(
              height: 50.sp,
              width: 50.sp,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.msgIconBorder,
                  width: 2.sp,
                ),
                borderRadius: BorderRadius.circular(8.sp),
              ),
              // child: ClipRRect(
              //   borderRadius: BorderRadius.circular(8.sp),
              //   child: SvgPicture.asset(
              //   'assets/svgs/alertprefix.svg',
              //   )),
              // ),
              child:alertType=="SS"?
              Padding(
                padding:  EdgeInsets.all(4.5.sp),
                child: SvgPicture.asset(
                  'assets/svgs/Vector.svg',
                )
              ):Padding(
                  padding: EdgeInsets.all(4.5.sp),
                  child: SvgPicture.asset(
                    'assets/svgs/alertprefix.svg',
                  ))
              ,
            ),
          ),
        ),
      ),
    );
  }
}
