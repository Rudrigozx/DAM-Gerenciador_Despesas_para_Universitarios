import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/logos/Logo_fin.png',
              height: 170,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 1),
            const Text("Criar uma conta", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Insira seu email para se cadastrar no aplicativo", textAlign: TextAlign.center),
            const SizedBox(height: 5),


            const SizedBox(height: 50),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "E-mail",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Aqui vai a lógica de login
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("login realizado!")),
                );
              },
              child: const Text("Entrar"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Não tem uma conta? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // volta para a tela de cadastro
                  },
                  child: const Text(
                    "Cadastre-se!",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
