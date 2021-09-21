class Task1 {
 int _id;
  String _title;
   String _description;
  String _date;
  int _priority;
  Task1(this._id, this._title, this._date, this._priority);
  
  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

}
