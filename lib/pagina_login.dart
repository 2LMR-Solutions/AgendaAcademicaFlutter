import 'package:flutter/material.dart';
import 'pagina_inicial.dart'; // Importe a página inicial

class NomeUsuario extends StatefulWidget {
  const NomeUsuario({super.key});

  @override
  State<NomeUsuario> createState() => _NomeUsuarioState();
}

class _NomeUsuarioState extends State<NomeUsuario> {
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário
  final TextEditingController _nomeController = TextEditingController(); // Controlador para o campo de texto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple, // Fundo roxo
        child: Center(
          child: Form(
            key: _formKey, // Conecta o formulário à chave
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Texto de boas-vindas
                const Text(
                  "Bem-vindo estudante!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20), // Espaçamento entre o texto e o campo

                // Campo de texto
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      hintText: "Digite seu nome",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    // Validação do campo
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu nome.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20), // Espaçamento entre o campo e o botão

                // Botão "Entrar"
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Navegar para a página inicial passando o nome como parâmetro
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaginaInicial(
                            nome: _nomeController.text, // Passa o nome digitado
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Entrar",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
