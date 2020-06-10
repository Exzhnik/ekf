import 'package:ekf/model/parent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'services/db.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EKF',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MyHomePage(title: 'EKF USER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String nameFirst, nameLast, nameSecond, dateOfBirth, userPosition;
  var dateCtl = TextEditingController();

  List<Parent> _tasks = [];
  TextStyle _style = TextStyle(color: Colors.white, fontSize: 24);
  List<Widget> get _items => _tasks.map(format).toList();
  Widget format(Parent item) {
    return Dismissible(
      key: Key(item.id.toString()),
      onDismissed: (direction) => _delete(item),
      child: Padding(
          padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
          child: FlatButton(
            onPressed: () => _toggle(item),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${item.lastName} ${item.firstName} ${item.secondName}',
                            style: _style),
                        Text(
                          'Должность: ${item.position}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Дата рождения: ${item.dateBirth}',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  // Text(item.firstName, style: _style),
                  Icon(
                      item.complete == true
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: Colors.white)
                ]),
          )),
    );
  }

  Future _toggle(Parent item) async {
    item.complete = !item.complete;
    dynamic result = await DB.update(Parent.table, item);
    print(result);
    dateCtl.clear();
    await refresh();
  }

  Future _delete(Parent item) async {
    await DB.delete(Parent.table, item);
    await refresh();
  }

  Future _save() async {
    Navigator.of(context).pop();
    var item = Parent(
        firstName: nameFirst,
        lastName: nameLast,
        secondName: nameSecond,
        dateBirth: dateOfBirth,
        position: userPosition,
        complete: false);
    await DB.insert(Parent.table, item);
    setState(() {
      nameFirst = '';
      nameLast = '';
      nameSecond = '';
      dateOfBirth = '';
      userPosition = '';
    });
    await refresh();
  }

  void _create(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Добавить сотрудника'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Закрыть'),
                ),
                FlatButton(onPressed: _save, child: Text('Сохранить')),
              ],
              content: Wrap(
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Имя'),
                    onChanged: (value) {
                      nameFirst = value;
                    },
                  ),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Фамилия'),
                    onChanged: (value) {
                      nameLast = value;
                    },
                  ),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Отчество'),
                    onChanged: (value) {
                      nameSecond = value;
                    },
                  ),
                  TextField(
                    controller: dateCtl,
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Дата рождения'),
                    onTap: () => selectDate(context),
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) {
                      dateOfBirth = value;
                    },
                  ),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Должность'),
                    onChanged: (value) {
                      userPosition = value;
                    },
                  ),
                ],
              ));
        });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    dateCtl.dispose();
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();

  String convertStringFromDate(DateTime date) {
    var dateStr = DateFormat.yMMMMd('ru').format(date);
    var timeStr = DateFormat.Hm('ru').format(date);
    var parseDate = '$dateStr в $timeStr';
    return parseDate;
  }

  final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
  Future selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateCtl.text = DateFormat('dd.MM.yyyy').format(picked);
        dateOfBirth = DateFormat('dd.MM.yyyy').format(picked);
      });
  }

  Future refresh() async {
    var _results = await DB.query(Parent.table);
    _tasks = _results.map(Parent.fromMap).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text(widget.title)),
        body: Center(child: ListView(children: _items)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _create(context);
          },
          tooltip: 'New TODO',
          child: Icon(Icons.library_add),
        ));
  }
}
