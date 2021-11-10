import 'package:critic/constants.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final TextStyle _headerTextStyle = TextStyle(
  //   fontSize: 21,
  //   fontWeight: FontWeight.bold,
  // );

  // final TextStyle _paragraphTextStyle = TextStyle(
  //   fontSize: 18,
  // );

  // final SizedBox _space = SizedBox(
  //   height: 30,
  // );
  // final SizedBox _smallSpace = SizedBox(
  //   height: 10,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Contact',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Text(
                  'Feel free to hit us up anytime with questions, concerns, or comments.',
                  style: Theme.of(context).textTheme.headline5),
              SizedBox(
                height: 30,
              ),
              Text('E-Mail', style: Theme.of(context).textTheme.headline3),
              Text('$EMAIL', style: Theme.of(context).textTheme.headline5),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
