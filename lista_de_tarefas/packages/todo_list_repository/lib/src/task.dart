class Task {
  int? id;
  String title;
  String? description;
  DateTime creationDate;
  DateTime? dueDate;
  bool done;

  Task.create({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
  }): 
    creationDate = DateTime.now(),
    done = false;

  Task.fromExistent({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.creationDate,
    required this.done
  });
  
  bool get isLate {
    if (dueDate == null){
      return false;
    }

    if (!done && DateTime.now().isAfter(dueDate!)){
      return true;
    }

    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title" : title,
      "description" : description,
      "creationDate" : creationDate.toIso8601String(),
      "dueDate" : dueDate?.toIso8601String(),
      "done" : done,
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