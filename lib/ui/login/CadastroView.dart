import 'package:fin_plus/ui/Login/UsuarioViewModel.dart';
import 'package:fin_plus/ui/Login/UsuarioView.dart';

import 'package:fin_plus/ui/home/HomePage.dart';
import 'package:fin_plus/ui/login/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
//import 'auth_service.dart'; onde está o método signInWithGoogle()


class CriarConta extends StatefulWidget {
  const CriarConta({super.key});

  @override
  State<CriarConta> createState() =>
      CadastroView();
}

class CadastroView extends State<CriarConta> {
  final formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usuarioViewModel = Provider.of<UsuarioViewModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(title: const Text('')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form( // <-- Form aqui
            key: formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/logos/Logo_fin.png',
                  height: 170,
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 15),
                const Text("Criar uma conta",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Text("Insira seu email para se cadastrar no aplicativo",
                    textAlign: TextAlign.center),
                const SizedBox(height: 5),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: "Nome completo",
                          border: OutlineInputBorder(),
                        ),
                        validator: (_nomeController) => usuarioViewModel.validaNome(_nomeController),
                      ),
                    ),
                    const SizedBox(width: 10), // espaço entre os campos
                    SizedBox(
                      width: 140,
                      child: TextFormField(
                        controller: _idadeController,
                        decoration: InputDecoration(
                          labelText: "Idade",
                          border: OutlineInputBorder(),
                        ),
                        validator: (_idadeController) => usuarioViewModel.validaIdade(_idadeController),
                      ),
                    ),
                  ],
                ),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (_emailController) =>
                      usuarioViewModel.validarEmail(_emailController),

                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                  validator: (_senhaController) =>
                      usuarioViewModel.validaSenha(_senhaController),
                ),

                const SizedBox(height: 20),

                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          usuarioViewModel.cadastrar(
                            _nomeController.text,
                            _idadeController.text,
                            _emailController.text,
                            _senhaController.text,
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  UsuarioView())
                          );
                        }
                      },
                      child: const Text('Cadastrar', style: TextStyle(color: Colors.white)),
                    )
                ),

                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('ou', style: TextStyle(color: Colors.black38)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 10),

                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        /* final user = await authService.signInWithGoogle();
                      if (user != null) {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login com Google cancelado ou falhou')),
                        );
                      }*/
                      },
                      icon: const FaIcon(FontAwesomeIcons.google),
                      label: const Text('Entrar com o Google'),
                    )
                ),

                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Já tem uma conta? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                        );
                      },
                      child: Text(
                        "Faça login!",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 12),

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
        )
    );
  }
}
