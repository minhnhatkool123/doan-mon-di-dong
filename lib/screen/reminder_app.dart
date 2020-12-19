import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'color_pick.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    if (this.year > other.year)
      return true;
    else if (this.year == other.year) {
      if (this.month > other.month)
        return true;
      else if (this.month == other.month) if (this.day > other.day)
        return true;
      else if (this.day == other.day) return true;
    }
    return false;
    // return this.year == other.year &&
    //     this.month == other.month &&
    //     this.day == other.day;
  }
}

class ReminderApp extends StatefulWidget {
  final int color;
  ReminderApp({this.color});
  @override
  _ReminderAppState createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  FToast fToast;
  DateTime selectedDate; // DateTime.now();
  TimeOfDay timeOfDay; //= TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    timeOfDay = TimeOfDay.now();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colors[widget.color],
        elevation: 0,
        title: Text(
          'Reminder',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      controller: TextEditingController(
                        text: DateFormat.yMMMd().format(selectedDate),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                        //icon: Icon(Icons.calendar_today),
                        labelText: 'Select Date',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        _selectTime(context);
                      },
                      controller: TextEditingController(
                        text: timeOfDay.hour.toString() +
                            ':' +
                            timeOfDay.minute.toString(),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.watch_later_outlined,
                          color: Colors.black,
                        ),
                        labelText: 'Select Time',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                width: double.infinity,
                child: RaisedButton(
                  //icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    showToastError();
                  },
                  child: Text(
                    'Set Time',
                    style: TextStyle(color: Colors.black),
                  ),
                  color: Colors.white,
                  shape: Border.all(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Container(
    //   width: double.infinity,
    //   child: Dialog(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Row(
    //           mainAxisSize: MainAxisSize.min,
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             Container(
    //               width: 50, //MediaQuery.of(context).size.width / 2,
    //               child: Text('asdsad'),
    //             ),
    //             // SizedBox(
    //             //   width: 10,
    //             // ),
    //             Container(
    //               width: 150, //MediaQuery.of(context).size.width / 3,
    //               child: Text('hellsda'),
    //             ),
    //           ],
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         Container(
    //           padding: EdgeInsets.only(
    //             left: 20,
    //             right: 20,
    //           ),
    //           width: double.infinity,
    //           child: RaisedButton(
    //             //icon: Icon(Icons.calendar_today),
    //             onPressed: () {
    //               showToastError();
    //             },
    //             child: Text(
    //               'Set Time',
    //               style: TextStyle(color: Colors.black),
    //             ),
    //             color: Colors.white,
    //             shape: Border.all(color: Colors.black),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (t != null && t != timeOfDay) {
      setState(() {
        timeOfDay = t;
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void showToastError() {
    var reSultDate = selectedDate.isSameDate(DateTime.now());
    var reSultTimeHour = timeOfDay.hour - TimeOfDay.now().hour;
    var reSultTimeMinute = timeOfDay.minute - TimeOfDay.now().minute;
    //print(reSultDate);
    if (reSultDate == false ||
        (reSultTimeHour == 0 && reSultTimeMinute < 1) ||
        reSultTimeHour < 0) {
      fToast.removeCustomToast();
      _showToast();
    }
  }

  void _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey[400],
      ),
      child: Text(
        "Set the time some where in the future",
        style: TextStyle(color: Colors.black),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    //     });
  }
}
