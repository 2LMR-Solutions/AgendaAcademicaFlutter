import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Isso é um teste'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple,
          elevation: 10,
          shadowColor: Colors.grey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              )),
          toolbarHeight: 170,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('Olá Aluno!',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              //  centerTitle: true,
              //leading: IconButton(icon: const Icon(Icons.notification_add), onPressed: () {})

              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 70,
                ),
                onPressed: () {
                  // do something
                },
              )
            ],
          )),
      body:
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220, minHeight: 56.0),
        child: Column(
          children: [
            // Texto fixo
            Padding(
              padding: const EdgeInsets.all(16.0),
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
              child: ListView(
                shrinkWrap: true,
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Map'), trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Album'), trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Phone'), trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Map'), trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Album'), trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Phone'), trailing: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

        floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        showSelectedLabels: false,
        showUnselectedLabels: false,
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
