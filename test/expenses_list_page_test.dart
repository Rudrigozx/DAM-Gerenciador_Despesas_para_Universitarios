import 'package:fin_plus/ui/expenses_list/expenses_list_page.dart';
import 'package:fin_plus/ui/expenses_list/expenses_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:fin_plus/models/transaction_data.dart';

// Mock do ViewModel
class MockExpensesListViewModel extends Mock implements ExpensesListViewModel {}


void main() {
  late MockExpensesListViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockExpensesListViewModel();
  });

  // Função auxiliar para criar o widget a ser testado
  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<ExpensesListViewModel>.value(
      value: mockViewModel,
      child: const MaterialApp(
        home: ExpensesListPage(),
      ),
    );
  }

  testWidgets('Deve exibir CircularProgressIndicator enquanto carrega', (WidgetTester tester) async {
    // Arrange
    when(mockViewModel.isLoading).thenReturn(true);
    when(mockViewModel.transactions).thenReturn([]);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Deve exibir mensagem quando a lista de transações está vazia', (WidgetTester tester) async {
    // Arrange
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.transactions).thenReturn([]);
    when(mockViewModel.selectedMonth).thenReturn(DateTime.now());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Nenhuma transação encontrada para este mês.'), findsOneWidget);
  });

  testWidgets('Deve exibir a lista de transações quando houver dados', (WidgetTester tester) async {
    // Lista de transações de exemplo
    final mockTransactions = [
      Transaction(id: 1, description: 'Almoço', amount: 25.0, category: 'Alimentação', type: TransactionType.expense, date: DateTime(2025, 9, 1)),
      Transaction(id: 2, description: 'Café', amount: 5.0, category: 'Alimentação', type: TransactionType.expense, date: DateTime(2025, 9, 2)),
    ];

// Agrupamento esperado
    final mockGroupedTransactions = {
      DateTime(2025, 9, 1): [mockTransactions[0]],
      DateTime(2025, 9, 2): [mockTransactions[1]],
    };

    // Arrange
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.transactions).thenReturn(mockTransactions);
    when(mockViewModel.groupedTransactions).thenReturn(mockGroupedTransactions);
    when(mockViewModel.selectedMonth).thenReturn(DateTime.now());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Almoço'), findsOneWidget);
    expect(find.text('Café'), findsOneWidget);
    expect(find.text('R\$ 25.00'), findsOneWidget);
  });

  testWidgets('Deve chamar changeMonth no ViewModel ao tocar nos botões de navegação do mês', (WidgetTester tester) async {
    // Arrange
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.transactions).thenReturn([]);
    when(mockViewModel.selectedMonth).thenReturn(DateTime(2025, 9, 1));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Simula o toque no botão de avançar mês
    await tester.tap(find.byIcon(Icons.chevron_right));
    // Simula o toque no botão de voltar mês
    await tester.tap(find.byIcon(Icons.chevron_left));

    // Assert
    verify(mockViewModel.changeMonth(1)).called(1);
    verify(mockViewModel.changeMonth(-1)).called(1);
  });
}