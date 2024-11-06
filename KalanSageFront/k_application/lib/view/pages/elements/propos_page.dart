import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/utils/constants.dart';

class ProposPage extends StatefulWidget {
  final ModuleModel module;

  const ProposPage({Key? key, required this.module}) : super(key: key);

  @override
  _ProposPageState createState() => _ProposPageState();
}

class _ProposPageState extends State<ProposPage> {
  final TextEditingController _reviewController = TextEditingController();
  bool reviewSubmitted = false;

  @override
  Widget build(BuildContext context) {
    // Calculate total duration of the module's lessons
    // double totalDuration = calculateTotalDuration(widget.module.lessons);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'A propos du module: ${widget.module.title}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Module Title
              Text(
                widget.module.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Module Description
              Text(
                EncodingUtils.decode(widget.module.description),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Module Price (if exists in the model)
              if (widget.module.price != null)
                Text(
                  'Prix: ${widget.module.price}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              const SizedBox(height: 20),

              // Additional Details
              Text(
                'Détails supplémentaires:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              // Add other custom module details here
              // Example:
              Text(
                'Durée du module: - jours',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Text(
                'Niveau requis: - ',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 20),
              Text(
                'Durée totale des leçons: - jours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
