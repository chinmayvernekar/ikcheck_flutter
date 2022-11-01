import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerTest extends StatefulWidget {
  FlickManager flickManager = FlickManager(
    videoPlayerController: VideoPlayerController.network(
      // link,
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    ),
  );

  @override
  State<VideoPlayerTest> createState() => _VideoPlayerTestState();
}

class _VideoPlayerTestState extends State<VideoPlayerTest> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.flickManager.flickControlManager!.enterFullscreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: SCREENHEIGHT.h,
        child: Column(
          children: [
            Container(
              height: 400.h,
              child: VisibilityDetector(
                key: ObjectKey(widget.flickManager),
                onVisibilityChanged: (visibility) {
                  if (visibility.visibleFraction == 0 && this.mounted) {
                    widget.flickManager.flickControlManager?.autoPause();
                  } else if (visibility.visibleFraction == 1) {
                    widget.flickManager.flickControlManager?.autoResume();
                  }
                },
                child: Container(
                  child: FlickVideoPlayer(
                    flickManager: widget.flickManager,
                    preferredDeviceOrientation: [
                      DeviceOrientation.landscapeRight,
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.landscapeLeft,
                    ],
                    preferredDeviceOrientationFullscreen: [
                      DeviceOrientation.landscapeRight,
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.landscapeLeft,
                    ],
                    flickVideoWithControls: FlickVideoWithControls(
                      controls: FlickPortraitControls(),
                    ),
                    flickVideoWithControlsFullscreen: FlickVideoWithControls(
                      controls: FlickLandscapeControls(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
