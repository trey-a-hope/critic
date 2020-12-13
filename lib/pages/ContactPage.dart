import 'package:critic/Constants.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextStyle _headerTextStyle = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.bold,
  );

  final TextStyle _paragraphTextStyle = TextStyle(
    fontSize: 18,
  );

  final SizedBox _space = SizedBox(
    height: 30,
  );
  final SizedBox _smallSpace = SizedBox(
    height: 10,
  );

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
        backgroundColor: colorNavy,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Text(
                'Feel free to hit us up anytime about anything.',
                style: _paragraphTextStyle,
              ),
              _space,
              Text(
                'E-Mail',
                style: _headerTextStyle,
              ),
              _smallSpace,
              Text(
                'trey.a.hope@gmail.com',
                style: _paragraphTextStyle,
              ),
              _space,
              // Text(
              //   'Phone Number',
              //   style: _headerTextStyle,
              // ),
              // _smallSpace,
              // Text(
              //   '111-111-1111',
              //   style: _paragraphTextStyle,
              // ),
              // _space,
            ],
          ),
        ),
      ),
    );
  }
}
