import 'package:fit_quest/pages/cycle.dart';
import 'package:fit_quest/pages/run.dart';
import 'package:fit_quest/pages/workout_levels.dart';
import 'package:flutter/material.dart';
import 'package:fit_quest/pages/run.dart';
import 'package:flutter/foundation.dart'; // Import this to access kIsWeb
import 'package:fit_quest/pages/User_runs_page.dart';
// Adjust this to the correct path

void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentImageIndex = 1; // Start with forest1.jpg
  final int totalImages = 6; // Total number of images

  void changeImage(int direction) {
    setState(() {
      currentImageIndex += direction;
      if (currentImageIndex > totalImages) {
        currentImageIndex = 1; // Wrap around to the first image
      } else if (currentImageIndex < 1) {
        currentImageIndex = totalImages; // Wrap around to the last image
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/forest$currentImageIndex.jpg'), // Path to your background images
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // "Let’s Workout" text at the top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Let’s Workout",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RunTrackingScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF586F6B),
                        minimumSize: Size(166, 57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Start Running",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Left Circular Button
          Positioned(
            left: 16,
            top: MediaQuery.of(context).size.height / 2 - 25,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFF586F6B),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  changeImage(-1); // Go to the previous image
                },
              ),
            ),
          ),
          // Right Circular Button
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height / 2 - 25,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFF586F6B),
              child: IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  changeImage(1); // Go to the next image
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF586F6B),
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {
                // Navigate to the next page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutLevelPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.whatshot, color: Colors.white),
              onPressed: () {
                // Navigate to the next page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserRunsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
