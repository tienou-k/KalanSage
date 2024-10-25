import 'package:flutter/material.dart';
import 'package:k_application/models/lecon_model.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/module_service.dart';
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

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _tabController = TabController(length: 3, vsync: this);
    _lessons = ModuleService().getLeconsByModule(widget.module.id);
  }

  void _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<int?> _getCurrentUserId() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getInt('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildLessonVideoPreview(), // Show lesson preview
          SizedBox(height: 8),
          _buildTabBar(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
      bottomNavigationBar: InscrireButton(module: widget.module),
    );
  }

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
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
    );
  }

  Widget _buildLessonVideoPreview() {
    if (_selectedLesson == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 180,
          child: Center(
            child: Text(
              'Aucune leçon sélectionnée.',
              style: TextStyle(fontSize: 10, color: secondaryColor),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: VideoPlayerWidget(videoUrl: _selectedLesson!.videoPath),
          ),
        ),
      );
    }
  }

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
          ModulesTab(
            lessons: _lessons,
            onSelectLesson: (lesson) {
              setState(() {
                _selectedLesson = lesson; // Store selected lesson
              });
            },
            unlockAllLessons: widget.module.price == 0,
          ),
          FilesTab(),
        ],
      ),
    );
  }
}
class VideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController? _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
            ..initialize().then((_) {
              setState(() {});
            }).catchError((error) {
              setState(() {
                _hasError = true;
              });
            });
    } else {
      setState(() {
        _hasError = true;
      });
      print('Error: Invalid or empty video URL');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || widget.videoUrl == null || widget.videoUrl!.isEmpty) {
      return Center(
        child: Text('No loading video', style: TextStyle(color: Colors.red)),
      );
    }

    return _controller != null && _controller!.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          )
        : Center(child: CircularProgressIndicator());
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

  const ModulesTab({
    super.key,
    required this.lessons,
    required this.onSelectLesson,
    required this.unlockAllLessons,
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

        final lessonsList = snapshot.data!;
        return ListView.builder(
          itemCount: lessonsList.length,
          itemBuilder: (context, index) {
            final lesson = lessonsList[index];
            final isUnlocked = unlockAllLessons || lesson.videoPath != null;
            final isCompleted = lesson.quiz != null;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: const Color.fromARGB(82, 224, 224, 224)),
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
                  EncodingUtils.decode( lesson.description ),
                  style:
                      TextStyle(color: isUnlocked ? Colors.black : Colors.grey),
                ),
                trailing: isUnlocked
                    ? Icon(Icons.play_arrow, color: Colors.black)
                    : Icon(Icons.lock, color: Colors.grey),
                onTap: isUnlocked ? () => onSelectLesson(lesson) : null,
                // Disable tap if lesson is locked
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

//


