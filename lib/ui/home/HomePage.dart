import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Login/CadastroView.dart';

import '../../utils/database_seeder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                // Página 1
                Container(
                  color: Colors.yellow.withOpacity(0.77),
                  child:  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logos/Logo_fin.png',
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'Seja Bem-vindo ao Fin+!',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        SizedBox(height: 5),
                        Text("O app financeiro perfeito para universitários"),
                        SizedBox(height: 15),
                        Text('Deslize →',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        )

                      ],
                    ),
                  ),
                ),

                // Página 2
                Container(
                  color: Colors.yellow.withOpacity(0.77),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                        'assets/logos/M.png',
                          height: 252,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'Tenha controle sobre sua vida financeira',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),

                      ],
                    ),
                  ),
                ),

                // Página 3 (com botão)
                Container(
                  color: Colors.yellow.withOpacity(0.77),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                        'assets/logos/m12.png',
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 10),
                        const Text(
                          'Enquanto mantém o rítmo dos estudos',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        SizedBox(height: 22),

                        // 🔹 Botão apenas na terceira página
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CriarConta(),
                              ),
                            );
                          },
                          child: const Text("Vamos começar"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Indicadores de página (bolinhas)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(6),
                width: _currentPage == index ? 20 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.indigo : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
