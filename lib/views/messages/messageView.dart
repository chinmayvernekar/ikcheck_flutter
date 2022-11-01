import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/views/messages/my_player.dart';
import 'package:iKCHECK/widgets/FlickPortraitControlsCustom.dart';
import 'package:iKCHECK/widgets/imageViewer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MessageView extends StatefulWidget {
  int? contentIndex;
  Map? content;
  MessageView(this.contentIndex, {Key? key}) : super(key: key);

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late FlickManager flickManager;
  late String link;
  List<String> linkList = [];
  late String imgOrVideo = '';
  List<Map<String, String>> _linksOfData = [];
  CarouselController carouselClr = CarouselController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    MainProvider provRef = Provider.of<MainProvider>(context, listen: false);
    widget.content = provRef.userNewsMessages['items'][widget.contentIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (provRef.userNewsMessages['items'][widget.contentIndex]
              ['readStatus'] ==
          0) {
        await ApiCallManagement().updateMessageAsReadUnreadDelete(
          provRef.userNewsMessages['items'][widget.contentIndex]['Heading'],
          provRef.userNewsMessages['items'][widget.contentIndex]['NewsID'],
          'READ',
          context,
        );
        Map x = provRef.userNewsMessages;
        x['items'][widget.contentIndex]['readStatus'] = 1;
        provRef.setUserNewsMessages(x);
      }
      // setState(() {
      //   items[index]['readStatus'] = items[index]['readStatus'] == 0 ? 1 : 0;
      // });
    });
    getUrlLinkImgorVideo(widget.content!['ImageAndVideoPath']);
    if (imgOrVideo == 'video') {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
          link,
          // 'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
        ),
      );
    }
  }

  @override
  void dispose() {
    // flickManager.dispose();
    // flickManager.flickVideoManager!.dispose();
    // chewieController!.pause();
    //  chewieController!.dispose();
    // videoPlayerController.dispose();

    imgOrVideo = '';
    super.dispose();
  }

  int _currentPage = 0;

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
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 20.sp),
        height: SCREENHEIGHT.h * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (widget.content != null)
                Container(
                  alignment: Alignment.center,
                  width: SCREENWIDTH.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        width: 1,
                        color: AppColors.ashColor.withOpacity(0.5),
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
                          width: 5.w,
                        ),
                        Container(
                          width: SCREENWIDTH.w * 0.75,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: SCREENWIDTH.w * 0.5,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.sp),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.content?['MessageType'],
                                      style: AppFont.H3.copyWith(
                                          fontSize: 18.sp,
                                          color: AppColors.clearBlack),
                                    ),
                                  ),
                                  Text(
                                    getDateOrTime(
                                        widget.content?['PostedTime']),
                                    style: AppFont.s1.copyWith(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (imgOrVideo.isNotEmpty)
                Container(
                  width: SCREENWIDTH.w,
                  color: AppColors.clearWhite,
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.sp),
                        child: Text(
                          widget.content?['Heading'],
                          style: AppFont.H3.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.clearBlack,
                            // fontWeight: FontWeight.w900
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              _linksOfData.isNotEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 270,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (i) {
                          setState(() {
                            _currentPage = i;
                          });
                          if (chewieController!.isPlaying) {
                            chewieController!.pause();
                          }

                          print(_currentPage);
                          Provider.of<MainProvider>(context, listen: false)
                              .setplayVideo(1);
                        },
                        itemCount: _linksOfData.length,
                        itemBuilder: (context, index) {
                          // flickManager = FlickManager(
                          //   videoPlayerController: VideoPlayerController.network(
                          //     _linksOfData[index]["link"]!,
                          //     // 'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
                          //   ),
                          // );
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 270,
                            child: _linksOfData[index]['type'] == 'Video'
                                ? ChewieListItem(
                                    videoPlayerController:
                                        VideoPlayerController.network(
                                      _linksOfData[index]["link"]!,
                                    ),
                                    looping: true,
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ImageViewer(
                                                link: _linksOfData[index]
                                                    ["link"]!);
                                          },
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      _linksOfData[index]["link"]!,
                                      width: SCREENWIDTH.w,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container();
                                      },
                                    ),
                                  ),
                          );
                        },
                      ),
                    )
                  : SizedBox(height: 1),
              // if (imgOrVideo == 'video')
              //   VisibilityDetector(
              //     key: ObjectKey(flickManager),
              //     onVisibilityChanged: (visibility) {
              //       if (visibility.visibleFraction == 0 && this.mounted) {
              //         flickManager.flickControlManager?.autoPause();
              //       } else if (visibility.visibleFraction == 1) {
              //         flickManager.flickControlManager?.autoResume();
              //       }
              //     },
              //     child: FlickVideoPlayer(
              //       flickManager: flickManager,
              //       preferredDeviceOrientation: const [
              //         DeviceOrientation.portraitUp,
              //       ],
              //       flickVideoWithControls: const FlickVideoWithControls(
              //         controls: FlickPortraitControlsCustom(),
              //       ),
              //       // flickVideoWithControlsFullscreen: const FlickVideoWithControls(
              //       //   controls: FlickLandscapeControls(),
              //       // ),
              //     ),
              //   ),
              // if (imgOrVideo == 'img')
              //   linkList.length == 1
              //       ? InkWell(
              //           onTap: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) {
              //                   return ImageViewer(link: link);
              //                 },
              //               ),
              //             );
              //           },
              //           child: Image.network(
              //             link,
              //             width: SCREENWIDTH.w,
              //             fit: BoxFit.cover,
              //             errorBuilder: (context, error, stackTrace) {
              //               return Container();
              //             },
              //           ),
              //         )
              //       : SizedBox(
              //           height: SCREENHEIGHT.h * 0.35,
              //           child: Column(
              //             children: [
              //               CarouselSlider(
              //                 carouselController: carouselClr,
              //                 options: CarouselOptions(
              //                   viewportFraction: 1.0,
              //                   height: SCREENHEIGHT.h * 0.3,
              //                   initialPage: 0,
              //                   enableInfiniteScroll: false,
              //                   scrollDirection: Axis.horizontal,
              //                   onPageChanged: (index, reason) {
              //                     setState(() {
              //                       _current = index;
              //                     });
              //                   },
              //                 ),
              //                 items: linkList.map((i) {
              //                   return Builder(
              //                     builder: (BuildContext context) {
              //                       return InkWell(
              //                         onTap: () {
              //                           Navigator.push(
              //                             context,
              //                             MaterialPageRoute(
              //                               builder: (context) {
              //                                 return ImageViewer(link: i);
              //                               },
              //                             ),
              //                           );
              //                         },
              //                         child: Container(
              //                           width: MediaQuery.of(context).size.width,
              //                           child: Image.network(
              //                             i,
              //                             fit: BoxFit.cover,
              //                             errorBuilder:
              //                                 (context, error, stackTrace) {
              //                               print('err $error');
              //                               return Container();
              //                             },
              //                           ),
              //                         ),
              //                       );
              //                     },
              //                   );
              //                 }).toList(),
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: linkList.asMap().entries.map((entry) {
              //                   return GestureDetector(
              //                     onTap: () =>
              //                         carouselClr.animateToPage(entry.key),
              //                     child: Container(
              //                       width: 10.w,
              //                       height: 12.h,
              //                       margin: EdgeInsets.symmetric(
              //                           vertical: 15.sp, horizontal: 5.sp),
              //                       decoration: BoxDecoration(
              //                         shape: BoxShape.circle,
              //                         color: (Theme.of(context).brightness ==
              //                                     Brightness.dark
              //                                 ? Colors.white
              //                                 : Colors.black)
              //                             .withOpacity(
              //                           _current == entry.key ? 0.9 : 0.4,
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 }).toList(),
              //               ),
              //             ],
              //           ),
              //         ),

              Container(
                color: AppColors.clearWhite,
                padding: EdgeInsets.all(20.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _linksOfData.length > 1
                        ? Center(
                            child: DotsIndicator(
                              dotsCount: _linksOfData.length,
                              position: _currentPage.toDouble(),
                              decorator: DotsDecorator(
                                  activeColor: Colors.blue,
                                  color: Colors.blue.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(360),
                                      side: const BorderSide(
                                          width: 1, color: Colors.white))),
                            ),
                          )
                        : SizedBox(height: 1),
                    if (imgOrVideo.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 8.sp),
                        child: Text(
                          widget.content?['Heading'],
                          style: AppFont.H3.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.clearBlack,
                          ),
                        ),
                      ),
                    Html(
                      onLinkTap: (url, context, attributes, element) async {
                        // final Uri params = Uri(
                        //   path: url,
                        // );
                        // await launchUrl(
                        //   params,
                        //   mode: LaunchMode.platformDefault,
                        // );
                        await launch(url.toString(),
                            forceWebView: false, forceSafariVC: false);
                      },
                      data: widget.content?['Message'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUrlLinkImgorVideo(str) {
    if (!(str == null)) {
      setState(() {
        List splitedInitial = [];
        List dataProcessed = [];
        List dataFinal = [];
        print('hHhHHH $str');
        str.replaceAll("\n", "");
        str.replaceAll("\r", "");
        splitedInitial = str.split("video:");
        splitedInitial.remove("");

        splitedInitial.forEach((element) {
          List subPart = [];
          if (element.toString().contains("img:")) {
            subPart = element.toString().split("img:");
            subPart.remove("");
            subPart.forEach((element) {
              dataProcessed.add(element.toString().trim());
            });
          } else {
            dataProcessed.add(element.toString().trim());
          }
        });

        dataProcessed.remove('');

        dataProcessed.forEach((element) {
          String temp = element.toString().replaceAll(',', '');
          dataFinal.add(temp);
        });
        dataFinal.forEach((element) {
          _linksOfData.add({
            "link": element,
            "type": element.toString().contains(".mp4") ? "Video" : "Image"
          });
        });

        print('Heloo $dataFinal');
      });
    }
  }

  // void getUrlLinkImgorVideo(param0) {
  //   print("hhhhh $param0");
  //
  //   if (param0 != null && param0.isNotEmpty) {
  //     if (param0.contains('video:')) {
  //       link = param0.replaceAll('video:', '');
  //       link = link.replaceAll(' ', '');
  //       imgOrVideo = 'video';
  //     }
  //     if (param0.contains('img:')) {
  //        // print("link is $link");
  //       List<String> linkListTemp = [];
  //       linkList = param0.split('img');
  //        print(linkList);
  //       linkList.forEach((element) {
  //         element = element.replaceAll(' ', '');
  //         element = element.replaceAll(':http', 'http');
  //         if (element.isNotEmpty) linkListTemp.add(element);
  //       });
  //       linkList = linkListTemp;
  //       if (linkList.length == 1) {
  //         link = linkList[0];
  //       }
  //       print(linkList);
  //       imgOrVideo = 'img';
  //     }
  //   }
  // }
}
