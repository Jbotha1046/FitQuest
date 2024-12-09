import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'RunReplayPage.dart'; // Import the RunReplayPage

class UserRunsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Your Runs and Workouts'),
        ),
        body: Center(
            child: Text('You need to log in to see your runs and workouts.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Runs and Workouts'),
        backgroundColor: Colors.grey,
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('runs')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No runs available.'));
              }

              final runs = snapshot.data!.docs;

              runs.sort((a, b) {
                final timestampA = a['timestamp'] as Timestamp?;
                final timestampB = b['timestamp'] as Timestamp?;
                if (timestampA == null || timestampB == null) return 0;
                return timestampB.compareTo(timestampA);
              });

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: runs.length,
                itemBuilder: (context, index) {
                  final run = runs[index].data() as Map<String, dynamic>;
                  final duration = run['duration'] ?? "00:00:00";
                  final distance = (run['distance'] is num)
                      ? (run['distance'] as num).toDouble().toStringAsFixed(2)
                      : double.tryParse(run['distance']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00';


                  return ListTile(
                    title: Text('Run - Distance: $distance km'),
                    subtitle: Text(
                        'Time: ${Duration(seconds: duration).toString().split('.').first}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RunReplayPage(
                            runData: run, // Pass the run data to RunReplayPage
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          Divider(),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('workout')
                .where('user_id', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No workouts available.'));
              }

              final workouts = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout =
                  workouts[index].data() as Map<String, dynamic>;
                  final workoutTime = workout['workout_time'] ?? 0;
                  final workoutLevel = workout['workout_level'] ?? 'Unknown';

                  return ListTile(
                    title: Text('Workout - Level: $workoutLevel'),
                    subtitle: Text(
                        'Time: ${Duration(seconds: workoutTime).toString().split('.').first}'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
