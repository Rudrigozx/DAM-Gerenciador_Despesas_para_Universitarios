// lib/domain/models/goal_model.dart

class Goal {
  final String id;
  final String description;
  final String category;
  final double targetAmount;
  final double currentAmount;

  Goal({
    required this.id,
    required this.description,
    required this.category,
    required this.targetAmount,
    this.currentAmount = 0.0,
  });

  // Computed property for progress (from 0.0 to 1.0)
  double get progress {
    if (targetAmount == 0) return 0.0;
    return currentAmount / targetAmount;
  }

  // It's good practice to have a copyWith method to facilitate immutable updates
  Goal copyWith({
    String? id,
    String? description,
    String? category,
    double? targetAmount,
    double? currentAmount,
  }) {
    return Goal(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
    );
  }
}