import 'package:critic/constants.dart';
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
          icon: Icon(model.movie == null
              ? MdiIcons.movieOpen
              : MdiIcons.movieOpenCheck),
          onPressed: () {
            /// Proceed to select movie page.
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
                if (model.movie == null) ...[
                  Text(
                      'Please select a movie first, (button in the top right)....'),
                ],
                if (model.movie != null) ...[
                  Expanded(
                    child: Column(
                      children: [
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
                if (model.movie != null) ...[
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
                                final bool? confirm =
                                    await _modalService.showConfirmation(
                                        context: context,
                                        title: 'Clear page',
                                        message: 'Are you sure?');

                                if (confirm == null || !confirm) return;

                                /// Clear message field.
                                _messageController.clear();
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
