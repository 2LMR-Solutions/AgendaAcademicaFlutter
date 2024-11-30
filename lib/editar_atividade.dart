import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pagina_inicial.dart';

class TelaEditarAtividade extends StatefulWidget {
  final Map<String, dynamic> atividade;

  const TelaEditarAtividade({super.key, required this.atividade});

  @override
  _TelaEditarAtividadeState createState() => _TelaEditarAtividadeState();
}

class _TelaEditarAtividadeState extends State<TelaEditarAtividade> {
  final TextEditingController controladorData = TextEditingController();
  final TextEditingController controladorTitulo = TextEditingController();
  final TextEditingController controladorDescricao = TextEditingController();

  String dataFormatada = "";
  List<TextEditingController> controladoresSubtarefas = [];
  List<bool> subtarefasMarcadas = [];

  @override
  void initState() {
    super.initState();
    controladorTitulo.text = widget.atividade['titulo'];
    controladorDescricao.text = widget.atividade['descricao'];
    controladorData.text = widget.atividade['data'];

    for (var subtarefa in widget.atividade['subtarefas']) {
      controladoresSubtarefas.add(TextEditingController(text: subtarefa['nome']));
      subtarefasMarcadas.add(subtarefa['marcada']);
    }
  }

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

  void aoMudarCheckbox(int indice, bool? novoValor) {
    setState(() {
      subtarefasMarcadas[indice] = novoValor ?? false;
    });
  }

  void salvarEdicao() {
    final titulo = controladorTitulo.text.trim();
    final data = controladorData.text.trim();

    if (titulo.isEmpty || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Título e data são obrigatórios!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final atividadeEditada = {
      'titulo': titulo,
      'descricao': controladorDescricao.text.trim(),
      'data': data,
      'subtarefas': List.generate(controladoresSubtarefas.length, (index) {
        return {
          'nome': controladoresSubtarefas[index].text.trim(),
          'marcada': subtarefasMarcadas[index],
        };
      }),
    };

    Navigator.pop(context, atividadeEditada); // Retorna os dados editados
  }

// Função para excluir a atividade
  void excluirAtividade() {
    showDialog(
      context: context,
      builder: (BuildContext contexto) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza de que deseja excluir esta atividade?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(contexto).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(contexto).pop();
                Navigator.pop(context, 'excluida'); // Retorna um sinal de exclusão
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
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
        title: const Text(
          "Editar Atividade",
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
                style: const TextStyle(fontFamily: 'Roboto', fontSize: 10),
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
                            setState(() {
                              controladoresSubtarefas.add(TextEditingController());
                              subtarefasMarcadas.add(false);
                            });
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
                        hintText: "Data de Entrega",
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
              // Botões "Salvar" e "Cancelar"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: salvarEdicao,
                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      elevation: 2,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text("Salvar Edição"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const PaginaInicial()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      elevation: 2,
                      backgroundColor: Colors.lightBlueAccent,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text("Cancelar"),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espaçamento entre os botões
              // Centralizando o botão de "Excluir Atividade"
              Center(
                child: ElevatedButton(
                  onPressed: excluirAtividade, // Botão de exclusão
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    elevation: 2,
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Certifique-se de que o botão tenha o tamanho mínimo necessário
                    children: const [
                      Text("Excluir Atividade"),
                      SizedBox(width: 8), // Espaço entre o texto e o ícone
                      Icon(
                        Icons.delete, // Ícone de lixeira
                        color: Colors.white, // Cor do ícone
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
