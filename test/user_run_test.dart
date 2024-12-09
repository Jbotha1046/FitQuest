import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_quest/pages/user_run.dart';
import 'package:mockito/mockito.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('UserRun', () {
    test('fromFirestore creates a UserRun object from Firestore document', () {
      // Arrange: Mock Firestore DocumentSnapshot
      final mockDoc = MockDocumentSnapshot();
      when(mockDoc.data()).thenReturn({
        'user_id': 'user123',
        'workout_level': 'Intermediate',
        'workout_time': 300,
        'timestamp': Timestamp.now(),
      });

      // Act: Create UserRun object from Firestore document
      final userRun = UserRun.fromFirestore(mockDoc);

      // Assert: Verify that the UserRun object is correctly created
      expect(userRun.userId, 'user123');
      expect(userRun.workoutLevel, 'Intermediate');
      expect(userRun.workoutTime, 300);
      expect(userRun.timestamp, isA<Timestamp>());
    });

    test('toMap converts a UserRun object to a Map', () {
      // Arrange: Create a UserRun object
      final userRun = UserRun(
        userId: 'user123',
        workoutLevel: 'Intermediate',
        workoutTime: 300,
        timestamp: Timestamp.now(),
      );

      // Act: Convert UserRun object to Map
      final userRunMap = userRun.toMap();

      // Assert: Verify that the Map contains the correct values
      expect(userRunMap['user_id'], 'user123');
      expect(userRunMap['workout_level'], 'Intermediate');
      expect(userRunMap['workout_time'], 300);
      expect(userRunMap['timestamp'], isA<Timestamp>());
    });

    test('fromMap converts a Map to a UserRun object', () {
      // Arrange: Create a Map
      final map = {
        'user_id': 'user123',
        'workout_level': 'Intermediate',
        'workout_time': 300,
        'timestamp': Timestamp.now().millisecondsSinceEpoch.toString(),
      };

      // Act: Create UserRun object from Map
      final userRun = UserRun.fromMap(map);

      // Assert: Verify that the UserRun object is correctly created
      expect(userRun.userId, 'user123');
      expect(userRun.workoutLevel, 'Intermediate');
      expect(userRun.workoutTime, 300);
      expect(userRun.timestamp, isA<Timestamp>());
    });
  });
}
