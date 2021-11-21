import 'package:flutter/material.dart';
import 'package:testovoye/models/todo_model.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/api/fetch_data.dart';
import 'package:testovoye/utils/data_storage.dart';
import 'package:testovoye/widgets/flexible_space_background.dart';
import 'package:testovoye/widgets/todo_item.dart';


class Todos extends StatefulWidget {
  final UserModel user;

  const Todos({Key? key, required this.user}) : super(key: key);

  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username + "'s todos"),
        elevation: 24,
        flexibleSpace: flexibleSpaceBackground(context),
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchTodos(widget.user, {
          dataStorage(
          'https://jsonplaceholder.typicode.com/todos?userId=${widget.user.id.toString()}',
          'todos: ${widget.user.id}',
          ),
          }),
          builder: (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  for (var item in snapshot.requireData)
                    todoItem(item.completed, item.title),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
