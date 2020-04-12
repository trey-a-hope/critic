import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GoodButton extends StatelessWidget {
  final Function onTap;
  final String title;

  GoodButton({Key key, @required this.title, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'SFUIDisplay',
          fontWeight: FontWeight.bold,
        ),
      ),
      color: Theme.of(context).buttonColor,
      elevation: 0,
      minWidth: screenWidth * 0.75,
      height: 50,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
