import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Constants.dart';
import '../ServiceLocator.dart';

class TermsServicePage extends StatelessWidget {
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
          'Terms & Services',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              _smallSpace,
              Text(
                'Conditions of Use',
                style: _headerTextStyle,
              ),
              _smallSpace,
              Text(
                'We will provide their services to you, which are subject to the conditions stated below in this document. Every time you visit this website, use its services or make a purchase, you accept the following conditions. This is why we urge you to read them carefully.',
                style: _paragraphTextStyle,
              ),
              _space,
              Text(
                'Copyright',
                style: _headerTextStyle,
              ),
              _smallSpace,
              Text(
                'Content published on this website (digital downloads, images, texts, graphics, logos) is the property of [name] and/or its content creators and protected by international copyright laws. The entire compilation of the content found on this website is the exclusive property of [name], with copyright authorship for this compilation by [name].',
                style: _paragraphTextStyle,
              ),
              _space,
            ],
          ),
        ),
      ),
    );
  }
}
