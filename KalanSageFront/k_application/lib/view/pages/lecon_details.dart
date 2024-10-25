import 'package:flutter/material.dart';
import 'package:k_application/models/lecon_model.dart';
import 'package:video_player/video_player.dart';

class LessonDetailPage extends StatefulWidget {
  final LeconModel lesson;

  const LessonDetailPage({super.key, required this.lesson});

  @override
  _LessonDetailPageState createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  late VideoPlayerController _videoPlayerController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();

    // Construct full video URL if `videoPath` exists and is not empty
    const baseUrl = "http://localhost:8080/images_du_projet/videos_lecons/";
    final videoUrl =
        (widget.lesson.videoPath.isNotEmpty)
            ? "$baseUrl${widget.lesson.videoPath}"
            : null;

    if (videoUrl == null) {
      print("Error: Invalid or empty video URL");
    } else {
      print("Valid video URL: $videoUrl");

      // Initialize the video player controller
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl))
            ..initialize().then((_) {
              setState(() {
                _isVideoInitialized = true; // Video has been initialized
              });
            }).catchError((error) {
              print("Error initializing video player: $error");
            });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.titre),
      ),
      body: Column(
        children: [
          if (_isVideoInitialized)
            AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            )
          else
            Center(
                child:
                    CircularProgressIndicator()), // Show loading indicator until video is initialized

          // Other lesson details like title, description, etc.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.lesson.description),
          ),
        ],
      ),
      floatingActionButton: _isVideoInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  // Toggle play and pause
                  if (_videoPlayerController.value.isPlaying) {
                    _videoPlayerController.pause();
                  } else {
                    _videoPlayerController.play();
                  }
                });
              },
              child: Icon(
                _videoPlayerController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
