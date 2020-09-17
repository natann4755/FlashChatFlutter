import 'package:flutter/material.dart';

class ButoonDesigned extends StatelessWidget {

  ButoonDesigned({@required this.mButtonColor,@required this.mButtonSttring, @required this.mButtonFunction});

  final Color mButtonColor;
  final String mButtonSttring;
  final Function mButtonFunction;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: mButtonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: mButtonFunction,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            mButtonSttring ,
          style: TextStyle(
            color: Colors.white
          ),
          ),
        ),
      ),
    );
  }
}