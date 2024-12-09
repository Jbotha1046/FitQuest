import 'dart:io';
import 'dart:async';
import 'package:fit_quest/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_database.dart'; // Import the LocalDatabaseHelper
import 'user_run.dart'; //

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
      home: WorkoutListPageExpert(),
    );
  }
}

class WorkoutListPageExpert extends StatefulWidget {
  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPageExpert> {
  bool _isRunning = false;
  Timer? _timer;
  Duration _duration = Duration();
  String _formattedTime = "00:00:00";

  @override
  void initState() {
    super.initState();
    _startRun();
  }

  void _startRun() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration = _duration + Duration(seconds: 1);
        _formattedTime = _formatDuration(_duration);
      });
    });
  }

  void _pauseRun() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resumeRun() {
    _startRun();
  }

  void _endRun() async {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();

    // Get the workout duration in seconds
    int workoutTimeInSeconds = _duration.inSeconds;

    // Get the current user from Firebase Authentication
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      _showMessage("No user logged in. Cannot save the run.");
      return;
    }

    // Create a UserRun object for saving to the local SQLite database
    final userRun = UserRun(
      userId: userId,
      workoutLevel: 'intermediate', // Use dynamic level if required
      workoutTime: workoutTimeInSeconds,
      timestamp: Timestamp.now(), // Use current time as timestamp
    );

    try {
      // Save workout data to Firestore
      await FirebaseFirestore.instance.collection('workout').add({
        'user_id': userId,
        'workout_level': 'expert',
        'workout_time': workoutTimeInSeconds,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Save workout data to local SQLite database
      try {
        final id = await LocalDatabaseHelper.instance.insertUserRun(userRun);
        print("Run saved to SQLite with ID: $id");
      } catch (e) {
        print("Error saving to SQLite: $e");
      }

      _showMessage("Workout saved successfully.");
    } catch (e) {
      print("Error saving to Firestore: $e");
      _showMessage("Failed to save workout to Firestore: $e");
    }

    // Reset the workout duration and formatted time
    _duration = Duration(); // Reset the duration
    _formattedTime = "00:00:00"; // Reset the formatted time

    // Navigate back to the HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  final List<Workout> workouts = [
    Workout(
        name: 'Hand Release Push-ups',
        description:
        'Do 40  push-ups to strengthen your chest and arms. But do 3 sets',
        gifUrl:
        'assets/intermediate/hand_realease_push_up.gif'),
    Workout(
        name: 'Side Squats',
        description:
        'Do 40 squats to strengthen your legs and glutes. But do 3 sets',
        gifUrl:
        'assets/intermediate/side_squat.gif'),
    Workout(
        name: 'Plank',
        description:
        'Hold the plank position for 120 seconds to strengthen your core.',
        gifUrl:
        'assets/intermediate/plank.gif'),
    Workout(
        name: 'Lunges',
        description:
        'Do 40 lunges on each leg to strengthen your legs and glutes. But do 3 sets',
        gifUrl:
        'assets/intermediate/lunges.gif'),
    Workout(
        name: 'Sit-ups',
        description:
        'Do 50 sit-ups to strengthen your abdominal muscles. But do 3 sets',
        gifUrl:
        'assets/intermediate/sit-ups.gif'),
    Workout(
        name: 'Mountain Climbers',
        description:
        'Perform 60 mountain climbers for full-body cardio and strength. But do 3 sets',
        gifUrl:
        'assets/intermediate/mountain_climber.gif'),
    Workout(
        name: 'Burpees',
        description: 'Do 30 burpees for a full-body workout.',
        gifUrl:
        'assets/intermediate/burpee.gif'),
    Workout(
        name: 'Jumping Jacks',
        description: 'Perform 120 jumping jacks to improve cardio.',
        gifUrl:
        'assets/intermediate/jumping_jack.gif'),
    Workout(
        name: 'Agility Ball Drill',
        description: 'Perform 100 Ball throws to improve arms. 50 for each arm',
        gifUrl:
        'assets/medium/agility_ball_throw.gif'),
    Workout(
        name: 'Air bike',
        description: 'Perform 60 Air bike  to improve abs.',
        gifUrl:
        'assets/medium/air_bike.gif'),
    Workout(
        name: 'Alternate Biceps Curl',
        description:
        'Perform 100 Biceps Curl to improve cardio. 50 per arm with a band',
        gifUrl:
        'assets/medium/alternate_bicep_curls.gif'),
    Workout(
        name: 'Around the World Superman ',
        description:
        'Hold the Around the World Superman  position for 120 seconds to strengthen your core.',
        gifUrl:
        'assets/medium/around_the_world_superman.gif'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Workouts'),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Time: $_formattedTime"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isRunning ? _pauseRun : _resumeRun,
                      child: Text(_isRunning ? "Pause" : "Resume"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isRunning ? _endRun : null,
                      child: Text("End Workout"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkoutDetailPage(workout: workouts[index]),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: kIsWeb
                            ? Image.asset(
                          workouts[index].gifUrl,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          workouts[index].gifUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        workouts[index].name,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutDetailPage extends StatelessWidget {
  final Workout workout;

  WorkoutDetailPage({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(workout.gifUrl),
            SizedBox(height: 16),
            Text(workout.description),
          ],
        ),
      ),
    );
  }
}

class Workout {
  final String name;
  final String description;
  final String gifUrl;

  Workout({required this.name, required this.description, required this.gifUrl});
}
