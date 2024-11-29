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
                    color: hasActivity ? const Color.fromARGB(218, 76, 175, 79) : null, //cor do dia com atividade
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
            ),
            // onHeaderTapped: () async {
            //   final DateTime? selectedDate = await showDatePicker(
            //     context: context,
            //     initialDate: today,
            //     firstDate: DateTime(2010),
            //     lastDate: DateTime(2050),
            //   );
            //   if (selectedDate != null && selectedDate != today) {
            //     setState(() {
            //       today = selectedDate;
            //     });
            //   }
            // },
          ),
        ),
      ],
    );
  }
}
