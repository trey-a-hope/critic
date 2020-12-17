import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc.dart';

class PostCommentPage extends StatefulWidget {
  @override
  State createState() => PostCommentPageState();
}

class PostCommentPageState extends State<PostCommentPage>
    implements PostCommentBlocDelegate {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PostCommentBloc _postCommentBloc;

  @override
  void initState() {
    _postCommentBloc = BlocProvider.of<PostCommentBloc>(context);
    _postCommentBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: colorNavy,
        title: Text(
          'Post Comment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<PostCommentBloc, PostCommentState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is LoadedState) {
            return SafeArea(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: TextFormField(
                        controller: _messageController,
                        keyboardType: TextInputType.text,
                        validator: locator<ValidationService>().isEmpty,
                        textInputAction: TextInputAction.done,
                        maxLines: 5,
                        maxLength: CRITIQUE_CHAR_LIMIT,
                        decoration: InputDecoration(
                            hintText: 'What do you think about this critique?'),
                      ),
                    ),
                    Spacer(),
                    FullWidthButton(
                      buttonColor: Colors.red,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        bool confirm = await locator<ModalService>()
                            .showConfirmation(
                                context: context,
                                title: 'Submit',
                                message: 'Are you sure?');

                        if (!confirm) return;

                        _postCommentBloc.add(
                          SubmitEvent(
                            message: _messageController.text,
                          ),
                        );
                      },
                      text: 'Submit',
                    )
                  ],
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
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }

  @override
  void clearText() {
    _messageController.clear();
  }
}
