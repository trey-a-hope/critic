import 'package:critic/constants/globals.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactView extends StatelessWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      leftIconButton: IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed: () {
          Get.back();
        },
      ),
      child: SafeArea(
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
              Text(Globals.EMAIL, style: Theme.of(context).textTheme.headline5),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      title: 'Contact',
    );
  }
}
