import 'package:fin_plus/Models/category.dart';
import 'package:fin_plus/data/repositories/TransactionRepository.dart';
import 'package:fin_plus/data/repositories/category_repository.dart';
import 'package:fin_plus/domain/models/report_data_model.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'pdf_generator.dart';

enum ViewState { idle, loading, success, error }

// Classe auxiliar para unir os dados da categoria com seu valor gasto
class CategoryExpense {
  final Category category;
  final double amount;
  CategoryExpense({required this.category, required this.amount});
}

class ReportsViewModel extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime get startDate => _startDate;

  DateTime _endDate = DateTime.now();
  DateTime get endDate => _endDate;

  ReportData? _reportData;
  ReportData? get reportData => _reportData;

  // Propriedade para os dados enriquecidos do gráfico de pizza
  List<CategoryExpense> _categoryExpensesData = [];
  List<CategoryExpense> get categoryExpensesData => _categoryExpensesData;

  void setDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
    fetchReportData(); // Recarrega os dados com o novo intervalo
  }

  Future<void> fetchReportData() async {
    _state = ViewState.loading;
    notifyListeners();
    try {
      // Busca os dados do relatório e a lista de todas as categorias em paralelo
      final results = await Future.wait([
        _repository.getReportData(_startDate, _endDate),
        _categoryRepository.getAllCategories(),
      ]);

      _reportData = results[0] as ReportData;
      final allCategories = results[1] as List<Category>;

      // Transforma o Map<String, double> em uma List<CategoryExpense>
      _categoryExpensesData = _reportData!.expensesByCategory.entries.map((entry) {
        final category = allCategories.firstWhere(
          (cat) => cat.name == entry.key,
          // Cria uma categoria padrão caso não encontre uma correspondente
          orElse: () => Category(
            id: 0,
            name: entry.key,
            iconCodePoint: Icons.label.codePoint, // Usa o número do ícone
            colorValue: Colors.grey.value,        // Usa o número da cor
          ),
        );
        return CategoryExpense(category: category, amount: entry.value);
      }).toList();

      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      print("Erro ao buscar dados do relatório: $e");
    }
    notifyListeners();
  }

  Future<void> exportPdf() async {
    if (_reportData == null) return;

    // Gera o PDF usando uma classe separada
    final pdfBytes = await PdfReportGenerator.generate(
      reportData: _reportData!,
      startDate: _startDate,
      endDate: _endDate,
    );

    // Usa o pacote 'printing' para compartilhar/salvar o PDF
    await Printing.sharePdf(bytes: pdfBytes, filename: 'relatorio_financeiro.pdf');
  }
}