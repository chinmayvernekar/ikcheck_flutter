import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:photo_view/photo_view.dart';

import '../utils/globalVariables.dart';

class ImageViewer extends StatelessWidget {
  String link = '';
  ImageViewer({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: SCREENHEIGHT.h * 0.1,
          actions: [
            const Spacer(
              flex: 1,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.clearBlack,
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Image viewer",
                style: AppFont.H1.copyWith(
                  color: AppColors.clearBlack,
                  fontSize: 23.sp,
                ),
              ),
            ),
            const Spacer(
              flex: 5,
            ),
          ],
          elevation: 0,
          backgroundColor: AppColors.clearWhite,
        ),
        backgroundColor: AppColors.clearWhite,
        body: PhotoView(
          imageProvider: NetworkImage(link),
        ),
      ),
    );
  }
}
