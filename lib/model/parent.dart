class Parent {
  Parent({
    this.id,
    this.firstName,
    this.lastName,
    this.secondName,
    this.dateBirth,
    this.position,
    this.complete,
  });

  int id;
  String firstName;
  String lastName;
  String secondName;
  String dateBirth;
  String position;
  bool complete;

  static final columns = [
    'id',
    'firstName',
    'lastName',
    'secondName',
    'dateBirth',
    'position',
    'complete',
  ];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'secondName': secondName,
      'dateBirth': dateBirth,
      'position': position,
      'complete': complete,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Parent fromMap(Map<String, dynamic> map) {
    return Parent()
      ..id = map['id'] as int
      ..firstName = map['firstName'] as String
      ..lastName = map['lastName'] as String
      ..secondName = map['secondName'] as String
      ..dateBirth = map['dateBirth'] as String
      ..position = map['parent_id'] as String
      ..complete = map['complete'] == 1;
  }
}
