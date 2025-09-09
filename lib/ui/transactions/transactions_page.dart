

import 'package:fin_plus/Models/category.dart';
import 'package:fin_plus/Models/transaction_data.dart';
import 'package:fin_plus/Models/wallet_model.dart';
import 'package:fin_plus/ui/dashboard/dashboard_viewmodel.dart';
import 'package:fin_plus/ui/transactions/transactions_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../utils/currency_input_formatter.dart';
import '../dashboard/dashboard_viewmodel.dart';

// O Widget principal permanece o mesmo, apenas criando o Provider.
class TransactionsPage extends StatelessWidget {
  final TransactionType initialType;
  final Transaction? transactionToEdit;

  const TransactionsPage({
    super.key,
    required this.initialType,
    this.transactionToEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos o .value para prover uma instância já existente do DashboardViewModel
    return ChangeNotifierProvider(
      create: (ctx) => TransactionViewModel(
        initialType: initialType,
        transactionToEdit: transactionToEdit,
        dashboardViewModel: ctx.read<DashboardViewModel>(),
      ),
      child: const _TransactionViewBody(),
    );
  }
}

// O State agora só gerencia o TabController.
class _TransactionViewBody extends StatefulWidget {
  const _TransactionViewBody();

  @override
  State<_TransactionViewBody> createState() => _TransactionViewBodyState();
}

class _TransactionViewBodyState extends State<_TransactionViewBody> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<TransactionViewModel>();
    final tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: viewModel.currentType.index,
    );
    // Apenas passamos o controller para o ViewModel, que vai gerenciá-lo.
    viewModel.setTabController(tabController);
  }

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para reconstruir a tela quando o ViewModel notificar mudanças.
    final viewModel = context.watch<TransactionViewModel>();
    final theme = Theme.of(context);

    // Ouve as mensagens de erro do ViewModel para exibir um SnackBar
    if (viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        viewModel.errorMessage = null; // Limpa o erro após exibir
      });
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            pinned: true,
            expandedHeight: 220.0,
            backgroundColor: viewModel.headerColor,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // O TabBar é controlado pelo ViewModel
                    TabBar(
                      controller: viewModel.tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.7),
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                        insets: EdgeInsets.symmetric(horizontal: 48.0),
                      ),
                      tabs: const [
                        Tab(text: 'RECEITA'),
                        Tab(text: 'DESPESA'),
                        Tab(text: 'TRANSFERÊNCIA'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: TextFormField(
                        controller: viewModel.amountController,
                        style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        // MODIFICAÇÕES AQUI
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                        // FIM DAS MODIFICAÇÕES
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'R\$ 0,00',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          // A View apenas lê os dados do ViewModel para construir a UI
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: viewModel.descriptionController,
                    decoration: const InputDecoration(labelText: 'Descrição', icon: Icon(Icons.edit_outlined)),
                  ),
                  const SizedBox(height: 16),

                  _buildInputRow(
                    icon: viewModel.selectedCategory?.icon ?? Icons.category_outlined,
                    label: 'Categoria',
                    value: viewModel.selectedCategory?.name ?? 'Selecione',
                    onTap: () => _showCategorySelectionDialog(context, viewModel),
                  ),

                  if (viewModel.currentType == TransactionType.income)
                    _buildInputRow(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Depositar em',
                      value: viewModel.selectedDestinationAccount ?? 'Selecione',
                      onTap: () => _showWalletSelectionDialog(context, viewModel, isSource: false),
                    ),

                  if (viewModel.currentType == TransactionType.expense)
                    _buildInputRow(
                      icon: Icons.payment_outlined,
                      label: 'Pagar com',
                      value: viewModel.selectedSourceAccount ?? 'Selecione',
                      onTap: () => _showWalletSelectionDialog(context, viewModel, isSource: true),
                    ),

                  if (viewModel.currentType == TransactionType.transfer) ...[
                    _buildInputRow(
                      icon: Icons.arrow_upward_outlined,
                      label: 'Conta de Origem',
                      value: viewModel.selectedSourceAccount ?? 'Selecione',
                      onTap: () => _showWalletSelectionDialog(context, viewModel, isSource: true),
                    ),
                    _buildInputRow(
                      icon: Icons.arrow_downward_outlined,
                      label: 'Conta de Destino',
                      value: viewModel.selectedDestinationAccount ?? 'Selecione',
                      onTap: () => _showWalletSelectionDialog(context, viewModel, isSource: false),
                    ),
                  ],

                  _buildInputRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Data',
                    value: viewModel.formattedDate,
                    onTap: () => viewModel.selectDate(context),
                  ),

                  const SizedBox(height: 24),
                  Text('Repetir', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),

                  Center(
                    child: ToggleButtons(
                      isSelected: [
                        viewModel.repetition == Repetition.none,
                        viewModel.repetition == Repetition.fixed,
                        viewModel.repetition == Repetition.installment,
                      ],
                      onPressed: viewModel.setRepetition, // Ação delegada ao ViewModel
                      borderRadius: BorderRadius.circular(8.0),
                      children: const [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Não Repetir')),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Fixo')),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Parcelado')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Ação de salvar é delegada ao ViewModel
          final success = await viewModel.saveOrUpdateTransaction();
          // Se for sucesso, fecha a tela
          if (mounted && success) context.pop();
        },
        backgroundColor: viewModel.headerColor,
        child: viewModel.state == ViewState.loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.check, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Future<void> _showWalletSelectionDialog(BuildContext context, TransactionViewModel viewModel, {required bool isSource}) async {
  final selected = await showDialog<Wallet>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(isSource ? 'Pagar com' : 'Depositar em'),
      content: SizedBox(
        width: double.maxFinite,
        child: viewModel.availableWallets.isEmpty
            ? const Text('Nenhuma carteira cadastrada.')
            : ListView.builder(
          shrinkWrap: true,
          itemCount: viewModel.availableWallets.length,
          itemBuilder: (context, index) {
            final wallet = viewModel.availableWallets[index];
            return ListTile(
              leading: CircleAvatar(backgroundColor: wallet.color, child: Icon(wallet.icon, color: Colors.white, size: 20)),
              title: Text(wallet.name),
              onTap: () => Navigator.of(ctx).pop(wallet),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            // Navega para a tela de carteiras e recarrega os dados quando voltar
            context.push('/wallets').then((_) => viewModel.loadInitialData());
          },
          child: const Text('GERENCIAR CARTEIRAS'),
        )
      ],
    ),
  );

  if (selected != null) {
    viewModel.selectWallet(isSource: isSource, walletName: selected.name);
  }
}

Future<void> _showCategorySelectionDialog(BuildContext context, TransactionViewModel viewModel) async {
  final selected = await showDialog<Category>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Selecione uma Categoria'),
      content: SizedBox(
        width: double.maxFinite,
        child: viewModel.availableCategories.isEmpty
            ? const Text('Nenhuma categoria cadastrada.')
            : ListView.builder(
          shrinkWrap: true,
          itemCount: viewModel.availableCategories.length,
          itemBuilder: (context, index) {
            final category = viewModel.availableCategories[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: category.color,
                child: Icon(category.icon, color: Colors.white, size: 20),
              ),
              title: Text(category.name),
              onTap: () => Navigator.of(ctx).pop(category),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            // Navega para a tela de categorias e recarrega os dados quando voltar
            context.push('/categories').then((_) => viewModel.loadInitialData());
          },
          child: const Text('GERENCIAR'),
        )
      ],
    ),
  );

  if (selected != null) {
    viewModel.selectCategory(selected);
  }
}

Widget _buildInputRow({
  required IconData icon,
  required String label,
  required String value,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    ),
  );
}