import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/createCritique/CreateCritiqueBloc.dart';
import 'package:critic/blocs/createCritique/CreateCritiqueEvent.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CreateCritiqueState.dart';

class CreateCritiquePage extends StatefulWidget {
  @override
  State createState() => CreateCritiquePageState();
}

class CreateCritiquePageState extends State<CreateCritiquePage>
    implements CreateCritiqueBlocDelegate {
  final TextEditingController _critiqueController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CreateCritiqueBloc _createCritiqueBloc;
  @override
  void initState() {
    _createCritiqueBloc = BlocProvider.of<CreateCritiqueBloc>(context);
    _createCritiqueBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create Critique'),
        centerTitle: true,
      ),
      body: BlocBuilder<CreateCritiqueBloc, CreateCritiqueState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is CreateCritiqueStartState) {
            return SafeArea(
              child: Center(
                child: Form(
                  autovalidate: state.autoValidate,
                  key: state.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40),
                        child: TextFormField(
                          controller: _critiqueController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validator: locator<ValidationService>().isEmpty,
                          maxLines: 5,
                          maxLength: 150,
                          maxLengthEnforced: true,
                          decoration: InputDecoration(
                              hintText:
                                  'What do you think about this movie/show?'),
                        ),
                      ),
                      Spacer(),
                      RaisedButton(
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        onPressed: () async {
                          bool confirm = await locator<ModalService>()
                              .showConfirmation(
                                  context: context,
                                  title: 'Submit',
                                  message: 'Are you sure?');

                          if (!confirm) return;

                          _createCritiqueBloc.add(
                            SubmitEvent(
                                formKey: state.formKey,
                                critique: _critiqueController.text),
                          );
                        },
                        child: Text('Submit'),
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          return Center(
            child: Text('You should NEVER see this.'),
          );
        },
      ),
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }

  @override
  void clearText() {
    _critiqueController.clear();
  }
}
