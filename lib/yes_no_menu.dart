import 'package:flutter/material.dart';
 
class ShowYesNo {
  static show(String menuTitle,BuildContext context, Function okFunction, Function noFunction 
       ) {
    // set up the buttons
    Widget yesButton = ElevatedButton(
      child: Text("Yes"),
      onPressed: () {
        okFunction();
        Navigator.of(context).pop();
      },
    );

    Widget noButton = ElevatedButton(
      child: Text("No"),
      onPressed: () {
        noFunction();
        Navigator.of(context).pop();
      },
    );
   

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(menuTitle),
      content: Text("please confirm"),
      actions: [
        yesButton,
        noButton,
         
      ],
    );

    // show the dialog
    return alert;
  }
}
