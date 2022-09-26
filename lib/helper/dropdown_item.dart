import 'package:flutter/material.dart';

class DropdownItem{


  static DropdownMenuItem<int> getItemParameter(int value,String text) {
    return new DropdownMenuItem(
      value: value,
      // child: 
      //Padding(
        //padding: const EdgeInsets.all(1.0),
        // rchild: 
        // Padding(
          // padding: const EdgeInsets.all(8.0),
          child: Text(text,style: TextStyle(fontSize: 14, color: Colors.black)),
        // ),
      // ),
    );
  }
}