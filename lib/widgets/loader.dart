import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iKCHECK/utils/globalVariables.dart';
import 'package:shimmer/shimmer.dart';

Widget buildSkeletonAnimation() => ListTile(
      leading: SkeletonAnimationWidget.Circular(
        height: 54,
        width: 54,
        shapeBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      trailing: SkeletonAnimationWidget.rectangular(
        height: 15,
        width: 15,
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: SkeletonAnimationWidget.rectangular(
          height: 8,
          width: SCREENWIDTH / 1.w,
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: SkeletonAnimationWidget.rectangular(
          height: 11,
          width: (SCREENWIDTH / 1).w,
        ),
      ),
    );

class SkeletonAnimationWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const SkeletonAnimationWidget.Circular(
      {required this.width,
      required this.height,
      this.shapeBorder = const CircleBorder()});
  const SkeletonAnimationWidget.rectangular({
    required this.width,
    required this.height,
  }) : this.shapeBorder = const RoundedRectangleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Container(
        decoration: ShapeDecoration(shape: shapeBorder, color: Colors.grey),
        // color: Colors.grey,
        width: width,
        height: height,
      ),
    );
  }
}


Widget buildSkeletonAnimationDashboard() => SkeletonAnimationWidgetDashboard.Square(
  height: 30,
   width: 30,
 shapeBorder:
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
 );


class SkeletonAnimationWidgetDashboard extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const SkeletonAnimationWidgetDashboard.Square(
      {required this.width,
        required this.height,
        this.shapeBorder = const CircleBorder()});
  const SkeletonAnimationWidgetDashboard.square({
    required this.width,
    required this.height,
  }) : this.shapeBorder = const RoundedRectangleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Container(
        decoration: ShapeDecoration(shape: shapeBorder, color: Colors.grey),
        // color: Colors.grey,
        width: width,
        height: height,
      ),
    );
  }
}


Widget buildSkeletonAnimationMore() =>ListTile(
  contentPadding: EdgeInsets.all(0),
  title: Align(
    alignment: Alignment.centerLeft,
    child: SkeletonAnimationWidget.rectangular(
      height: 8,
      width: double.maxFinite,
    ),
  ),
  subtitle: Align(
    alignment: Alignment.centerLeft,
    child: SkeletonAnimationWidget.rectangular(
      height: 11,
      width: SCREENWIDTH.w,
    ),
  ),
);



class SkeletonAnimationWidgetMore extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const SkeletonAnimationWidgetMore.Rectangle(
      {required this.width,
        required this.height,
        this.shapeBorder = const CircleBorder()});
  const SkeletonAnimationWidgetMore.square({
    required this.width,
    required this.height,
  }) : this.shapeBorder = const RoundedRectangleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Container(
        decoration: ShapeDecoration(shape: shapeBorder, color: Colors.grey),
        // color: Colors.grey,
        width: width,
        height: height,
      ),
    );
  }
}