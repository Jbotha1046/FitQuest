import 'package:flutter/material.dart';
import 'package:fit_quest/pages/Workout_intemediate.dart';
import 'package:fit_quest/pages/Workout_medium.dart';
import 'package:fit_quest/pages/Workout_expert.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkoutLevelPage(),
    );
  }
}

// Front page where users select their workout level
class WorkoutLevelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Workout Level'),
        backgroundColor: Colors.grey, // Corrected from Colors.Grey
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Buttons for each workout level
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF586F6B), // Corrected from primary
                minimumSize: Size(200, 60), // Set the height and width
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutListPage()),
                );
              },
              child: Text('Intermediate'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF586F6B), // Corrected from primary
                minimumSize: Size(200, 60), // Set the height and width
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutListPageMedium(),
                  ),
                );
              },
              child: Text('Good'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF586F6B), // Corrected from primary
                minimumSize: Size(200, 60), // Set the height and width
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutListPageExpert(),
                  ),
                );
              },
              child: Text('Expert'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 5),
                  Text('Back'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
