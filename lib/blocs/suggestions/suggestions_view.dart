part of 'suggestions_bloc.dart';

class SuggestionsView extends StatefulWidget {
  @override
  State createState() => SuggestionsViewState();
}

class SuggestionsViewState extends State<SuggestionsView> {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Leave a Suggestion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              BlocConsumer<SuggestionsBloc, SuggestionsState>(
                listener: (context, state) {
                  if (state is SuggestionsSuccess) {
                    _formKey.currentState.reset();
                    _messageController.clear();
                    locator<ModalService>().showInSnackBar(
                        context: context, message: 'Suggestion submitted.');
                  }
                },
                builder: (context, state) {
                  if (state is SuggestionsLoading) {
                    return Spinner();
                  }

                  if (state is SuggestionsInitial ||
                      state is SuggestionsSuccess) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor:
                            Theme.of(context).textTheme.headline4.color,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _messageController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        validator: locator<ValidationService>().isEmpty,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline4.color,
                        ),
                        maxLines: 5,
                        maxLength: CRITIQUE_CHAR_LIMIT,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .color),
                            counterStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .color),
                            hintText: 'How can we improve the app?',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .color)),
                      ),
                    );
                  }

                  if (state is SuggestionsSuccess) {
                    return Center(
                      child: Text('Suggestion Sent'),
                    );
                  }

                  if (state is ErrorState) {
                    return Center(
                      child: Text('Error: ${state.error.message}'),
                    );
                  }

                  return Container();
                },
              ),
              Spacer(),
              FullWidthButton(
                buttonColor: Theme.of(context).buttonColor,
                textColor: Colors.white,
                onPressed: () async {
                  if (!_formKey.currentState.validate()) return;

                  if (!(await locator<ModalService>().showConfirmation(
                      context: context,
                      title: 'Submit',
                      message: 'Are you sure?'))) return;

                  context.read<SuggestionsBloc>().add(
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
      ),
    );
  }
}
