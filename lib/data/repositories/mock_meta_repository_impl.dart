import 'package:fin_plus/data/repositories/meta_repository.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/meta_model.dart';

class MockMetaRepositoryImpl implements IMetaRepository {
  // Simula um banco de dados em memória
  final List<Meta> _metas = [
    Meta(id: '1', descricao: 'Viajar no carnaval', categoria: 'Viagens', valorObjetivo: 2000, valorAtual: 750),
    Meta(id: '2', descricao: 'Evento de tecnologia', categoria: 'Estudos', valorObjetivo: 1000, valorAtual: 1000),
    Meta(id: '3', descricao: 'Moto', categoria: 'Veículo', valorObjetivo: 10000, valorAtual: 1000),
  ];

  @override
  Future<List<Meta>> getMetas() async {
    // Simula um delay de rede
    await Future.delayed(const Duration(seconds: 1));
    return _metas;
  }

  @override
  Future<void> createMeta(Meta meta) async {
    await Future.delayed(const Duration(seconds: 1));
    // Cria um ID único para a nova meta
    final novaMeta = meta.copyWith(id: Uuid().v4());
    _metas.add(novaMeta);
  }
}