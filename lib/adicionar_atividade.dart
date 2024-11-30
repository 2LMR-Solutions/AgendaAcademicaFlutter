// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pagina_inicial.dart';

class TelaAtividade extends StatefulWidget {
  final Function(Map<String, dynamic>) adicionarAtividade;

  const TelaAtividade({super.key, required this.adicionarAtividade});

  @override
  _TelaAtividadeState createState() => _TelaAtividadeState();
}

class _TelaAtividadeState extends State<TelaAtividade> {
  final TextEditingController controladorData = TextEditingController();
  final TextEditingController controladorTitulo = TextEditingController();
  final TextEditingController controladorDescricao = TextEditingController();

  String dataFormatada = "";
  List<TextEditingController> controladoresSubtarefas = [];
  List<bool> subtarefasMarcadas = [];

  // Função para selecionar a data
  Future<void> selecionarData(BuildContext contexto) async {
    final DateTime? selecionado = await showDatePicker(
      context: contexto,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selecionado != null) {
      setState(() {
        dataFormatada = DateFormat('dd/MM/yyyy').format(selecionado);
        controladorData.text = dataFormatada;
      });
    }
  }

  // Função chamada quando o estado do checkbox mudar
  void aoMudarCheckbox(int indice, bool? novoValor) {
    setState(() {
      subtarefasMarcadas[indice] = novoValor ?? false;
    });
  }

  // Função para adicionar uma nova subtarefa
  void adicionarSubtarefa() {
    setState(() {
      controladoresSubtarefas.add(TextEditingController());
      subtarefasMarcadas.add(false);
    });
  }

 // Função para salvar atividade e redirecionar
  void salvarAtividade() {
    String titulo = controladorTitulo.text.trim();
    String descricao = controladorDescricao.text.trim();
    String data = dataFormatada.trim();

    if (titulo.isEmpty || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Título e data são obrigatórios!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    List<Map<String, dynamic>> subtarefas = [];
    for (int i = 0; i < controladoresSubtarefas.length; i++) {
      if (controladoresSubtarefas[i].text.isNotEmpty) {
        subtarefas.add({
          'nome': controladoresSubtarefas[i].text,
          'marcada': subtarefasMarcadas[i],
        });
      }
    }

    // Dados da nova atividade
    Map<String, dynamic> novaAtividade = {
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
      'subtarefas': subtarefas,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Atividade salva com sucesso!')),
    );

    // Redirecionar para a tela inicial após o feedback
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // Retorna à tela inicial
      // Adiciona à lista e retorna para a página inicial
      widget.adicionarAtividade(novaAtividade);
    });
  }


  @override
  void initState() {
    super.initState();
    adicionarSubtarefa(); // Adiciona a primeira subtarefa inicialmente
  }

  @override
  void dispose() {
    // Dispose dos controladores para evitar vazamento de memória
    controladorTitulo.dispose();
    controladorDescricao.dispose();
    controladorData.dispose();
    for (var controlador in controladoresSubtarefas) {
      controlador.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(contexto);
          },
        ),
        backgroundColor: const Color.fromRGBO(181, 33, 226, 1),
        elevation: 4,
        shadowColor: Colors.grey,
        title: const Text(
          "Adicionar Atividade",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controladorTitulo,
                style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
                decoration: const InputDecoration(
                  hintText: "Título",
                  hintStyle: TextStyle(color: Color(0xFFb521e2)),
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controladorDescricao,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10,
                ),
                decoration: const InputDecoration(
                  hintText: "Descrição",
                  hintStyle: TextStyle(color: Color(0xFFb521e2)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb521e2))),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              const Text(
                "Componentes da Atividade:",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Roboto",
                ),
              ),
              const SizedBox(height: 10),
              // Lista de subtarefas
              for (int i = 0; i < controladoresSubtarefas.length; i++)
                Row(
                  children: [
                    Checkbox(
                      value: subtarefasMarcadas[i],
                      onChanged: (bool? novoValor) {
                        aoMudarCheckbox(i, novoValor);
                      },
                      activeColor: const Color(0xFFb521e2),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controladoresSubtarefas[i],
                        style: const TextStyle(fontSize: 10),
                        decoration: const InputDecoration(
                          hintText: "--Exemplo Subtarefa--",
                          hintStyle: TextStyle(color: Color(0xFFb521e2)),
                          border: InputBorder.none,
                        ),
                        onChanged: (texto) {
                          if (texto.isNotEmpty &&
                              i == controladoresSubtarefas.length - 1) {
                            adicionarSubtarefa();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              const Divider(color: Color(0xFFb521e2)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: controladorData,
                      readOnly: true,
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Data de entrega",
                        hintStyle:
                            const TextStyle(color: Color(0xFF3e3e3e)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFb521e2))),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => selecionarData(contexto),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: salvarAtividade,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    elevation: 2,
                  ),
                  child: const Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
