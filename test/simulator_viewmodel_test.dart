import 'package:fin_plus/ui/simulator/simulator_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.mocks.dart';

// ✅ O teste inteiro precisa estar dentro de uma função main()
void main() {
  group('SimulatorViewModel', () {
    late SimulatorViewModel viewModel;
    late MockSimulationRepository mockRepository;

    setUp(() {
      mockRepository = MockSimulationRepository();
      viewModel = SimulatorViewModel(repositoryForTest: mockRepository);
    });

    test('deve calcular juros compostos corretamente e salvar no histórico', () async {
      // ARRANGE
      when(mockRepository.saveSimulation(any)).thenAnswer((_) async {});

      viewModel.initialAmountController.text = '1000';
      viewModel.monthlyContributionController.text = '100';
      viewModel.annualRateController.text = '16.9';
      viewModel.periodController.text = '24';

      // ACT
      await viewModel.calculateAndSaveSimulation();

      // ASSERT
      expect(viewModel.totalInvested, 3400.00);
      expect(viewModel.totalInterest, closeTo(664.89, 0.01));
      expect(viewModel.finalAmount, closeTo(4064.89, 0.01));
      verify(mockRepository.saveSimulation(any)).called(1);
    });
  });
}