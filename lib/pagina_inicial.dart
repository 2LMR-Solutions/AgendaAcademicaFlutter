import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'calendario.dart';
import 'perfil.dart';
import 'adicionar_atividade.dart';
import 'editar_atividade.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'pagina_graficos.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  late String nome = 'Usuário';
  List<Map<String, dynamic>> atividades = [];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _carregarAtividades();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nome = prefs.getString('user_name') ?? 'Usuário';
    });
  }

  Future<void> _salvarAtividades() async {
    final prefs = await SharedPreferences.getInstance();
    final atividadesJson =
        atividades.map((atividade) => jsonEncode(atividade)).toList();
    await prefs.setStringList('atividades', atividadesJson);
  }

  Future<void> _carregarAtividades() async {
    final prefs = await SharedPreferences.getInstance();
    final atividadesJson = prefs.getStringList('atividades') ?? [];
    setState(() {
      atividades = atividadesJson
          .map((json) => jsonDecode(json))
          .toList()
          .cast<Map<String, dynamic>>();
    });
  }

  void ordenarAtividades() {
    atividades.sort((a, b) {
      try {
        DateTime dataA = DateFormat('dd/MM/yyyy').parse(a['data']);
        DateTime dataB = DateFormat('dd/MM/yyyy').parse(b['data']);
        return dataA.compareTo(dataB);
      } catch (e) {
        debugPrint('Erro ao ordenar atividades: $e');
        return 0;
      }
    });
  }

  void mostrarDetalhesAtividade(
      BuildContext context, Map<String, dynamic> atividade) {
    final subtarefas = List<Map<String, dynamic>>.from(atividade['subtarefas']);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateLocal) {
            return AlertDialog(
              title: Text(atividade['titulo']),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Descrição:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(atividade['descricao']),
                    const SizedBox(height: 10),
                    const Text('Data final:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(atividade['data']),
                    const Divider(),
                    const Text('Subtarefas:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...subtarefas.asMap().entries.map((entry) {
                      final index = entry.key;
                      final subtarefa = entry.value;
                      return ListTile(
                        leading: Checkbox(
                          value: subtarefa['marcada'],
                          onChanged: (bool? novaMarcacao) {
                            setStateLocal(() {
                              subtarefas[index]['marcada'] = novaMarcacao!;
                            });
                            setState(() {
                              atividade['subtarefas'] = subtarefas;
                              final atividadeIndex =
                                  atividades.indexOf(atividade);
                              if (atividadeIndex != -1) {
                                atividades[atividadeIndex] = atividade;
                              }
                              _salvarAtividades();
                            });
                          },
                          activeColor: const Color.fromRGBO(181, 33, 226, 1),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaEditarAtividade(
                          atividade: atividade,
                        ),
                      ),
                    ).then((atividadeEditada) {
                      if (atividadeEditada != null) {
                        if (atividadeEditada == 'excluida') {
                          setState(() {
                            atividades.remove(atividade);
                            _salvarAtividades();
                          });
                        } else {
                          setState(() {
                            final index = atividades.indexOf(atividade);
                            if (index != -1) {
                              atividades[index] = atividadeEditada;
                              _salvarAtividades();
                            }
                          });
                        }
                      }
                    });
                  },
                  child: const Text('Editar',
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  double calcularPorcentagemConclusao(Map<String, dynamic> atividade) {
    final subtarefas =
        List<Map<String, dynamic>>.from(atividade['subtarefas'] ?? []);
    if (subtarefas.isEmpty) return 0.0;

    final totalSubtarefas = subtarefas.length;
    final concluidas = subtarefas.where((sub) => sub['marcada'] == true).length;

    return concluidas / totalSubtarefas;
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ordenarAtividades();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Olá,',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 70,
                ),
                onPressed: () {},
              ),
            ],
          ),
          leading: Container(width: 50),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
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

              // Verifica se a lista de atividades está vazia
              atividades.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Não há atividade registrada',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ConstrainedBox(
                constraints:
                const BoxConstraints(maxHeight: 220, minHeight: 56.0),
                child: ListView.builder(
                  shrinkWrap: true,
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
                        mostrarDetalhesAtividade(context, atividade);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: const Divider(
                  height: 1,
                  color: Color(0xFFb521e2),
                  thickness: 1,
                ),
              ),
              const SizedBox(height: 15),

              // Título da seção "Gráficos de Progresso"
              const Padding(
                padding: EdgeInsets.only(left: 16.0), // Alinhamento à esquerda
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gráficos de Progresso',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // Gráficos de Progresso
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15), // Espaço antes dos gráficos
                    Row(
                      mainAxisAlignment: atividades.length == 1
                          ? MainAxisAlignment.center
                          : MainAxisAlignment
                          .spaceEvenly, // Centralizar se houver 1 gráfico
                      children: List.generate(
                        2, // Gerar até 2 gráficos
                            (index) {
                          if (index < atividades.length) {
                            final atividade = atividades[index];
                            final porcentagem =
                            calcularPorcentagemConclusao(atividade);
                            return CircularPercentIndicator(
                              radius: 60.0,
                              lineWidth: 15.0,
                              percent: porcentagem,
                              center: Text(
                                "${(porcentagem * 100).toStringAsFixed(0)}%",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              progressColor:
                              index == 0 ? Color.fromRGBO(97, 201, 168, 1) : Color.fromRGBO(26, 200, 237, 1),
                              footer: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  atividade['titulo'],
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox
                                .shrink(); // Evitar espaço vazio visível
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10), // Espaço entre gráficos e botão
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0), // Adicionando espaçamento à esquerda
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaGraficosTarefas(atividades: atividades), // Passar a lista de atividades
                              ),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 7),
                          ),
                          child: const Text(
                            "Ver mais",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      atividades.add(atividade);
                      ordenarAtividades();
                      _salvarAtividades();
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
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaginaInicial()),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AgendaPage()),
                );
                break;
              case 2:
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
      ),
    );
  }
}
