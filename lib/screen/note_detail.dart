import 'dart:ffi';
import 'dart:io' as fromIO;
import 'package:doannote/screen/notification_app.dart';
import 'package:doannote/screen/reminder_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:doannote/database/databaseapp.dart';
import 'package:doannote/entities/note.dart';
import 'package:doannote/screen/color_pick.dart';

import 'dart:convert';
import 'package:image/image.dart' as ImageProcess;

class NoteDetail extends StatefulWidget {
  final Note note;
  NoteDetail(this.note);
  @override
  _NoteDetailState createState() => _NoteDetailState(this.note);
}

class _NoteDetailState extends State<NoteDetail> {
  Databaseapp databaseapp = Databaseapp();
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int color;
  String pathImage;

  bool isEdited = false;
  fromIO.File imageFile;
  DateTime dateTime; //= DateTime.now();
  _NoteDetailState(this.note);

  int count = 0;

  @override
  void initState() {
    super.initState();
    notificationApp.setListenerForLowerVersion(onNotificationInLowerVersions);
    notificationApp.setOnNotificationClick(onNotificationClick);
    showNotificationCount();
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    color = note.color;
    pathImage = note.pathimage;
    if (note.id != null) {
      dateTime = DateTime(2000, 2, 2);
    } else
      dateTime = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors[color],
        //bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text(
            'Ghi Chú',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        //backgroundColor: colors[color],
        leading: IconButton(
          iconSize: 40,
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.black,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(
              Icons.done,
              color: Colors.black,
            ),
            onPressed: () {
              titleController.text.length == 0
                  ? print('ko de trong title')
                  : _save();
            },
          ),
          if (note.id != null)
            IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onPressed: () async {
                await notificationApp.showNotification(note);
                count = await notificationApp.getPendingNotificationCount();
                print('KKK ' + '$count');
                //await notificationApp.cancelNotification();
                //count = await notificationApp.getPendingNotificationCount();
                //print('KKK ' + '$count');
              },
            ),
          // if (note.id != null)
          //   Switch(
          //       value: valueSwicth,
          //       onChanged: (value) {
          //         setState(() {
          //           valueSwicth = value;
          //           print(valueSwicth);
          //         });
          //       }),
          // IconButton(
          //   iconSize: 30,
          //   icon: Icon(
          //     Icons.schedule,
          //     color: Colors.black,
          //   ),
          //   onPressed: () async {
          //     _showClock(context);
          //     // await notificationApp.cancelNotification();
          //     // showNotificationCount();
          //     //
          //   },
          // ),
          PopupMenuButton(
            padding: EdgeInsets.all(0),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Setting'),
                    ),
                  ],
                ),
              ),
              //if (valueSwicth)
              PopupMenuItem(
                value: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add_alert,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Reminder'),
                    ),
                  ],
                ),
              )
            ],
            initialValue: 2,
            onCanceled: () {},
            onSelected: (value) {
              if (value == 1)
                _showOptionsImageAndColors(context);
              else
                //showReminder(color);
                moveToReminder(color);
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            //elevation: 4,
          )
          // IconButton(
          //   icon: Icon(
          //     Icons.more_vert,
          //     color: Colors.black,
          //   ),
          //   onPressed: null,
          // )
        ],
      ),
      body: Container(
        color: colors[color],
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // if (imageFile == null)
              //   Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 0,
              //     color: Colors.white,
              //   )
              if (pathImage != '')
                Container(
                  padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                  child: Image.memory(
                    Base64Decoder().convert(pathImage),

                    width: MediaQuery.of(context).size.width,
                    height: 500,
                    //fit: BoxFit.contain,
                  ),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
                child: TextField(
                  controller: titleController,
                  //maxLength: 255,
                  style: TextStyle(
                      fontFamily: 'Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
                child: TextField(
                  controller: descriptionController,
                  maxLines: 18,
                  maxLength: 800,
                  style: TextStyle(
                      fontFamily: 'Sans',
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 18),
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type not here...',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  void _save() async {
    Navigator.pop(context);
    if (pathImage == '')
      note.pathimage = '';
    else {
      // final fileImage = ImageProcess.decodeImage(
      //   imageFile.readAsBytesSync(),
      // );
      //
      // String base64Image = base64Encode(ImageProcess.encodePng(fileImage));
      note.pathimage = pathImage; //base64Image;
    }

    note.date = DateFormat.yMMMd().format(DateTime.now());
    // var ngay =
    //     DateFormat('yMMMd').parse(note.date); //DateTime.parse(note.date);
    // print('NGAY' + ngay.day.toString());
    // print('THANG' + ngay.month.toString());
    // print('NAM' + ngay.year.toString());
    // print('GIO' + ngay.hour.toString());
    // print('PHUT' + ngay.minute.toString());
    if (note.id != null)
      await databaseapp.updateNote(note);
    else
      await databaseapp.insertNote(note);
  }

  void _showPhotoLibrary() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = fromIO.File(pickedFile.path);
        pathImage =
            base64Encode(ImageProcess.encodePng(ImageProcess.decodeImage(
          imageFile.readAsBytesSync(),
        )));
      });
      note.pathimage = pathImage;
    }
  }

  void _showDate(BuildContext context) async {
    final DateTime t = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      // builder: (BuildContext context, Widget child) {
      //   return Theme(
      //     // data: ThemeData.light().copyWith(
      //     //   //primaryColor: c,
      //     //   //accentColor: const Color(0xFF8CE7F1),
      //     //   colorScheme: ColorScheme.light(primary: colors[color]),
      //     //   buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      //     // ),
      //     data: ThemeData.dark().copyWith(
      //       colorScheme: ColorScheme.dark(
      //         primary: colors[color],
      //         //onPrimary: Colors.white,
      //         surface: colors[color],
      //         onSurface: Colors.black,
      //       ),
      //       dialogBackgroundColor: Colors.white,
      //       buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      //     ),
      //     child: child,
      //   );
      //},
    );
    //int mi = now.hour;
  }

  void _showOptionsImageAndColors(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 140,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ColorPick(
                      selectedIndex: note.color,
                      onTap: (index) {
                        setState(() {
                          color = index;
                          print('an nut chuyen mau');
                        });
                        note.color = index;
                        print(color.toString());
                      },
                    ),
                    // ListTile(
                    //   onTap: () {
                    //     _showDate(context);
                    //   },
                    //   leading: Icon(Icons.photo_camera),
                    //   title: Text("Take a picture from camera"),
                    // ),
                    ListTile(
                        onTap: () {
                          _showPhotoLibrary();
                        },
                        leading: Icon(Icons.photo_library),
                        title: Text("Choose from photo library"))
                  ]));
        });
  }

  void moveToReminder(int color) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReminderApp(color: color)));
  }

  void showNotificationCount() async {
    count = await notificationApp.getPendingNotificationCount();
    print('KKK ' + '$count');
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}
  onNotificationClick(String payload) {}

  // void showReminder(int color) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => ReminderApp(color: color));
  // }
}
