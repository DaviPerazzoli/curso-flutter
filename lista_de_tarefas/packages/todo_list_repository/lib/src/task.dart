class Task {
  int? _id;
  String _title;
  String? _description;
  DateTime _creationDate;
  DateTime? _dueDate;
  bool _done;

  Task.create({
    int? id,
    required String title,
    String? description,
    DateTime? dueDate,
  }): _dueDate = dueDate, _description = description, _id = id, _title = title, 
    _creationDate = DateTime.now(),
    _done = false;

  Task.fromExistent({
    required int? id,
    required String title,
    String? description,
    DateTime? dueDate,
    required DateTime creationDate,
    required bool done
  }) : _done = done, _dueDate = dueDate, _creationDate = creationDate, _description = description, _id = id, _title = title;

  int? get id {
    return _id;
  }

  set id (int? n) {
    _id = n;
  }

  String get title {
    return title;
  }
  
  set title (String text) {
    _title = text;
  }

  String? get description {
    return _description;
  }
  
  set description (String? text) {
    _description = text;
  }

  DateTime get creationDate {
    return _creationDate;
  }

  set creationDate (DateTime date) {
    _creationDate = date;
  }

  DateTime? get dueDate {
    return _dueDate;
  }

  set dueDate (DateTime? date) {
    _dueDate = date;
  }

  bool get done {
    return _done;
  }

  set done (bool d) {
    _done = d;
  }

  bool get isLate {
    if (_dueDate == null){
      return false;
    }

    if (!_done && DateTime.now().isAfter(_dueDate!)){
      return true;
    }

    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "title" : _title,
      "description" : _description,
      "creationDate" : _creationDate.toIso8601String(),
      "dueDate" : _dueDate?.toIso8601String(),
      "done" : _done,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.fromExistent(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      creationDate: DateTime.parse(map['creationDate']),
      done: map['done'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    );
  }

}