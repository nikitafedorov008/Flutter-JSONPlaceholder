import 'package:flutter/material.dart';

Widget todoItem (bool completed, String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 12,
      child: ListTile(
        leading: Icon(
          completed ? Icons.check_circle_outlined : Icons.cancel_outlined,
          color: completed ? Colors.green : Colors.red,
        ),
        title: Text(title),
        subtitle: Text('status: ${completed ? 'completed' : 'uncompleted'}'),
      ),
    ),
  );
}