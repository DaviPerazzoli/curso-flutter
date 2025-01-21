class Task {
  int? _id;
  String _title;
  String? _description;
  DateTime _creationDate;
  DateTime? _dueDate;
  bool _done;
  int _taskListId;

  Task.create({
    int? id,
    required String title,
    String? description,
    DateTime? dueDate,
    required int taskListId
  }): _dueDate = dueDate, _description = description, _id = id, _title = title, _taskListId = taskListId,
    _creationDate = DateTime.now(),
    _done = false;

  Task.fromExistent({
    required int? id,
    required String title,
    String? description,
    DateTime? dueDate,
    required DateTime creationDate,
    required bool done,
    required int taskListId
  }) : _done = done, _dueDate = dueDate, _creationDate = creationDate, _description = description, _id = id, _title = title, _taskListId = taskListId;

  int? get id {
    return _id;
  }

  set id (int? n) {
    _id = n;
  }

  String get title {
    return _title;
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

  int get taskListId => _taskListId;

  String _2digitNumber (int number) {
    return number > 9? number.toString() : '0$number';
  }

  String _readableDateTime(DateTime? date) {
    if (date == null) {
      return '';
    }
    String readable = '${_2digitNumber(date.month)}/${_2digitNumber(date.day)}/${date.year} at ${_2digitNumber(date.hour)}:${_2digitNumber(date.minute)}:${_2digitNumber(date.second)}';
    return readable;
  }

  String get readableDueDate => _readableDateTime(_dueDate);

  String get readableCreationDate => _readableDateTime(_creationDate);

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "title" : _title,
      "description" : _description,
      "creationDate" : _creationDate.toIso8601String(),
      "dueDate" : _dueDate?.toIso8601String(),
      "done" : _done ? 1 : 0,
      "taskListId": _taskListId
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.fromExistent(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      creationDate: DateTime.parse(map['creationDate']),
      done: map['done'] == 1? true: false,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      taskListId: map["taskListId"],
    );
  }

}