import 'package:flutter/material.dart';

class AppBarLayout extends AppBar {
  final String appBarTitle;
  final IconButton leading;
  final List<Widget> actions;

  AppBarLayout({@required this.appBarTitle, this.leading, this.actions})
      : super(
          title: Text(appBarTitle),
          leading: leading,
          actions: actions,
          backgroundColor: Colors.black
        );
}
