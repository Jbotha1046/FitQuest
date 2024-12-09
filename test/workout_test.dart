import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_quest/main.dart';
import 'package:fit_quest/pages/workout_levels.dart';
import 'package:fit_quest/pages/Workout_intemediate.dart';
import 'package:fit_quest/pages/Workout_medium.dart';
import 'package:fit_quest/pages/Workout_expert.dart';

void main() {
  testWidgets('Navigates to WorkoutListPage when Intermediate button is tapped',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: WorkoutLevelPage()));
        await tester.tap(find.text('Intermediate'));
        await tester.pumpAndSettle();
        expect(find.byType(WorkoutListPage), findsOneWidget);
      });

  testWidgets('Navigates to WorkoutListPageMedium when Good button is tapped',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: WorkoutLevelPage()));
        await tester.tap(find.text('Good'));
        await tester.pumpAndSettle();
        expect(find.byType(WorkoutListPageMedium), findsOneWidget);
      });

  testWidgets('Navigates to WorkoutListPageExpert when Expert button is tapped',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: WorkoutLevelPage()));
        await tester.tap(find.text('Expert'));
        await tester.pumpAndSettle();
        expect(find.byType(WorkoutListPageExpert), findsOneWidget);
      });

  testWidgets('Back button navigates to the previous screen',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: WorkoutLevelPage()));
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
        expect(find.byType(WorkoutLevelPage), findsNothing);
      });
}
