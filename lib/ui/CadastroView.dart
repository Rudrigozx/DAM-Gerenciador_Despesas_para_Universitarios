import 'package:fin_plus/ui/UsuarioViewModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
//import 'auth_service.dart'; onde está o método signInWithGoogle()


class CriarConta extends StatefulWidget {
  const CriarConta({super.key});

  @override
  State<CriarConta> createState() =>
      CadastroView();
}

class CadastroView extends State<CriarConta> {
  final formKey = GlobalKey<FormState>();
  final UsuarioViewModel _usuarioViewModel = UsuarioViewModel();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                validator: (_emailController) {
                  if (_emailController == null || _emailController.isEmpty) {
                    return 'O campo e-mail é obrigatório';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController)) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 9),

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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O campo senha é obrigatório';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {

                      _usuarioViewModel.cadastrar(
                        _nomeController.text,
                        _emailController.text,
                        _senhaController.text,
                        1,
                      );
                      context.go('/navigator');
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

