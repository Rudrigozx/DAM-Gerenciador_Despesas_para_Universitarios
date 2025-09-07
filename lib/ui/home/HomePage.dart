import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/database_seeder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.pushNamed('new-income');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Adicionar Renda'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.pushNamed('expenses-list');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Adicionar Despesa'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.pushNamed('new-transfer');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Adicionar Transferência'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.data_exploration_outlined),
              label: const Text('DEV: Popular Banco de Dados'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              onPressed: () async {
                // Mostra um feedback para o usuário
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Populando o banco de dados... Por favor, aguarde.')),
                );

                // Chama o seeder
                await DatabaseSeeder().seedDatabase();

                // Mostra um feedback de conclusão
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Banco de dados populado com sucesso!'), backgroundColor: Colors.green),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}