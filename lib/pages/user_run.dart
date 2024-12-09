import 'package:cloud_firestore/cloud_firestore.dart';

class UserRun {
  final String userId;
  final String workoutLevel;
  final int workoutTime; // Time in seconds
  final Timestamp timestamp;

  // Constructor to initialize the class with the required parameters
  UserRun({
    required this.userId,
    required this.workoutLevel,
    required this.workoutTime,
    required this.timestamp,
  });

  // Factory constructor to convert a Firestore document to a UserRun object
  factory UserRun.fromFirestore(DocumentSnapshot doc) {
    var data =
        doc.data() as Map<String, dynamic>; // Convert Firestore document to Map
    return UserRun(
      userId: data['user_id'] ?? '', // Default to empty string if null
      workoutLevel: data['workout_level'] ?? '',
      workoutTime: data['workout_time'] ?? 0, // Default to 0 if null
      timestamp: data['timestamp'], // Timestamp field directly from Firestore
    );
  }

  // Method to convert UserRun object back to a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'workout_level': workoutLevel,
      'workout_time': workoutTime,
      'timestamp': timestamp,
    };
  }

  // Add the fromMap method to convert from SQLite Map to UserRun object
  factory UserRun.fromMap(Map<String, dynamic> map) {
    return UserRun(
      userId: map['user_id'],
      workoutLevel: map['workout_level'],
      workoutTime: map['workout_time'],
      timestamp:
          Timestamp.fromMillisecondsSinceEpoch(int.parse(map['timestamp'])),
    );
  }
}
