import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calendario.dart';
import 'perfil.dart';
import 'adicionar_atividade.dart';
import 'package:intl/intl.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  late String nome = 'Usuário'; // Nome padrão caso não seja encontrado nos SharedPreferences
  List<Map<String, dynamic>> atividades = [];

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Carregar o nome do usuário ao inicializar
  }

  void mostrarDetalhesAtividade(BuildContext context, Map<String, dynamic> atividade) {
    showDialog(
      context: context,
      builder: (context) {
        final subtarefas = atividade['subtarefas'] as List<Map<String, dynamic>>;

        return AlertDialog(
          title: Text(atividade['titulo']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descrição:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(atividade['descricao']),
                const SizedBox(height: 10),
                Text(
                  'Data final:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(atividade['data']),
                const Divider(),
                Text(
                  'Subtarefas:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...subtarefas.map((subtarefa) {
                  return ListTile(
                    leading: Icon(
                      subtarefa['marcada'] ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Colors.blue,
                    ),
                    title: Text(subtarefa['nome']),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  // Método para carregar o nome do SharedPreferences
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nome = prefs.getString('user_name') ?? 'Usuário';
    });
  }

  // Função para ordenar as atividades pela data
  void ordenarAtividades() {
    atividades.sort((a, b) {
      DateTime dataA = DateFormat('dd/MM/yyyy').parse(a['data']);
      DateTime dataB = DateFormat('dd/MM/yyyy').parse(b['data']);
      return dataA.isBefore(dataB) ? -1 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    ordenarAtividades(); // Ordena as atividades sempre que o widget for reconstruído

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(181, 33, 226, 1),
        elevation: 10,
        shadowColor: Colors.grey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
        toolbarHeight: 170,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ajusta o espaçamento
          children: <Widget>[
            // Coloca o "Olá," e o nome do usuário em uma coluna
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Olá,', // Texto fixo
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  nome, // Nome do usuário
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Ícone de perfil
            IconButton(
              icon: const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 70,
              ),
              onPressed: () {
                // Ação do botão (opcional)
              },
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            // Voltar para a tela de login
            Navigator.pop(context);
          },
        ),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220, minHeight: 56.0),
        child: Column(
          children: [
            // Texto fixo
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft, // Alinha à esquerda
                child: Text(
                  'Atividades',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // Lista rolável
            Expanded(
              child: atividades.isEmpty
                  ? const Center(
                child: Text(
                  'Nenhuma atividade cadastrada',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
                  : ListView.builder(
                itemCount: atividades.length,
                itemBuilder: (context, index) {
                  final atividade = atividades[index];

                  return ListTile(
                    leading: const Icon(Icons.add_task, color: Colors.green),
                    title: Text(
                      atividade['titulo'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${atividade['descricao']}\nData final: ${atividade['data']}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.more_horiz),
                    onTap: () {
                      // Abre o AlertDialog para exibir as subtarefas
                      mostrarDetalhesAtividade(context, atividade);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaAtividade(
                adicionarAtividade: (atividade) {
                  setState(() {
                    atividades.add(atividade); // Adiciona a nova atividade à lista
                    ordenarAtividades(); // Reordena após adicionar
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 0: // Índice do botão "Home"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PaginaInicial()),
              );
              break;
            case 1: // Índice do botão "Calendário"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgendaPage()),
              );
              break;
            case 2: // Índice do botão "Perfil"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PerfilPage()),
              );
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
