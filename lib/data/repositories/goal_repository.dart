// lib/domain/repositories/goal_repository.dart
import 'package:fin_plus/domain/models/goal_model.dart';

abstract class IGoalRepository {
  Future<List<Goal>> getGoals();
  Future<void> createGoal(Goal goal);
  // Future<void> updateGoal(Goal goal);
  // Future<void> deleteGoal(String id);
}