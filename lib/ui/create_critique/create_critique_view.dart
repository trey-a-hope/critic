import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/validation_service.dart';
import 'package:critic/ui/drawer/drawer_view.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'create_critique_view_model.dart';

class CreateCritiqueView extends StatelessWidget {
  CreateCritiqueView({Key? key}) : super(key: key);

  /// Editing controller for message on critique.
  final TextEditingController _messageController = TextEditingController();

  /// Key for the scaffold.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Key for the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Instantiate validation service.
  final ValidationService _validationService = Get.find();

  /// Instantiate modal service.
  final ModalService _modalService = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateCritiqueViewModel>(
      init: CreateCritiqueViewModel(),
      builder: (model) => BasicPage(
        scaffoldKey: _scaffoldKey,
        leftIconButton: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        rightIconButton: IconButton(
          icon: Icon(model.movieSelected()
              ? MdiIcons.movieOpenCheck
              : MdiIcons.movieOpen),
          onPressed: () async {
            /// Proceed to select movie page.
            MovieModel movie =
                (await Get.toNamed(Globals.ROUTES_SEARCH_MOVIES)) as MovieModel;

            model.updateMovie(movie: movie);
          },
        ),
        title: 'Create Critique',
        drawer: DrawerView(),
        child: Container(
          color: Theme.of(context).canvasColor,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!model.movieSelected()) ...[
                  Text(
                      'Please select a movie first, (button in the top right)....'),
                ],
                if (model.movieSelected()) ...[
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          margin: EdgeInsets.only(bottom: 20.0),
                          height: 300,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    Get.toNamed(
                                      Globals.ROUTES_MOVIE_DETAILS,
                                      arguments: {
                                        'movie': model.movie!,
                                      },
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: '${model.movie!.poster}',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(5.0, 5.0),
                                              blurRadius: 10.0)
                                        ],
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SelectableText(
                                        model.movie!.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      Divider(),
                                      Text(
                                        '${model.movie!.plot}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ],
                                  ),
                                  margin:
                                      EdgeInsets.only(top: 20.0, bottom: 20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    color: Theme.of(context).canvasColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(5.0, 5.0),
                                          blurRadius: 10.0)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor:
                                Theme.of(context).textTheme.headline4!.color,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _messageController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            validator: _validationService.isEmpty,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline4!.color,
                            ),
                            maxLines: 5,
                            maxLength: CRITIQUE_CHAR_LIMIT,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .color),
                              counterStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .color),
                              hintText:
                                  'What do you think about this movie/show?',
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .color,
                              ),
                            ),
                            onChanged: (val) {
                              model.updateMessage(message: val);
                            },
                          ),
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              model.updateRating(rating: rating);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                if (model.movieSelected()) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Reset',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () async {
                                /// Ask user about resetting page.
                                final bool? confirm =
                                    await _modalService.showConfirmation(
                                        context: context,
                                        title: 'Reset',
                                        message: 'Are you sure?');

                                if (confirm == null || !confirm) return;

                                /// Clear message field.
                                _messageController.clear();

                                /// Reset movie selection.
                                model.clearMovie();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(color: Colors.white),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              child: Text('Save'),
                              onPressed: () async {
                                /// Validate form.
                                final bool formValid =
                                    _formKey.currentState!.validate();

                                /// Return if invalid.
                                if (!formValid) return;

                                /// Ask user if they want to submit critique.
                                final bool? confirm =
                                    await _modalService.showConfirmation(
                                        context: context,
                                        title: 'Submit Critique',
                                        message: 'Are you sure?');

                                /// Return if not true.
                                if (confirm == null || !confirm) return;

                                /// Proceed to save critique.
                                bool success = await model.saveCritique();

                                /// Show success or error message based on response.
                                if (success) {
                                  Get.snackbar(
                                    'Success',
                                    'Your critique has been posted.',
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'There was an issue posting your critique.',
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
