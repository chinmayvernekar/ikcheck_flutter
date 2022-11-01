import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/navigation.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';

import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/messages/messageView.dart';

import 'package:iKCHECK/widgets/navbar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../widgets/loader.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  SlidableController slidableController = SlidableController();
  bool msgUILoading = false;

  Widget _buildItem(item, animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: MessageTile(
        title: item['Heading'].length > 20
            ? item['Heading'].substring(0, 20) + '...'
            : item['Heading'],
        // subTitle: item['Message'],
        subTitle: getParseString(item['Message']),
        time: getDateOrTime(item['PostedTime']),
        readStatus: item['readStatus'] == 0,
        method: () {},
      ),
    );
  }

  @override
  void initState(){
    // getData();
    super.initState();
  }

  Future getData()async{
    Provider.of<MainProvider>(context,listen: false).setLoaderMsgStatus(true);
    await ApiCallManagement()
        .getMessagesUserNewsApi(context, 1);
    Provider.of<MainProvider>(context,listen: false).setLoaderMsgStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: AppBar(
            automaticallyImplyLeading: false,
            // leading:InkWell(
            //   onTap: () async {
            //     Navigator.of(context).pop();
            //
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.all(10.sp),
            //     child: SvgPicture.asset(
            //       'assets/svgs/arrowLeft.svg',
            //     ),
            //   ),
            //
            // ),
            toolbarHeight: 100.h,
            backgroundColor: AppColors.clearWhite,
            elevation: 0,
            title: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.DASHBOARD_MESSAGES.tr(),
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
        body:Provider.of<MainProvider>(context,listen: false).isLoadingMsg
        ? ListView.builder(
            itemCount: 3,
            itemBuilder: ((context, index) {
              return buildSkeletonAnimation();
            }),
          )
        : Container(
            height: SCREENHEIGHT.h * 0.8,
            child: Consumer<MainProvider>(
              builder: (context, value, child) {
                List items = value.userNewsMessages.isEmpty
                    ? []
                    : value.userNewsMessages['items'];
                if (value.userNewsMessages['items'] == null) {
                  items = [];
                }
                return RefreshIndicator(
                  displacement: 20.sp,
                  onRefresh: () async {
                    // Provider.of<MainProvider>(context, listen: false)
                    //     .setUserNewsMessages({});
                    setState(() {
                      msgUILoading = true;
                    });
                    await ApiCallManagement()
                        .getMessagesUserNewsApi(context, 1);
                    setState(() {
                      msgUILoading = false;
                    });
                    // pushNewScreen(
                    //   context,
                    //   screen:MessageScreen() ,
                    //   withNavBar: true, // OPTIONAL VALUE. True by default.
                    //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    // );
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                        MessageScreen()));
                    //     transitionDuration: Duration.zero,
                    //     reverseTransitionDuration: Duration.zero,
                    //   ),
                    // );
                  },
                  child: items.isEmpty
                      ? Container(
                          height: SCREENHEIGHT.h * 0.8,
                          width: SCREENWIDTH.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svgs/empty_alert.svg'),
                              SizedBox(
                                height: 30.h,
                              ),
                              Text(
                                '${LocaleKeys.MESSAGES_NOMESSAGE.tr()}!',
                                textAlign: TextAlign.center,
                                style: AppFont.normal.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        )
                      : AnimatedContainer(
                          curve: Curves.ease,
                          // height: height,
                          duration: Duration(milliseconds: 250),
                          padding: msgUILoading
                              ? EdgeInsets.only(top: 100.sp)
                              : EdgeInsets.zero,
                          child: AnimatedList(
                            key: _listKey,
                            initialItemCount: items.length,
                            itemBuilder: (context, index, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: Slidable(
                                  controller: slidableController,
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  secondaryActions: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                        slidableController.activeState!.close();
                                        Map localDashBoardDetailsUpdate =
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .dashboardDetails;

                                        localDashBoardDetailsUpdate[
                                                'unReadNewsCount'] =
                                            localDashBoardDetailsUpdate[
                                                    'unReadNewsCount'] -
                                                1;
                                        Provider.of<MainProvider>(context,
                                                listen: false)
                                            .setDashboardDetails(
                                                localDashBoardDetailsUpdate);
                                        ApiCallManagement()
                                            .updateMessageAsReadUnreadDelete(
                                          items[index]['Heading'],
                                          items[index]['NewsID'],
                                          'DELETE',
                                          context,
                                        );
                                        var removedItem = items.removeAt(index);
                                        AnimatedListRemovedItemBuilder builder =
                                            (context, animation) {
                                          // A method to build the Card widget.
                                          return _buildItem(
                                              removedItem, animation);
                                        };
                                        _listKey.currentState!
                                            .removeItem(index, builder);
                                        // setState(() {
                                        //   items.removeAt(index);
                                        // });
                                      },
                                      child: Container(
                                        width: SCREENWIDTH.w * 0.25,
                                        height: SCREENHEIGHT.h * 0.1,
                                        color: AppColors.lgRed,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 35.sp,
                                              width: 35.sp,
                                              child: SvgPicture.asset(
                                                'assets/svgs/deleteMsg.svg',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              LocaleKeys.MESSAGES_DELETE.tr(),
                                              style: AppFont.s1.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.sp,
                                                color: AppColors.dkRed,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  actions: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                        slidableController.activeState!.close();

                                        Map localDashBoardDetailsUpdate =
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .dashboardDetails;
                                        localDashBoardDetailsUpdate[
                                                'unReadNewsCount'] =
                                            items[index]['readStatus'] == 0
                                                ? localDashBoardDetailsUpdate[
                                                        'unReadNewsCount'] -
                                                    1
                                                : localDashBoardDetailsUpdate[
                                                        'unReadNewsCount'] +
                                                    1;
                                        Provider.of<MainProvider>(context,
                                                listen: false)
                                            .setDashboardDetails(
                                                localDashBoardDetailsUpdate);

                                        ApiCallManagement()
                                            .updateMessageAsReadUnreadDelete(
                                                items[index]['Heading'],
                                                items[index]['NewsID'],
                                                items[index]['readStatus'] == 0
                                                    ? 'READ'
                                                    : 'UNREAD',
                                                context);
                                        setState(() {
                                          items[index]['readStatus'] =
                                              items[index]['readStatus'] == 0
                                                  ? 1
                                                  : 0;
                                        });
                                      },
                                      child: Container(
                                        width: SCREENWIDTH.w * 0.25,
                                        height: SCREENHEIGHT.h * 0.1,
                                        color: AppColors.lgBlue,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 35.sp,
                                              width: 35.sp,
                                              child: items[index]
                                                          ['readStatus'] ==
                                                      1
                                                  ? SvgPicture.asset(
                                                      'assets/svgs/mailUnread.svg',
                                                    )
                                                  : SvgPicture.asset(
                                                      'assets/svgs/mailRead.svg',
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              items[index]['readStatus'] == 1
                                                  ? LocaleKeys.MESSAGES_UNREAD
                                                      .tr()
                                                  : LocaleKeys.MESSAGES_READ
                                                      .tr(),
                                              style: AppFont.s1.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.sp,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  child: MessageTile(
                                    // title: items[index]['Heading'].length > 20
                                    //     ? items[index]['Heading']
                                    //             .substring(0, 20) +
                                    //         '...'
                                    //     : items[index]['Heading'],
                                    title: items[index]['Heading'],
                                    // subTitle: items[index]['Message'],
                                    subTitle:
                                        getParseString(items[index]['Message']),
                                    time: getDateOrTime(
                                        items[index]['PostedTime']),
                                    readStatus: items[index]['readStatus'] == 0,
                                    method: () {
                                      Map localDashBoardDetailsUpdate =
                                          Provider.of<MainProvider>(context,
                                                  listen: false)
                                              .dashboardDetails;
                                      print(localDashBoardDetailsUpdate['unReadNewsCount']);
                                      if (items[index]['readStatus'] == 0) {
                                        localDashBoardDetailsUpdate[
                                                'unReadNewsCount'] =
                                            localDashBoardDetailsUpdate[
                                                    'unReadNewsCount'] -
                                                1;
                                      }
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .setDashboardDetails(
                                              localDashBoardDetailsUpdate);
                                      // Navigator.of(context).push(
                                      //   SliderTransition(
                                      //     NavbarScreen(
                                      //       selectedPageIndex: 17,
                                      //       msgIndex: index,
                                      //     ),
                                      //   ),
                                      // );
                                      pushNewScreen(
                                        context,
                                        screen:MessageView(index) ,
                                        withNavBar: true, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      );

                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  // child: ListView.builder(
                  //   itemCount: items.length,
                  //   itemBuilder: (context, index) {
                  //   },
                  // ),
                );
              },
            ),
          ));
  }

  getParseString(String item) {
    List x = [];
    x = item.split('</p>');
    RegExp regExp = RegExp(
      r"<[^>]*>",
      caseSensitive: true,
      multiLine: false,
    );
    x[0] = x[0].replaceAll(regExp, '') + '...';
    return x[0];
    // x[0] = x[0].replaceAll('<p>', '') + '...';
    // print(x[0]);
    // return x[0];
  }
}

class MessageTile extends StatelessWidget {
  String title = '';
  String subTitle = '';
  String time = '';
  bool readStatus = false;
  Function() method;
  MessageTile({
    required this.title,
    required this.subTitle,
    required this.time,
    required this.method,
    required this.readStatus,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: method,
      child: Container(
        alignment: Alignment.center,
        width: SCREENWIDTH.w,
        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 0.5.sp,
              color: AppColors.ashColor,
            ),
          ),
        ),
        height: SCREENHEIGHT.h * 0.1,
        // height: 48
        child: Container(
          width: SCREENWIDTH.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.msgIconBorder,
                    width: 2.sp,
                  ),
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.sp),
                  child: Image.asset(
                    'assets/images/logoHD.png',
                    height: 50.h,
                  ),
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              Container(
                width: SCREENWIDTH.w * 0.78,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              // maxLines: 1,
                              style: AppFont.H3.copyWith(
                                  fontSize: 18.sp,
                                  fontWeight:
                                  readStatus ? FontWeight.w600 : FontWeight.w500,

                                  color: readStatus
                                      ? AppColors.clearBlack
                                      : AppColors.placeHolderGrey),
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: AppFont.s1.copyWith(
                            fontSize: 16.sp,
                            color: readStatus
                                ? AppColors.clearBlack
                                : AppColors.placeHolderGrey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.5.sp),
                      width: SCREENWIDTH.w * 0.75,
                      child: Text(
                        subTitle,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16.sp,
                            fontWeight:
                                readStatus ? FontWeight.w500 : FontWeight.w400,
                            color: readStatus
                                ? AppColors.clearBlack
                                : AppColors.placeHolderGrey),
                      ),
                      // child: Html(
                      //   data: subTitle,
                      //   style: {
                      //     '#': Style(
                      //       textOverflow: TextOverflow.ellipsis,
                      //       maxLines: 1,
                      //       margin: EdgeInsets.zero,
                      //       padding: EdgeInsets.zero,
                      //     ),
                      //   },
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // child: ListTile(
        //   // contentPadding:r
        //   //     EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.0),
        //   title: Text(
        //     title,
        //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //   ),
        //   subtitle: SizedBox(
        //     height: 25,
        //     // width: SCREENWIDTH.w * 0.6,
        //     // height: SCREENHEIGHT.h * 0.07, //
        //     child: Html(
        //       style: {
        //         'p': Style(
        //           height: 1,
        //           textAlign: TextAlign.left,
        //           textOverflow: TextOverflow.ellipsis,
        //         )
        //       },
        //       data: subTitle,
        //     ),
        //   ),

        //   trailing: Text(time),
        //   leading: Container(
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(6),
        //         border: Border.all(width: 1, color: Colors.grey)),
        //     child: Padding(
        //         padding: EdgeInsets.all(8.0),
        //         child: Image.asset(
        //           'assets/images/iklogo.png',
        //           scale: 2,
        //         )),
        //   ),
        // ),
      ),
    );
  }
}
