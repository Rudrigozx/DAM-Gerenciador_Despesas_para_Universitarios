class Goal {
  final int? id; // MUDANÇA: de String para int? para ser compatível com o DB
  final String description;
  final String category;
  final double targetAmount;
  final double currentAmount;

  Goal({
    this.id, // MUDANÇA: agora é opcional
    required this.description,
    required this.category,
    required this.targetAmount,
    this.currentAmount = 0.0,
  });

  double get progress {
    if (targetAmount == 0) return 0.0;
    return currentAmount / targetAmount;
  }
  
  // ... (o método copyWith ainda é útil)
  Goal copyWith({
    int? id,
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

  // ADICIONE ESTES MÉTODOS
  // Converte uma instância de Goal em um Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
    };
  }

  // Cria uma instância de Goal a partir de um Map.
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] as int?,
      description: map['description'] as String,
      category: map['category'] as String,
      targetAmount: map['targetAmount'] as double,
      currentAmount: map['currentAmount'] as double,
    );
  }
}