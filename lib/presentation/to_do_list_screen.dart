import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _textEditingController = TextEditingController();

  Future<void> _addToDo() async {
    String todoText = _textEditingController.text;
    if (todoText.isNotEmpty) {
      // hinzufügen zur collection
      await _firestore.collection('todos').add({'text': todoText});
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter a new ToDo',
              contentPadding: EdgeInsets.all(16.0),
            ),
          ),
          ElevatedButton(
            onPressed: _addToDo,
            child: Text('Add ToDo'),
          ),
          Expanded(
            child: StreamBuilder(
              // daten aus der DB holen
              stream: _firestore.collection('todos').snapshots(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('Es lädt noch');
                }

                // liste der todos zwischenspeichern
                var todos = snapshot.data?.docs;

                return ListView.builder(
                  itemCount: todos!.length,
                  itemBuilder: ((context, index) {
                    // einzelnes todo anlegen
                    var todo = todos[index];
                    return ListTile(
                      title: Text(
                        todo['text'],
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
