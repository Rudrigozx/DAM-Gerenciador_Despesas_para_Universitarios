import 'package:flutter/material.dart';
import '../../Models/category.dart';
import '../../data/repositories/category_repository.dart';
import '../widgets/color_picker.dart';
import '../widgets/icon_picker.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final CategoryRepository _repository = CategoryRepository();
  bool _isLoading = true;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    setState(() => _isLoading = true);
    final categories = await _repository.getAllCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  Future<void> _deleteCategory(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir esta categoria?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('CANCELAR')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('EXCLUIR')),
        ],
      ),
    );

    if (confirmed == true) {
      await _repository.deleteCategory(id);
      loadCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Categorias'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: category.color,
              child: Icon(category.icon, color: Colors.white, size: 20),
            ),
            title: Text(category.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteCategory(category.id!),
            ),
            onTap: () {
              _showCategoryFormDialog(category: category).then((_) => loadCategories());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategoryFormDialog().then((_) => loadCategories());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- FORMULÁRIO DE ADIÇÃO/EDIÇÃO ---
  Future<void> _showCategoryFormDialog({Category? category}) async {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');

    // Estado do formulário
    IconData selectedIcon = category?.icon ?? Icons.shopping_cart;
    Color selectedColor = category?.color ?? Colors.blue;

    // // Listas de opções
    final List<IconData> icons = [
      Icons.shopping_cart, Icons.restaurant, Icons.local_gas_station, Icons.lightbulb,
      Icons.movie, Icons.school, Icons.home, Icons.flight, Icons.phone_android,
      Icons.health_and_safety, Icons.attach_money, Icons.receipt_long, Icons.work,
      Icons.fitness_center, Icons.pets, Icons.book, Icons.fastfood, Icons.electric_car,
    ];
    final List<Color> colors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal,
      Colors.pink, Colors.amber, Colors.deepPurple, Colors.cyan, Colors.brown, Colors.indigo,
    ];

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar Categoria' : 'Nova Categoria'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nome da Categoria'),
                      autofocus: true,
                    ),
                    const SizedBox(height: 20),
                    Text('Ícone', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    IconPicker(
                      selectedIcon: selectedIcon,
                      onIconSelected: (icon) => setDialogState(() => selectedIcon = icon),
                      availableIcons: icons,
                    ),
                    const SizedBox(height: 20),
                    Text('Cor', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    ColorPicker(
                      selectedColor: selectedColor,
                      onColorSelected: (color) => setDialogState(() => selectedColor = color),
                      availableColors: colors,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('CANCELAR')),
                ElevatedButton(
                  onPressed: () { /* ... (lógica de salvar inalterada) ... */ },
                  child: const Text('SALVAR'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- WIDGETS AUXILIARES PARA O FORMULÁRIO (AGORA COM INDICAÇÃO DE SELEÇÃO) ---
  Widget _buildIconPicker(IconData currentSelectedIcon, ValueChanged<IconData> onIconSelected) {
    final List<IconData> icons = [
      Icons.shopping_cart, Icons.restaurant, Icons.local_gas_station,
      Icons.lightbulb, Icons.movie, Icons.school, Icons.home,
      Icons.flight, Icons.phone_android, Icons.health_and_safety,
      Icons.attach_money, Icons.receipt_long, Icons.work, Icons.fitness_center,
      Icons.pets, Icons.book, Icons.fastfood, Icons.electric_car,
    ];
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: icons.map((icon) {
        final isSelected = currentSelectedIcon == icon;
        return GestureDetector( // Usamos GestureDetector para um controle mais fino do onTap
          onTap: () => onIconSelected(icon),
          child: Container(
            padding: const EdgeInsets.all(4), // Espaço para a borda
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent, // Fundo levemente azul se selecionado
              borderRadius: BorderRadius.circular(28), // Bordas arredondadas para o Container
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: isSelected ? 2.0 : 0.0,
              ),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1), // Cor de fundo do ícone
              child: Icon(icon, size: 28, color: isSelected ? Colors.blue : Colors.grey[700]),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorPicker(Color currentSelectedColor, ValueChanged<Color> onColorSelected) {
    final List<Color> colors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple,
      Colors.teal, Colors.pink, Colors.amber, Colors.deepPurple,
      Colors.cyan, Colors.brown, Colors.indigo, Colors.grey, Colors.black
    ];
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: colors.map((color) {
        final isSelected = currentSelectedColor.value == color.value; // Compara o valor da cor
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            padding: const EdgeInsets.all(4), // Espaço para a borda
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.2) : Colors.transparent, // Fundo levemente transparente da cor se selecionado
              shape: BoxShape.circle, // Forma circular para o Container da borda
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent, // Borda azul para indicar seleção
                width: isSelected ? 2.0 : 0.0,
              ),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: color,
            ),
          ),
        );
      }).toList(),
    );
  }
}