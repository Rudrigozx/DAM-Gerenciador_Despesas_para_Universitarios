import 'package:fin_plus/data/services/DatabaseService.dart';
import 'package:fin_plus/domain/models/simulation_model.dart';

class SimulationRepository {
  final dbService = DatabaseService();

  Future<void> saveSimulation(InvestmentSimulation simulation) async {
    final db = await dbService.database;
    await db.insert('simulations', simulation.toMap());
  }

  Future<List<InvestmentSimulation>> getAllSimulations() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'simulations',
      orderBy: 'date DESC', // Mais recentes primeiro
    );
    return List.generate(maps.length, (i) => InvestmentSimulation.fromMap(maps[i]));
  }
}