import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TelaGraficosTarefas extends StatefulWidget {
  final List<Map<String, dynamic>> atividades;

  const TelaGraficosTarefas({super.key, required this.atividades});

  @override
  _TelaGraficosTarefasState createState() => _TelaGraficosTarefasState();
}

class _TelaGraficosTarefasState extends State<TelaGraficosTarefas> {
  double calcularPorcentagemConclusao(Map<String, dynamic> tarefa) {
    final totalSubtarefas = tarefa['subtarefas'].length;
    final concluidas = tarefa['subtarefas']
        .where((subtarefa) => subtarefa['marcada'] == true)
        .length;
    return totalSubtarefas > 0 ? concluidas / totalSubtarefas : 0.0;
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
                    const Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(atividade['descricao']),
                    const SizedBox(height: 10),
                    const Text('Data final:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(atividade['data']),
                    const Divider(),
                    const Text('Subtarefas:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...subtarefas.map((subtarefa) {
                      return ListTile(
                        leading: Icon(
                          subtarefa['marcada'] ? Icons.check_box : Icons.check_box_outline_blank,
                          color: const Color.fromRGBO(181, 33, 226, 1),
                        ),
                        title: Text(subtarefa['nome']),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(181, 33, 226, 1),
        title: const Text(
          "Gráficos de progresso",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Cor da flecha
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 gráficos por linha
            crossAxisSpacing: 16.0, // Espaço entre os gráficos horizontalmente
            mainAxisSpacing: 16.0, // Espaço entre os gráficos verticalmente
            childAspectRatio: 1, // Proporção do gráfico (quadrado)
          ),
          itemCount: widget.atividades.length, // Quantidade de gráficos = número de tarefas
          itemBuilder: (context, index) {
            final tarefa = widget.atividades[index];
            final porcentagem = calcularPorcentagemConclusao(tarefa);
            return GestureDetector(
              onTap: () {
                // Chama a função para mostrar os detalhes da tarefa
                mostrarDetalhesAtividade(context, tarefa);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 15.0,
                    percent: porcentagem,
                    center: Text(
                      "${(porcentagem * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    progressColor: index % 2 == 0
                        ? Color.fromRGBO(97, 201, 168, 1)
                        : Color.fromRGBO(26, 200, 237, 1), // Alternar cores
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        tarefa['titulo'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
