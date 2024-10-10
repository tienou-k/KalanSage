import 'package:flutter/material.dart';
import 'package:k_application/utils/constants.dart';

class FullScreenHeader extends StatelessWidget {
  const FullScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return
     Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(
        color: primaryColor, 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Mariame Daou',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '@jessbailey',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
