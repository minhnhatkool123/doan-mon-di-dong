class Note {
  int _id;
  String _title;
  String _description;
  String _pathimage;
  String _date;
  int _color;

  Note(this._title, this._pathimage, this._date, this._color,
      [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get pathimage => _pathimage;
  String get date => _date;
  int get color => _color;

  set title(String newtitle) {
    this._title = newtitle;
  }

  set pathimage(String newpathimage) {
    _pathimage = newpathimage;
  }

  set description(String newdescription) {
    if (newdescription.length <= 800) this._description = newdescription;
  }

  set color(int newcolor) {
    if (newcolor >= 0 && newcolor <= 9) this._color = newcolor;
  }

  set date(String newdate) {
    this._date = newdate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['pathimage'] = _pathimage;
    map['date'] = _date;
    map['color'] = _color;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._pathimage = map['pathimage'];
    this._date = map['date'];
    this._color = map['color'];
  }
}
