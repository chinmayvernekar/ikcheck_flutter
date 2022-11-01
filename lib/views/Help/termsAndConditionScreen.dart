// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:iKCHECK/Utils/globalVariables.dart';
// import 'package:iKCHECK/Utils/styles.dart';

// class TermsAndConditionScreen extends StatefulWidget {
//   const TermsAndConditionScreen({Key? key}) : super(key: key);

//   @override
//   State<TermsAndConditionScreen> createState() =>
//       _TermsAndConditionScreenState();
// }

// class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
//   @override
//   void didChangeDependencies() {
//     flutterWebViewPlugin.hide();
//     super.didChangeDependencies();
//   }

//   @override
//   void didUpdateWidget(covariant TermsAndConditionScreen oldWidget) {
//     // TODO: implement didUpdateWidget
//     flutterWebViewPlugin.hide();

//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WebviewScaffold(
//       url: 'https://acc.ikcheck.app/terms/termsAndConditions.html',
//       initialChild: Container(
//         color: AppColors.ashColor,
//         child: Center(
//           child: Text(
//             'Waiting...',
//             style: AppFont.s1,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  late WebViewController _controller;
  // @override
  // void didChangeDependencies() {
  //   flutterWebViewPlugin.show();
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

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
                  LocaleKeys.HELP_TERMSANDCONDITIONS.tr(),
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
      body: WebView(
        initialUrl: '$DOMAIN_URL/terms/termsAndConditions.html',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        zoomEnabled: true,
        backgroundColor: AppColors.ashColor.withOpacity(0.1),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
