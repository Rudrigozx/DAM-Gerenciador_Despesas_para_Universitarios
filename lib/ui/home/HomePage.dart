import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/ui/Login/CadastroView.dart';

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
                  color: Colors.green.withOpacity(0.9),
                  child:  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logos/m17.png',
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'Página 1',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Text('Deslize →'),
                      ],
                    ),
                  ),
                ),

                // Página 2
                Container(
                  color: Colors.green.withOpacity(0.9),
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
                          'Página 2',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Text('Carrossel horizontal aqui'),
                      ],
                    ),
                  ),
                ),

                // Página 3 (com botão)
                Container(
                  color: Colors.green.withOpacity(0.9),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                        'assets/logos/m12.png',
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        const Text(
                          'Página 3',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        const Text('Fim do exemplo'),
                        SizedBox(height: 32),

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
