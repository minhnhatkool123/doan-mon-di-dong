import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:doannote/screen/note_list.dart';

class ContaninerMain extends StatelessWidget {
  static const String ROUTER_ID = 'init_screen';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: 80.0,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SearchBar(),
          ),

          Expanded(
            child: NoteList(),
          )
// Expanded(
          //   child: Text('dsadas'),
          // ),
          // Expanded(
          //   child: Text('dsadas'),
          // ),
        ],
      ),
    );
  }
}
