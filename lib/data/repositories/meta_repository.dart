

import 'package:fin_plus/domain/models/meta_model.dart';

abstract class IMetaRepository {
  Future<List<Meta>> getMetas();
  Future<void> createMeta(Meta meta);
  // Future<void> updateMeta(Meta meta);
  // Future<void> deleteMeta(String id);
}