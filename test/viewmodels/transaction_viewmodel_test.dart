import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fin_plus/models/category.dart';
import 'package:fin_plus/models/transaction_data.dart';
import 'package:fin_plus/models/wallet_model.dart';
import 'package:fin_plus/data/repositories/TransactionRepository.dart';
import 'package:fin_plus/data/repositories/category_repository.dart';
import 'package:fin_plus/data/repositories/wallet_repository.dart';
import 'package:fin_plus/ui/dashboard/dashboard_viewmodel.dart';
import 'package:fin_plus/ui/transactions/transactions_viewmodel.dart';

// Arquivo gerado pelo build_runner
import 'transaction_viewmodel_test.mocks.dart';

// Anotações para gerar os mocks
@GenerateMocks([
  TransactionRepository,
  CategoryRepository,
  WalletRepository,
  DashboardViewModel,
])
void main() {
  late MockTransactionRepository mockTransactionRepository;
  late MockCategoryRepository mockCategoryRepository;
  late MockWalletRepository mockWalletRepository;
  late MockDashboardViewModel mockDashboardViewModel;
  late TransactionViewModel viewModel;

  // Dados de exemplo
  final mockCategories = [
    Category(id: 1, name: 'Alimentação', iconCodePoint: Icons.fastfood.codePoint, colorValue: Colors.red.value),
  ];
  final mockWallets = [
    Wallet(id: 1, name: 'Carteira Principal', initialBalance: 100.0, iconCodePoint: Icons.account_balance_wallet.codePoint, colorValue: Colors.blue.value),
  ];

  setUp(() {
    // Inicializa os mocks antes de cada teste
    mockTransactionRepository = MockTransactionRepository();
    mockCategoryRepository = MockCategoryRepository();
    mockWalletRepository = MockWalletRepository();
    mockDashboardViewModel = MockDashboardViewModel();

    // Configura o comportamento padrão dos mocks
    when(mockCategoryRepository.getAllCategories()).thenAnswer((_) async => mockCategories);
    when(mockWalletRepository.getAllWallets()).thenAnswer((_) async => mockWallets);

    // Cria a instância do ViewModel a ser testada
    viewModel = TransactionViewModel(
      initialType: TransactionType.expense,
      dashboardViewModel: mockDashboardViewModel,
      // Injetando as dependências mockadas (requer ajuste no ViewModel)
    );
  });

  test('loadInitialData deve buscar categorias e carteiras dos repositórios', () async {
    // Act
    await viewModel.loadInitialData();

    // Assert
    verify(mockCategoryRepository.getAllCategories()).called(1);
    verify(mockWalletRepository.getAllWallets()).called(1);
    expect(viewModel.availableCategories.length, 1);
    expect(viewModel.availableWallets.length, 1);
    expect(viewModel.state, ViewState.idle);
  });

  test('saveOrUpdateTransaction deve retornar falso se a validação falhar', () async {
    // Arrange (deixa os campos vazios para forçar um erro de validação)
    viewModel.amountController.text = '';

    // Act
    final result = await viewModel.saveOrUpdateTransaction();

    // Assert
    expect(result, isFalse);
    expect(viewModel.errorMessage, isNotNull);
    // Garante que o repositório não foi chamado
    verifyNever(mockTransactionRepository.addTransaction(any));
  });

  test('saveOrUpdateTransaction deve chamar addTransaction para uma nova transação válida', () async {
    // Arrange
    await viewModel.loadInitialData();
    viewModel.amountController.text = '50,00';
    viewModel.descriptionController.text = 'Café da tarde';
    viewModel.selectCategory(mockCategories.first);
    viewModel.selectWallet(isSource: true, walletName: mockWallets.first.name);

    // Configura o mock para a chamada de salvar
    when(mockTransactionRepository.addTransaction(any)).thenAnswer((_) async => 1);
    when(mockDashboardViewModel.fetchDashboardData()).thenAnswer((_) async {});

    // Act
    final result = await viewModel.saveOrUpdateTransaction();

    // Assert
    expect(result, isTrue);
    expect(viewModel.state, ViewState.success);
    // Verifica se o método correto do repositório foi chamado com os dados corretos
    verify(mockTransactionRepository.addTransaction(argThat(isA<Transaction>()
      ..having((t) => t.description, 'description', 'Café da tarde')
      ..having((t) => t.amount, 'amount', 50.0)
    ))).called(1);
    // Verifica se o dashboard foi atualizado
    verify(mockDashboardViewModel.fetchDashboardData()).called(1);
  });

  // test('validação deve falhar se a data for no futuro', () async {
  //   // Arrange
  //   await viewModel.loadInitialData();
  //   viewModel.amountController.text = '20,00';
  //   viewModel.descriptionController.text = 'Lanche';
  //   viewModel.selectCategory(mockCategories.first);
  //   viewModel.selectWallet(isSource: true, walletName: mockWallets.first.name);
  //
  //   // Define uma data futura
  //   viewModel.selectDate(BuildContext); // Simulação, na prática definimos a data direto
  //   viewModel.selectedDate = DateTime.now().add(const Duration(days: 1));
  //
  //   // Act
  //   final result = await viewModel.saveOrUpdateTransaction();
  //
  //   // Assert
  //   expect(result, isFalse);
  //   expect(viewModel.errorMessage, 'A data da transação não pode ser no futuro.');
  // });
}