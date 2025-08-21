//TransactionsPage.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../Models/transaction_data.dart';
import '../../data/repositories/TransactionRepository.dart';

// Enum para o controle de repetição
enum Repetition { none, fixed, installment }

class TransactionsPage extends StatefulWidget {
  final TransactionType initialType;
  final Transaction? transactionToEdit; // Recebe a transação para edição

  const TransactionsPage({
    super.key,
    required this.initialType,
    this.transactionToEdit,
  });

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with SingleTickerProviderStateMixin {
  final TransactionRepository _repository = TransactionRepository();

  // Controllers
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  late TabController _tabController;

  // Variáveis de Estado
  late TransactionType _currentType;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String? _selectedSourceAccount;
  String? _selectedDestinationAccount;
  Repetition _repetition = Repetition.none;
  bool _isLoading = false;

  // Dados Mock (simulados)
  final List<String> categories = ['Transporte', 'Material', 'Aluguel', 'Crédito', 'Alimentação', 'Salário', 'Lazer'];
  final List<String> accounts = ['Carteira', 'Conta Corrente', 'Cartão de Crédito', 'Reserva'];

  @override
  void initState() {
    super.initState();
    _currentType = widget.initialType;

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _currentType.index,
    );
    _tabController.addListener(_handleTabSelection);

    if (widget.transactionToEdit != null) {
      final tx = widget.transactionToEdit!;
      _currentType = tx.type;
      descriptionController.text = tx.description;
      amountController.text = tx.amount.toStringAsFixed(2).replaceAll('.', ',');
      _selectedDate = tx.date;
      _selectedCategory = tx.category;
      _selectedSourceAccount = tx.sourceAccount;
      _selectedDestinationAccount = tx.destinationAccount;
      _tabController.index = tx.type.index; // Sincroniza a aba visualmente
    }
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentType = TransactionType.values[_tabController.index];
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  // --- Getters para Lógica de UI ---
  Color get headerColor {
    switch (_currentType) {
      case TransactionType.income: return Colors.green;
      case TransactionType.expense: return Colors.red;
      case TransactionType.transfer: return Colors.blue;
    }
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    if (selectedDay == today) return 'Hoje';
    if (selectedDay == yesterday) return 'Ontem';
    return DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  // --- Funções de Ação ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> saveOrUpdateTransaction() async {
    setState(() => _isLoading = true);

    final amount = double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0.0;

    // Cria o objeto com os dados atuais da tela
    final transaction = Transaction(
      id: widget.transactionToEdit?.id, // Usa o ID existente se estiver editando
      description: descriptionController.text,
      amount: amount,
      category: _selectedCategory ?? 'Nenhuma',
      type: _currentType,
      date: _selectedDate,
      sourceAccount: _selectedSourceAccount,
      destinationAccount: _selectedDestinationAccount,
    );

    // Decide se deve criar um novo ou atualizar um existente
    if (widget.transactionToEdit == null) {
      await _repository.addTransaction(transaction);
    } else {
      await _repository.updateTransaction(transaction);
    }

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            pinned: true,
            expandedHeight: 220.0,
            backgroundColor: headerColor,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TabBar(
                      controller: _tabController,
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
                        controller: amountController,
                        style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0,00',
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixText: 'R\$ ',
                          prefixStyle: TextStyle(fontSize: 24, color: Colors.white70, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descrição', icon: Icon(Icons.edit_outlined)),
                  ),
                  const SizedBox(height: 16),

                  _buildInputRow(
                    icon: Icons.category_outlined,
                    label: 'Categoria',
                    value: _selectedCategory ?? 'Selecione',
                    onTap: () { /* TODO: Implementar seletor de categoria */ },
                  ),

                  if (_currentType == TransactionType.income)
                    _buildInputRow(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Depositar em',
                      value: _selectedDestinationAccount ?? 'Selecione',
                      onTap: () { /* TODO: Implementar seletor de conta */ },
                    ),

                  if (_currentType == TransactionType.expense)
                    _buildInputRow(
                      icon: Icons.payment_outlined,
                      label: 'Pagar com',
                      value: _selectedSourceAccount ?? 'Selecione',
                      onTap: () { /* TODO: Implementar seletor de conta */ },
                    ),

                  if (_currentType == TransactionType.transfer) ...[
                    _buildInputRow(
                      icon: Icons.arrow_upward_outlined,
                      label: 'Conta de Origem',
                      value: _selectedSourceAccount ?? 'Selecione',
                      onTap: () { /* TODO: Implementar seletor de conta */ },
                    ),
                    _buildInputRow(
                      icon: Icons.arrow_downward_outlined,
                      label: 'Conta de Destino',
                      value: _selectedDestinationAccount ?? 'Selecione',
                      onTap: () { /* TODO: Implementar seletor de conta */ },
                    ),
                  ],

                  _buildInputRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Data',
                    value: formattedDate,
                    onTap: () => _selectDate(context),
                  ),

                  const SizedBox(height: 24),
                  Text('Repetir', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),

                  Center(
                    child: ToggleButtons(
                      isSelected: [
                        _repetition == Repetition.none,
                        _repetition == Repetition.fixed,
                        _repetition == Repetition.installment,
                      ],
                      onPressed: (index) => setState(() => _repetition = Repetition.values[index]),
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
        onPressed: _isLoading ? null : saveOrUpdateTransaction,
        backgroundColor: headerColor,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.check, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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
}