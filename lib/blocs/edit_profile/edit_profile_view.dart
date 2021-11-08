part of 'edit_profile_bloc.dart';

class EditProfileView extends StatefulWidget {
  @override
  State createState() => EditProfileViewState();
}

class EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _usernameController = TextEditingController();
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
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              BlocConsumer<EditProfileBloc, EditProfileState>(
                listener: (context, state) {
                  if (state is EditProfileLoaded) {
                    final UserModel user = state.currentUser;
                    _usernameController.text = user.username;
                  }
                },
                builder: (context, state) {
                  if (state is EditProfileLoading ||
                      state is EditProfileInitial) {
                    return Spinner();
                  }

                  if (state is EditProfileLoaded) {
                    return Padding(
                      padding: EdgeInsets.all(40),
                      child: TextFormField(
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline6!.color),
                        cursorColor:
                            Theme.of(context).textTheme.headline5!.color,
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        validator: locator<ValidationService>().isEmpty,
                        textInputAction: TextInputAction.done,
                        maxLines: 1,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6!.color),
                          hintText: 'Username',
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6!.color),
                        ),
                      ),
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
                buttonColor: Theme.of(context).canvasColor,
                textColor: Colors.white,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  bool? confirm = (await locator<ModalService>()
                      .showConfirmation(
                          context: context,
                          title: 'Submit',
                          message: 'Are you sure?'));

                  if (confirm == null || !confirm) return;

                  context.read<EditProfileBloc>().add(
                        Save(
                          username: _usernameController.text,
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
