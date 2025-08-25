// transaction_data.dart

enum TransactionType {
  income,   // índice 0
  expense,  // índice 1
  transfer  // índice 2
}

class Transaction {
  final int? id; // O ID será nulo ao criar, mas virá do DB ao ler.
  String description;
  double amount;
  String category;
  TransactionType type;
  DateTime date;
  String? sourceAccount; // Pode ser nulo para receitas
  String? destinationAccount; // Pode ser nulo para despesas

  Transaction({
    this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.sourceAccount,
    this.destinationAccount,
  });

  // Método para converter o objeto Transaction para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'category': category,
      // Armazenamos o índice do enum, que é um inteiro. É mais eficiente.
      'type': type.index,
      // Armazenamos a data como uma string no formato ISO 8601.
      'date': date.toIso8601String(),
      'sourceAccount': sourceAccount,
      'destinationAccount': destinationAccount,
    };
  }

  // Método de fábrica para criar um Transaction a partir de um Map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      category: map['category'],
      // Convertemos o inteiro de volta para o enum TransactionType
      type: TransactionType.values[map['type']],
      // Convertemos a string de volta para DateTime
      date: DateTime.parse(map['date']),
      sourceAccount: map['sourceAccount'],
      destinationAccount: map['destinationAccount'],
    );
  }
}