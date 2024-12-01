import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

//TextInputFormatter para limitar a entrada a letras e espaços
class LetrasInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regExp = RegExp(r'^[a-zA-Z\s]*$'); //apenas letras e espaços
    if (regExp.hasMatch(newValue.text)) {
      return newValue; //permite o valor se válido
    } else {
      return oldValue; //mantém o valor antigo se inválido
    }
  }
}

class _PerfilPageState extends State<PerfilPage> {
  final TextEditingController _nomeController = TextEditingController();
  String? _nome;
  String? _fotoPerfil;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('user_name') ?? 'Usuário';
      _fotoPerfil = prefs.getString('foto_perfil'); //pode ser nulo
      _nomeController.text = _nome!;
    });
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nomeController.text);

    if (_fotoPerfil != null) {
      //se tiver uma foto, salva o caminho
      await prefs.setString('foto_perfil', _fotoPerfil!);
    } else {
      //se não tiver foto, remove a chave 'foto_perfil'
      await prefs.remove('foto_perfil');
    }

    setState(() {
      _nome = _nomeController.text;
    });
  }

  Future<void> _selecionarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagemSelecionada = await picker.pickImage(
      source: ImageSource.gallery, //ou ImageSource.camera para câmera
      maxWidth: 300,
      maxHeight: 300,
      imageQuality: 85, //qualidade da imagem (0-100)
    );

    if (imagemSelecionada != null) {
      setState(() {
        _fotoPerfil = imagemSelecionada.path; //caminho da imagem
      });
    }
  }

  Future<void> _removerFoto() async {
    setState(() {
      _fotoPerfil = null; //define como nulo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        elevation: 10,
        shadowColor: Colors.grey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 24,
          color: const Color.fromRGBO(181, 33, 226, 1),
          onPressed: () {
            //voltar à página anterior
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home'); //navegar para a home se não houver contexto anterior
            }
          },
        ),
        title: const Text(
          'Perfil',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(181, 33, 226, 1),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Foto de Perfil
            GestureDetector(
              onTap: _selecionarFoto,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _fotoPerfil != null
                    ? FileImage(File(_fotoPerfil!)) as ImageProvider
                    : const AssetImage('lib/assets/images/default_avatar.png'),
                child: _fotoPerfil == null
                    ? const Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.white70,
                )
                    : null,
              ),
            ),
            const SizedBox(height: 10),

            //botão para remover a foto
            TextButton(
              onPressed: _removerFoto,
              child: const Text(
                'Remover Foto',
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),

            //campo para alterar o nome
            TextField(
              controller: _nomeController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(15), //limite de 15 caracteres
                LetrasInputFormatter(), //apenas letras e espaços
              ],
              decoration: InputDecoration(
                labelText: 'Seu nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            //botão para salvar as alterações
            ElevatedButton(
              onPressed: () async {
                if (_nomeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, digite um nome válido!'),
                    ),
                  );
                } else {
                  await _salvarDados();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alterações salvas!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
