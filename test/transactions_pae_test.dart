import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:fin_plus/models/category.dart';
import 'package:fin_plus/models/transaction_data.dart';
import 'package:fin_plus/ui/dashboard/dashboard_viewmodel.dart';
import 'package:fin_plus/ui/transactions/transactions_viewmodel.dart';
import 'package:fin_plus/ui/transactions/transactions_page.dart';

import 'transactions_pae_test.mocks.dart';

// Anotações para gerar os mocks
@GenerateMocks([TransactionViewModel, DashboardViewModel])
void main() {
  late MockTransactionViewModel mockViewModel;
  late MockDashboardViewModel mockDashboardViewModel;

  setUp(() {
    mockViewModel = MockTransactionViewModel();
    mockDashboardViewModel = MockDashboardViewModel();

    // Configuração padrão para os getters do mock
    when(mockViewModel.headerColor).thenReturn(Colors.red);
    when(mockViewModel.amountController).thenReturn(TextEditingController());
    when(mockViewModel.descriptionController).thenReturn(TextEditingController());
    when(mockViewModel.state).thenReturn(ViewState.idle);
    when(mockViewModel.currentType).thenReturn(TransactionType.expense);
    when(mockViewModel.formattedDate).thenReturn('Hoje');
    when(mockViewModel.availableCategories).thenReturn([
      Category(id: 1, name: 'Alimentação', iconCodePoint: Icons.fastfood.codePoint, colorValue: Colors.red.value)
    ]);
    when(mockViewModel.selectedCategory).thenReturn(null);
  });

  // Função auxiliar para montar o widget de teste
  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DashboardViewModel>.value(value: mockDashboardViewModel),
        ChangeNotifierProvider<TransactionViewModel>.value(value: mockViewModel),
      ],
      child: const MaterialApp(
        home: TransactionsPage(initialType: TransactionType.expense),
      ),
    );
  }

  testWidgets('Deve construir a UI inicial corretamente para uma nova despesa', (tester) async {
    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('DESPESA'), findsOneWidget);
    expect(find.byType(SliverAppBar), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget); // Ícone da descrição
    expect(find.byIcon(Icons.category_outlined), findsOneWidget); // Ícone da categoria
    expect(find.byIcon(Icons.check), findsOneWidget); // Ícone do FAB
  });

  testWidgets('Deve mostrar CircularProgressIndicator no FAB quando o estado for loading', (tester) async {
    // Arrange
    when(mockViewModel.state).thenReturn(ViewState.loading);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Reconstrói o widget com o novo estado

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('Deve chamar saveOrUpdateTransaction ao tocar no FAB', (tester) async {
    // Arrange
    when(mockViewModel.saveOrUpdateTransaction()).thenAnswer((_) async => true);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Simula o preenchimento dos campos (essencial para o widget ser encontrado)
    await tester.enterText(find.byType(TextFormField).first, 'R\$ 50,00');
    await tester.enterText(find.byType(TextFormField).last, 'Teste de despesa');

    // Toca no botão de salvar
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    // Assert
    verify(mockViewModel.saveOrUpdateTransaction()).called(1);
  });

  testWidgets('Deve exibir SnackBar quando houver uma mensagem de erro no ViewModel', (tester) async {
    // Arrange
    when(mockViewModel.errorMessage).thenReturn('Campo obrigatório');

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Espera o próximo frame para o SnackBar aparecer

    // Assert
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Campo obrigatório'), findsOneWidget);
  });
}