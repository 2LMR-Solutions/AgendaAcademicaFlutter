import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController _dateController = TextEditingController();
  String _formattedDate = "";
  List<TextEditingController> _subtaskControllers = [];
  List<bool> _subtaskChecked = [];

  // Função para selecionar a data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _formattedDate = DateFormat('dd/MM/yyyy').format(picked);
        _dateController.text = _formattedDate;
      });
    }
  }

  // Função chamada quando o estado do checkbox mudar
  void _onCheckboxChanged(int index, bool? newValue) {
    setState(() {
      _subtaskChecked[index] = newValue ?? false;
    });
  }

  // Função para adicionar uma nova subtarefa
  void _addSubtask() {
    setState(() {
      _subtaskControllers.add(TextEditingController());
      _subtaskChecked.add(false);
    });
  }

  @override
  void initState() {
    super.initState();
    _addSubtask(); // Adiciona a primeira subtarefa inicialmente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
              const TextField(
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Título",
                  hintStyle: TextStyle(color: Color(0xFFb521e2)),
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10,
                ),
                decoration: InputDecoration(
                  hintText: "Descrição",
                  hintStyle: TextStyle(color: Color(0xFFb521e2)),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFb521e2))),
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
              for (int i = 0; i < _subtaskControllers.length; i++)
                Row(
                  children: [
                    Checkbox(
                      value: _subtaskChecked[i],
                      onChanged: (bool? newValue) {
                        _onCheckboxChanged(i, newValue);
                      },
                      activeColor: const Color(0xFFb521e2),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _subtaskControllers[i],
                        style: const TextStyle(fontSize: 10),
                        decoration: InputDecoration(
                          hintText: "--Exemplo Subtarefa--",
                          hintStyle: TextStyle(color: Color(0xFFb521e2)),
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          // Quando o texto mudar, verificamos se a subtarefa está preenchida
                          if (text.isNotEmpty && i == _subtaskControllers.length - 1) {
                            _addSubtask(); // Adiciona uma nova subtarefa quando o campo atual não está vazio
                          }
                        },
                      ),
                    ),
                  ],
                ),
              const Divider(color: Color(0xFFb521e2)),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Selecionar Data",
                        hintStyle: const TextStyle(color: Color(0xFF3e3e3e)),
                        border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFb521e2))),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
