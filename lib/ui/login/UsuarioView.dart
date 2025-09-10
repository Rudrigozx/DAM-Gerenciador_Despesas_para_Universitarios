import 'package:flutter/material.dart';
import '../notifications/notification_view.dart';
import '/Models/Usuario.dart';
import 'package:provider/provider.dart';
import 'CadastroView.dart';
import 'LoginView.dart';
import 'UsuarioViewModel.dart';

class UsuarioView extends StatefulWidget {
  @override
  State<UsuarioView> createState() => UsuarioState();
}

class UsuarioState extends State<UsuarioView> {
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usuarioViewModel = context.watch<UsuarioViewModel>();

    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: const Text(
                "Ajustes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            FutureBuilder<Usuario?>(
              future: usuarioViewModel.buscarPorId(1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data != null) {
                  final usuario = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("assets/images/profile.png"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(usuario.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(usuario.email, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () {
                            _nomeController.text = usuario.nome;
                            _idadeController.text = usuario.idade;
                            _emailController.text = usuario.email;
                            _senhaController.text = usuario.senha;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Editar Perfil"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(controller: _nomeController, decoration: const InputDecoration(labelText: "Nome")),
                                        TextFormField(controller: _idadeController, decoration: const InputDecoration(labelText: "Idade")),
                                        TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
                                        TextFormField(controller: _senhaController, obscureText: true, decoration: const InputDecoration(labelText: "Senha")),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
                                    ElevatedButton(
                                      onPressed: () {
                                        usuarioViewModel.atualizarUsuario(_nomeController.text, _idadeController.text, _emailController.text, _senhaController.text);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Salvar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),

                      ],
                    ),
                  );
                } else {
                  return const Text("Nenhum usuário encontrado.", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic));
                }
              },
            ),
            const Divider(),
            // Conta
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Conta", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Alterar Senha"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts_outlined),
              title: const Text("Gerenciar Contas"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginView(),
                  ),
                );
              },
            ),
            const Divider(),
            // Preferências
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Preferências", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text("Moeda"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginView(),
                  ),
                );
              },
            ),
            SizedBox(height: 270),
            // Rodapé
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: const [
                  Text("Termos de Serviço", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  Text("Política de Privacidade", style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
