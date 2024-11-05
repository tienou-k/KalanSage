import 'package:flutter/material.dart';
import 'package:k_application/utils/constants.dart';

class ModuleDetailPage extends StatefulWidget {
  final String title;
  final String lessons;
  final String quizzes;
  final String imagePath;
  final bool isBookmarked;
  final int leconsCount;

  const ModuleDetailPage({
    super.key,
    required this.title,
    required this.lessons,
    required this.leconsCount,
    required this.quizzes,
    required this.imagePath,
    this.isBookmarked = false,
  });

  @override
  _ModuleDetailPageState createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> {
  late bool _isBookmarked; 

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget
                    .imagePath, 
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 200);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.lessons} Leçons',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${widget.quizzes} quizzes',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display leconsCount with a message
            Text(
              '${widget.leconsCount} lesson${widget.leconsCount != 1 ? 's' : ''} available',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              'Here you can put more details about the course',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: _isBookmarked ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked; 
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}