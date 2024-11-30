import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'pagina_inicial.dart';
import 'perfil.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  bool isActivityDay(DateTime day) {
    //exemplo para marcar o dia 15 como dia com atividade em todos os meses
    return day.day == 15;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            iconSize: 40,
            color: const Color.fromARGB(255, 236, 209, 241),
            onPressed: () {
              setState(() {
                today = DateTime.now(); // Volta para o dia atual
              });
            },
          ),
        ],
      ),
      body: content(),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 0: //botão "Home"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PaginaInicial()),
              );
              break;
            case 1: //botão "Calendario"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgendaPage()),
              );
              break;
            case 2: //botão "Perfil"
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

  Widget content() {
    return Column(
      children: [
        // Text("teste"),
        Container(
          child: TableCalendar(
            locale: "pt_BR",
            rowHeight: 60,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            calendarBuilders: CalendarBuilders(
              //estilo do dia com atividade
              defaultBuilder: (context, day, focusedDay) {
                bool hasActivity = isActivityDay(day);
                return Container(
                  decoration: BoxDecoration(
                    color: hasActivity
                        ? const Color.fromARGB(218, 76, 175, 79)
                        : null, // Cor do dia com atividade
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: hasActivity ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
              headerTitleBuilder: (context, day) {
                String monthName = getMonthName(day.month);
                return GestureDetector(
                  onTap: () async {
                    //ao clicar no cabeçalho vai aparecer o model para selecionar o mes
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
                  child: Center(
                    child: Text(
                      '$monthName ${day.year}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String getMonthName(int month) {
    const monthNames = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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