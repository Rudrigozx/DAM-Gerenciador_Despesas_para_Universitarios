// lib/data/repositories/mock_goal_repository_impl.dart
import 'package:fin_plus/data/repositories/goal_repository.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/goal_model.dart';

class MockGoalRepositoryImpl implements IGoalRepository {
  // Simula um banco de dados em memória
  final List<Goal> _goals = [
    Goal(id: '1', description: 'Viajar no carnaval', category: 'Viagens', targetAmount: 2000, currentAmount: 750),
    Goal(id: '2', description: 'Evento de tecnologia', category: 'Estudos', targetAmount: 1000, currentAmount: 1000),
    Goal(id: '3', description: 'Moto', category: 'Veículo', targetAmount: 10000, currentAmount: 1000),
  ];

  @override
  Future<List<Goal>> getGoals() async {
    // Simula um delay de rede
    await Future.delayed(const Duration(seconds: 1));
    return _goals;
  }

  @override
  Future<void> createGoal(Goal goal) async {
    await Future.delayed(const Duration(seconds: 1));
    // Cria um ID único para a nova meta
    final newGoal = goal.copyWith(id: const Uuid().v4());
    _goals.add(newGoal);
  }
}