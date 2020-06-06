import 'package:ekf/widget/form_text.dart';
import 'package:flutter/material.dart';

class AddCollaborator extends StatefulWidget {
  AddCollaborator({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddCollaboratorState createState() => _AddCollaboratorState();
}

class _AddCollaboratorState extends State<AddCollaborator> {
  TextEditingController firstName, lastName, secondName, date, position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Сотрудник'),
            FormText(firstName, 'Имя', TextInputType.text),
            FormText(firstName, 'Фамилия', TextInputType.text),
            FormText(firstName, 'Отчество', TextInputType.text),
            FormText(firstName, 'Дата рождения', TextInputType.number),
            FormText(firstName, 'Должность', TextInputType.text)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Добавить',
        child: Icon(Icons.add),
      ),
    );
  }
}
