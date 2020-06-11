import 'package:ekf/model/parent.dart';

class Children {
  Children();

  int id;
  String firstName;
  String lastName;
  String secondName;
  String dateBirth;
  bool complete;
  int parentId;
  Parent parent;

  static final columns = [
    'id',
    'firstName',
    'lastName',
    'secondName',
    'dateBirth',
    'position',
    'complete',
    'parent_id'
  ];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'secondName': secondName,
      'dateBirth': dateBirth,
      'complete': complete,
      'parent_id': parentId
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Children fromMap(Map<String, dynamic> map) {
    return Children()
      ..id = map['id'] as int
      ..firstName = map['firstName'] as String
      ..lastName = map['lastName'] as String
      ..secondName = map['secondName'] as String
      ..dateBirth = map['dateBirth'] as String
      ..complete = map['complete'] == 1
      ..parentId = map['parent_id'] as int;
  }
}
