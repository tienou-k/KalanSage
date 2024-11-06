import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';

import '../../../models/ReviewModel.dart';
import '../../../utils/constants.dart';

class ReviewPage extends StatefulWidget {
  final ModuleModel module;

  const ReviewPage({Key? key, required this.module}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _reviewController = TextEditingController();
  bool isEditing = false;
  bool reviewSubmitted = false;

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Notez' : 'Avis'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (isEditing) {
              toggleEditing();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        // This centers the content in the body
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isEditing ? _buildReviewInput() : _buildReviewDisplay(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // This moves the button to the right
      floatingActionButton: FloatingActionButton(
        onPressed: toggleEditing,
        backgroundColor: primaryColor,
        child: Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildReviewDisplay() {
    return FutureBuilder<Review>(
      future: fetchReview(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          // Display empty state when there are no reviews
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.feedback,
                  size: 100,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                Text(
                  'Aucun avis disponible.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }

        // If we have data, display it
        final review = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(review.profileImage),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review.date,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            review.comment,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewInput() {
    return Positioned(
      bottom: 16, // Distance from the bottom of the screen
      right: 16, // Distance from the right of the screen
      left:
          16, // Distance from the left to ensure it doesn't touch the screen edge
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        margin: const EdgeInsets.all(0), // Margin can be adjusted if needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              widget.module.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Display the module price and info
            Text(
              'Quel est votre avis ?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 10),

            // Review Text Input
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Laissez votre commentaire sur ce cours',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              maxLines: 6,
              minLines: 3,
            ),
            const SizedBox(height: 20),

            // Centering the "Envoyer" button at the bottom
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  if (_reviewController.text.isNotEmpty) {
                    // Handle the review submission here
                    _submitReview();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Veuillez rédiger un commentaire !'),
                        backgroundColor: secondaryColor,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Envoyer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReview() {
    String reviewText = _reviewController.text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Merci pour votre intérêt 🤗!'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {
      reviewSubmitted = true;
    });
    _reviewController.clear();
  }

  fetchReview() {}
}
