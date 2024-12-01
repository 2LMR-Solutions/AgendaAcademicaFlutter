import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime today = DateTime.now();
  List<Map<String, dynamic>> atividades = [];

  @override
  void initState() {
    super.initState();
    _carregarAtividades();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
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

  bool isActivityDay(DateTime day) {
    //marcar o dia como dia com atividade
    return atividades.any((atividade) {
      try {
        final dataAtividade = DateFormat('dd/MM/yyyy').parse(atividade['data']);
        return isSameDay(day, dataAtividade);
      } catch (_) {
        return false;
      }
    });
  }

  List<Map<String, dynamic>> atividadesDoDia(DateTime day) {
    return atividades.where((atividade) {
      try {
        final dataAtividade = DateFormat('dd/MM/yyyy').parse(atividade['data']);
        return isSameDay(dataAtividade, day);
      } catch (_) {
        return false;
      }
    }).toList();
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
            setState(() {
              today = DateTime(today.year, today.month - 1);
            });
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                //ao clicar no cabeçalho, aparece o modal para selecionar o mês
                final selectedDate = await showYearMonthPicker(
                  context: context,
                  initialDate: today,
                );
                if (selectedDate != null) {
                  setState(() {
                    today = selectedDate;
                  });
                }
              },
              child: Text(
                '${getMonthName(today.month)} ${today.year}', // Nome do mês e ano
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(181, 33, 226, 1),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.today_rounded),
              iconSize: 24,
              color: const Color.fromRGBO(181, 33, 226, 1),
              onPressed: () {
                setState(() {
                  today = DateTime.now(); // Volta para o dia atual
                });
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            iconSize: 24,
            color: const Color.fromRGBO(181, 33, 226, 1),
            onPressed: () {
              setState(() {
                today = DateTime(today.year, today.month + 1);
              });
            },
          ),
        ],
      ),
      body: content(),
    );
  }

  Widget content() {
    List<Map<String, dynamic>> atividadesDiaSelecionado =
        atividadesDoDia(today);

    return Column(
      children: [
        // Text("teste"),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: TableCalendar(
            locale: "pt_BR",
            rowHeight: 60,
            headerVisible: false,
            availableGestures: AvailableGestures.all,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            onPageChanged: (focusedDay) {
              setState(() {
                today = DateTime(
                  focusedDay.year,
                  focusedDay.month,
                );
              });
            },
            calendarBuilders: CalendarBuilders(
              //estilo do dia com atividade
              defaultBuilder: (context, day, focusedDay) {
                bool hasActivity = isActivityDay(day);
                return Container(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      if (hasActivity) ...[
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.star,
                          size: 12,
                          color: Color.fromRGBO(181, 33, 226, 1),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Text(
          'Atividades do dia ${today.day}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: atividadesDiaSelecionado.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma atividade cadastrada',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: atividadesDiaSelecionado.length,
                  itemBuilder: (context, index) {
                    final atividade = atividadesDiaSelecionado[index];
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
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Redireciona para a tela de edição
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => editar_atividade(atividade: atividade),
                          //   ),
                          // );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String getMonthName(int month) {
    const monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return monthNames[month - 1];
  }

  Future<DateTime?> showYearMonthPicker({
    required BuildContext context,
    required DateTime initialDate,
  }) async {
    int selectedYear = initialDate.year;
    DateTime? selectedDate;

    return await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("      Selecione Ano e Mês"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: selectedYear,
                onChanged: (int? newYear) {
                  if (newYear != null) {
                    selectedYear = newYear;
                  }
                },
                items: List.generate(41, (index) {
                  int year = 2010 + index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text('$year'),
                  );
                }),
              ),
              const SizedBox(height: 16.0),
              //selecao de mes
              Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: List.generate(12, (index) {
                  String monthName = getMonthName(index + 1);
                  return Container(
                    width: 90.0,
                    height: 50.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                      ),
                      onPressed: () {
                        selectedDate = DateTime(selectedYear, index + 1, 1);
                        Navigator.pop(context, selectedDate);
                      },
                      child: Text(monthName),
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}