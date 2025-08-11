// lib/domain/models/meta_model.dart

class Meta {
  final String id;
  final String descricao;
  final String categoria;
  final double valorObjetivo;
  final double valorAtual;

  Meta({
    required this.id,
    required this.descricao,
    required this.categoria,
    required this.valorObjetivo,
    this.valorAtual = 0.0,
  });

  // Propriedade computada para o progresso (de 0.0 a 1.0)
  double get progresso {
    if (valorObjetivo == 0) return 0.0;
    return valorAtual / valorObjetivo;
  }

  // É uma boa prática ter um método copyWith para facilitar atualizações imutáveis
  Meta copyWith({
    String? id,
    String? descricao,
    String? categoria,
    double? valorObjetivo,
    double? valorAtual,
  }) {
    return Meta(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      valorObjetivo: valorObjetivo ?? this.valorObjetivo,
      valorAtual: valorAtual ?? this.valorAtual,
    );
  }
}