import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
ChewieController? chewieController;

class ChewieListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewieListItem({
    required this.videoPlayerController,
    required this.looping,
    Key? key,
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {

  @override
  void initState() {
    super.initState();
    Consumer<MainProvider>(
      builder: (context, value, child){
        if(!(value.playVideo==null)){
          chewieController!.pause();
          widget.videoPlayerController.pause();
        }
        return Container();
      },);
    // Wrapper on top of the videoPlayerController
    chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 11,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      looping: widget.looping,
      autoPlay: true,
      allowFullScreen: false,
      placeholder: Center(
        child: CircularProgressIndicator(),
      ),
      errorBuilder: (_,__)=>Container(),
      showControlsOnInitialize: false,
      // Errors can occur for example when trying to play a video
      // from a non-existent URL
    );
  }

  @override
  Widget build(BuildContext context) {
    return chewieController==null ? Container() : Chewie(
      controller: chewieController!,
    );
  }

 @override
  void dispose() {
    widget.videoPlayerController.dispose();
    //chewieController!.dispose();
   chewieController!.pause();
   chewieController!.dispose();
   // videoPlayerController.dispose();
    super.dispose();
  }
}