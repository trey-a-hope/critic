import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/GoodButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';

import '../ServiceLocator.dart';

class CritiquePage extends StatefulWidget {
  const CritiquePage({Key key, @required this.movie}) : super(key: key);

  final MovieModel movie;

  @override
  State createState() => CritiquePageState(movie: movie);
}

//NOTE: Future builder with text fields on them causes the page to rebuild on focus.
//Todo: Find a away to get current user into this page...

class CritiquePageState extends State<CritiquePage> {
  CritiquePageState({@required this.movie});

  final MovieModel movie;
  final TextEditingController critiqueController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  void submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      bool confirm = await locator<ModalService>().showConfirmation(
          context: context, title: 'Submit', message: 'Are you sure?');
      if (confirm) {
        try {
          locator<ModalService>().showInSnackBar(
              scaffoldKey: scaffoldKey, message: 'Submitting critique...');

          //Fetch current user;
          UserModel currentUser = await locator<AuthService>().getCurrentUser();

          DateTime now = DateTime.now();
          
          CritiqueModel critique = CritiqueModel(
            id: '',
            userID: currentUser.uid,
            imdbID: movie.imdbID,
            message: critiqueController.text,
            modified: now,
            created: now,
          );

          await locator<CritiqueService>().createCritique(critique: critique);

          formKey.currentState.reset();

          critiqueController.clear();

          locator<ModalService>().showInSnackBar(
              scaffoldKey: scaffoldKey, message: 'Sent!');
        } on PlatformException catch (e) {
          locator<ModalService>().showInSnackBar(
              scaffoldKey: scaffoldKey, message: 'Error: ${e.toString()}');
        }
      }
    } else {
      locator<ModalService>().showInSnackBar(
          scaffoldKey: scaffoldKey, message: 'Cannot leave field empty.');

      setState(
        () {
          autoValidate = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create Critique'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            autovalidate: autoValidate,
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(40),
                  child: TextFormField(
                    controller: critiqueController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validator: locator<ValidationService>().isEmpty,
                    maxLines: 5,
                    maxLength: 150,
                    maxLengthEnforced: true,
                    decoration: InputDecoration(
                        hintText: 'What do you think about this movie/show?'),
                  ),
                ),
                Spacer(),
                GoodButton(
                  title: 'Submit',
                  onTap: submit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
