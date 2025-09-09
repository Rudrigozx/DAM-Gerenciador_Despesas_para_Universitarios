import 'package:flutter/material.dart';
import 'package:fin_plus/ui/Login/UsuarioViewModel.dart';
import 'package:provider/provider.dart';

import 'UsuarioView.dart';


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();
    final usuarioViewModel = Provider.of<UsuarioViewModel>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Form(
      key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/logos/Logo_fin.png',
              height: 50,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 1),
            const Text("Fazer Login", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Insira suas credenciais para entrar no aplicativo", textAlign: TextAlign.center),
            const SizedBox(height: 5),


            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "E-mail",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (_emailController) =>
                  usuarioViewModel.validarEmail(_emailController),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: senhaController,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (_senhaController) =>
                  usuarioViewModel.validaSenha(_senhaController),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  usuarioViewModel.login(
                    emailController.text,
                    senhaController.text,
                  );

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UsuarioView())
                  );
                }
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
                    Navigator.pop(context);
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
            const SizedBox(height: 42),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black54, fontSize: 14),
                children: [
                  const TextSpan(
                      text: 'Ao clicar em continuar, você concorda com os nossos '),
                  TextSpan(
                    text: 'Termos de Serviço',
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' e com a '),
                  TextSpan(
                    text: 'Política de Privacidade',
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
