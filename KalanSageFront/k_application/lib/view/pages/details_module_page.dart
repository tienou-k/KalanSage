import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_application/models/lecon_model.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/auth_service.dart';
import 'package:k_application/services/module_service.dart';
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/pages/elements/inscrire_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class DetailModulePage extends StatefulWidget {
  final ModuleModel module;

  const DetailModulePage({super.key, required this.module});

  @override
  State<DetailModulePage> createState() => _DetailModulePageState();
}

class _DetailModulePageState extends State<DetailModulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<LeconModel>> _lessons;
  LeconModel? _selectedLesson;
  bool _isAlreadyEnrolled = false;

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _tabController = TabController(length: 3, vsync: this);
    _lessons = ModuleService().getLeconsByModule(widget.module.id);
    _checkEnrollmentStatus();

    _startFirstLesson();
    // Add listener to detect tab changes
    _tabController.addListener(() {
      setState(() {
        _selectedLesson = _tabController.index == 1 ? _selectedLesson : null;
      });
    });
  }

  // Method to set the first lesson as the selected lesson and update video preview
  void _startFirstLesson() {
    if (widget.module.lessons.isNotEmpty) {
      setState(() {
        _selectedLesson = widget.module.lessons[0];
      });
    }
  }

  void _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<int?> getCurrentUserId() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getInt('userId');
  }

  //
  Future<void> _checkEnrollmentStatus() async {
    final userId = await AuthService().getCurrentUserId();
    if (userId != null) {
      bool isEnrolled =
          await UserService().isUserEnrolledInModule(widget.module.id);
      setState(() {
        _isAlreadyEnrolled = isEnrolled;
      });
    } else {
      print('Error: User ID is null. User might not be logged in.');
    }
  }

  // Retrieve the current user's ID from SharedPreferences
  // ignore: unused_element
  Future<int?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildLessonVideoPreview(),
          ),
          SizedBox(height: 8),
          _buildTabBar(),
          Expanded(
            child: _buildTabBarView(),
          ),
        ],
      ),
      bottomNavigationBar: InscrireButton(
        module: widget.module,
        isAlreadyEnrolled: _isAlreadyEnrolled,
        onEnrollmentStatusChanged: (bool isAlreadyEnrolled) {
          setState(() {
            _isAlreadyEnrolled = isAlreadyEnrolled;
          });
        },
        onStartFirstLesson: _startFirstLesson,
      ),
    );
  }

  // Method to set the first lesson as the selected lesson and update video preview
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        EncodingUtils.decode(widget.module.title),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
    );
  }

  // Widget _buildLessonVideoPreview() {
  //   if (_tabController.index == 0) {
  //     // General tab selected
  //     return Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Container(
  //         height: 180,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black26,
  //               blurRadius: 10,
  //               offset: Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: Stack(
  //           children: [
  //             // Background image with gradient overlay
  //             Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 image: DecorationImage(
  //                   image: NetworkImage(widget.module.imageUrl),
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //             // Foreground content with opaque background
  //             Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 color: const Color.fromARGB(137, 1, 74, 87),
  //               ),
  //               child: Stack(
  //                 children: [
  //                   // Gradient overlay
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       gradient: LinearGradient(
  //                         colors: [
  //                           primaryColor.withOpacity(0.8),
  //                           const Color.fromARGB(0, 5, 126, 134),
  //                         ],
  //                         begin: Alignment.topCenter,
  //                         end: Alignment.bottomCenter,
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           EncodingUtils.decode(widget.module.description),
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Text(
  //                           'Prix: ${widget.module.price}',
  //                           style: TextStyle(
  //                             fontSize: 22,
  //                             color: Colors.amberAccent,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   } else if (_tabController.index == 1 && _selectedLesson != null) {
  //     // Leçons tab
  //    return Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: SizedBox(
  //         width: double.infinity,
  //         height: MediaQuery.of(context).size.height * 0.6,
  //         child: Center(
  //           child: VideoPlayerWidget(
  //             videoPath: _selectedLesson!.videoPath,
  //             onNextLesson: _nextLesson,
  //             onPreviousLesson: _previousLesson,
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     // Fichiers tab
  //     return Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Container(
  //         height: 180,
  //         decoration: BoxDecoration(
  //           color: Colors.grey[200],
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Center(
  //           child: Text(
  //             'No Files Available',
  //             style: TextStyle(fontSize: 10, color: secondaryColor),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }
Widget _buildLessonVideoPreview() {
    switch (_tabController.index) {
      case 0:
        return GeneralPreviewWidget(module: widget.module);

      case 1:
        if (_selectedLesson != null) {
          return LessonVideoPreview(
            videoPath: _selectedLesson!.videoPath,
            onNextLesson: _nextLesson,
            onPreviousLesson: _previousLesson,
          );
        }
        return const Center(child: Text("Select a lesson to preview video"));

      case 2:
        return const FilePlaceholderWidget();

      default:
        return const SizedBox.shrink();
    }
  }

  
//----------------------------------------------------------------------------------
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TabBar(
        controller: _tabController,
        indicatorColor: primaryColor,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        tabs: [
          Tab(text: 'General'),
          Tab(text: 'Leçons'),
          Tab(text: 'Fichiers'),
        ],
      ),
    );
  }


  Widget _buildTabBarView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TabBarView(
        controller: _tabController,
        children: [
          GeneralTab(module: widget.module),
          FutureBuilder<bool>(
            future: _checkUserEnrollment(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final isAlreadyEnrolled = snapshot.data ?? false;
                return ModulesTab(
                  lessons: _lessons,
                  onSelectLesson: (lesson) {
                    setState(() {
                      _selectedLesson = lesson;
                    });
                  },
                  // unlockAllLessons: widget.module.price == 0 || isEnrolled,
                  unlockAllLessons: widget.module.price == 0,
                  isEnrolled: isAlreadyEnrolled,
                  isTestMode: true,
                  // isEnrolled: isEnrolled,
                );
              }
            },
          ),
          FilesTab(),
        ],
      ),
    );
  }

  Future<bool> _checkUserEnrollment() async {
    final moduleId = widget.module.id;
    return await UserService().isUserEnrolledInModule(moduleId);
  }

  void _nextLesson() {
    if (_selectedLesson != null) {
      int currentIndex = widget.module.lessons.indexOf(_selectedLesson!);
      if (currentIndex < widget.module.lessons.length - 1) {
        setState(() {
          _selectedLesson = widget.module.lessons[currentIndex + 1];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No more lessons available.'),
          ),
        );
      }
    }
  }

  void _previousLesson() {
    if (_selectedLesson != null) {
      int currentIndex = widget.module.lessons.indexOf(_selectedLesson!);
      if (currentIndex < widget.module.lessons.length - 1) {
        setState(() {
          _selectedLesson = widget.module.lessons[currentIndex - 1];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No more lessons available.'),
          ),
        );
      }
    }
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final VoidCallback? onNextLesson;
  final VoidCallback? onPreviousLesson;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.onNextLesson,
    this.onPreviousLesson,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  double _volume = 1.0;
  bool _isFullscreen = false;
  bool _showVolumeSlider = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      if (widget.videoPath.isEmpty) {
        throw Exception("Video URL is empty");
      }
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
            ..initialize().then((_) {
              setState(() {
                _isLoading = false;
              });
              _controller.setVolume(_volume);
              _controller.play();
            });
    } catch (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print("Error initializing video: $error");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
          strokeWidth: 5.0,
        ),
      );
    }
    if (_hasError) {
      return Center(child: Text('Error loading video'));
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous),
                      onPressed: widget.onPreviousLesson,
                    ),
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      onPressed: widget.onNextLesson,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                          _volume > 0 ? Icons.volume_up : Icons.volume_off),
                      onPressed: () {
                        setState(() {
                          _showVolumeSlider = !_showVolumeSlider;
                        });
                      },
                    ),
                    if (_showVolumeSlider)
                      SizedBox(
                        height: 80,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                            value: _volume,
                            onChanged: (value) {
                              setState(() {
                                _volume = value;
                                _controller.setVolume(_volume);
                              });
                            },
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: '${(_volume * 100).round()}%',
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(_isFullscreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen),
                      onPressed: toggleFullscreen,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration position) {
    return "${position.inMinutes.remainder(60).toString().padLeft(2, '0')}:${position.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }
}

class GeneralTab extends StatelessWidget {
  final ModuleModel module;

  const GeneralTab({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("À propos"),
          ),
          ListTile(
            leading: Icon(Icons.workspace_premium_outlined),
            title: Text("Certificat"),
          ),
          ListTile(
            leading: Icon(Icons.question_answer_outlined),
            title: Text("Q&A"),
          ),
          ListTile(
            leading: Icon(Icons.note_alt_outlined),
            title: Text("Notes"),
          ),
          ListTile(
            leading: Icon(Icons.favorite_outline),
            title: Text("Ajouter aux favoris"),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ModulesTab extends StatelessWidget {
  final Future<List<LeconModel>> lessons;
  final Function(LeconModel?) onSelectLesson;
  final bool unlockAllLessons;
  final bool isEnrolled;
  final bool isTestMode;

  const ModulesTab({
    super.key,
    required this.lessons,
    required this.onSelectLesson,
    required this.unlockAllLessons,
    required this.isEnrolled,
    this.isTestMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LeconModel>>(
      future: lessons,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                Text(
                  'Aucune leçon disponible.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        final lessons = snapshot.data!;
        return ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            // Override locking for testing purposes
            final isUnlocked = isTestMode || isEnrolled || unlockAllLessons;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color.fromARGB(82, 224, 224, 224),
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  '${index + 1}. ${EncodingUtils.decode(lesson.titre)}',
                  style: TextStyle(
                    color: isUnlocked ? Colors.black : Colors.grey,
                    decoration: isUnlocked ? null : TextDecoration.lineThrough,
                  ),
                ),
                subtitle: Text(
                  EncodingUtils.decode(lesson.description),
                  style: TextStyle(
                    color: isUnlocked ? Colors.black : Colors.grey,
                  ),
                ),
                onTap: isUnlocked ? () => onSelectLesson(lesson) : null,
                trailing: isUnlocked
                    ? Icon(Icons.play_arrow, color: Colors.black)
                    : Icon(Icons.lock, color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }
}

// Files Tab (optional)
class FilesTab extends StatelessWidget {
  const FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming you have a way to check for files
    bool hasFiles = false;

    return Center(
      child: hasFiles
          // ignore: dead_code
          ? const Text('Contenu Fichier ici')
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  size: 60,
                  color: primaryColor,
                ),
                SizedBox(height: 1),
                Text(
                  'Pas de ressources !',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }
}

class GeneralPreviewWidget extends StatelessWidget {
  final ModuleModel module;

  const GeneralPreviewWidget({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image with gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(module.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Foreground content with opaque background
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(137, 1, 74, 87),
              ),
              child: Stack(
                children: [
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0.8),
                          const Color.fromARGB(0, 5, 126, 134),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          EncodingUtils.decode(module.description),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Prix: ${module.price}',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class LessonVideoPreview extends StatelessWidget {
  final String videoPath;
  final VoidCallback? onNextLesson;
  final VoidCallback? onPreviousLesson;

  const LessonVideoPreview({
    super.key,
    required this.videoPath,
    this.onNextLesson,
    this.onPreviousLesson,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: VideoPlayerWidget(
            videoPath: videoPath,
            onNextLesson: onNextLesson,
            onPreviousLesson: onPreviousLesson,
          ),
        ),
      ),
    );
  }
}
class FilePlaceholderWidget extends StatelessWidget {
  const FilePlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'No Files Available',
            style: TextStyle(fontSize: 10, color: secondaryColor),
          ),
        ),
      ),
    );
  }
}
