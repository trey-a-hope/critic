import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/createCritique/CreateCritiqueBloc.dart';
import 'package:critic/blocs/createCritique/CreateCritiqueEvent.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/MovieView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateCritiqueBloc _createCritiqueBloc;

  @override
  void initState() {
    _createCritiqueBloc = BlocProvider.of<CreateCritiqueBloc>(context);
    _createCritiqueBloc.setDelegate(delegate: this);
    super.initState();
  }

  Widget _buildBottomSheetForm() {
    return Container(
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _critiqueController,
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
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: RaisedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          _critiqueController.clear();
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          child: Text('Save'),
                          onPressed: () async {
                            final bool formValid =
                                _formKey.currentState.validate();

                            if (!formValid) return;

                            final bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Submit Critique',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            Navigator.of(context).pop();

                            _createCritiqueBloc.add(
                              SubmitEvent(
                                critique: _critiqueController.text,
                              ),
                            );
                          },
                          color: Colors.red,
                          textColor: Colors.white,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomSheet: InkWell(
        onTap: () {
          var bottomSheetController = showModalBottomSheet(
            isDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return _buildBottomSheetForm();
            },
          );
        },
        child: Container(
          color: Colors.red,
          height: 60,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Write Critique About Movie',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: COLOR_NAVY,
        title: Text(
          'Movie Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      body: BlocBuilder<CreateCritiqueBloc, CreateCritiqueState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is CreateCritiqueStartState) {
            final MovieModel movie = state.movie;

            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          // color: Colors.black,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken),
                              image: AssetImage('assets/images/theater.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Image.network(movie.poster),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      movie.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // MovieView(
                        //   movieModel: movie,
                        // ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.note),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Plot',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                movie.plot,
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Director & Actors',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('${movie.director} - ${movie.actors}'),
                              Divider(),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Released',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                movie.released,
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Icon(Icons.rate_review),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'IMDB Rating',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${movie.imdbRating}/10 (${movie.imdbVotes} votes)'),
                              Divider(),
                              Row(
                                children: [
                                  Icon(Icons.rate_review),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Genre',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                movie.genre,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
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
        .showAlert(context: context, title: 'Success', message: message);
  }

  @override
  void clearText() {
    _critiqueController.clear();
  }
}
