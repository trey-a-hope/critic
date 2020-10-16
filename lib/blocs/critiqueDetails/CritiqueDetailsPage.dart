import 'package:critic/Constants.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/MovieView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class CritiqueDetailsPage extends StatefulWidget {
  @override
  State createState() => CritiqueDetailsPageState();
}

class CritiqueDetailsPageState extends State<CritiqueDetailsPage>
    implements CritiqueDetailsBlocDelegate {
  CritiqueDetailsBloc _critiqueDetailsBloc;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _critiqueDetailsBloc = BlocProvider.of<CritiqueDetailsBloc>(context);
    _critiqueDetailsBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CritiqueDetailsBloc, CritiqueDetailsState>(
      builder: (BuildContext context, CritiqueDetailsState state) {
        if (state is LoadingState) {
          return Scaffold(
            appBar: AppBar(),
            body: Spinner(),
          );
        }

        if (state is LoadedState) {
          final CritiqueModel critique = state.critiqueModel;
          final UserModel currentUser = state.currentUser;
          final UserModel critiqueUser = state.critiqueUser;
          final MovieModel movie = state.movieModel;

          bool liked = false;

          return Scaffold(
              appBar: AppBar(
                title: Text('${critique.movieTitle}'),
              ),
              floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                // child: Icon(Icons.add),
                onOpen: () => print('OPENING DIAL'),
                onClose: () => print('DIAL CLOSED'),
                // visible: dialVisible,
                curve: Curves.bounceIn,
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.favorite, color: Colors.white),
                    backgroundColor: Colors.red,
                    onTap: () => print('FIRST CHILD'),
                    label: 'Like',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    labelBackgroundColor: Colors.red,
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.comment, color: Colors.white),
                    backgroundColor: Colors.blue,
                    onTap: () => print('SECOND CHILD'),
                    label: 'Post Comment',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    labelBackgroundColor: Colors.blue,
                  ),
                  currentUser.uid == critique.uid
                      ? SpeedDialChild(
                          child: Icon(Icons.delete, color: Colors.white),
                          backgroundColor: Colors.black,
                          onTap: () async {
                            final bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Delete Critique',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            _critiqueDetailsBloc.add(
                              DeleteCritiqueEvent(),
                            );
                          },
                          label: 'Delete',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          labelBackgroundColor: Colors.black,
                        )
                      : SpeedDialChild(
                          child: Icon(Icons.report, color: Colors.white),
                          backgroundColor: Colors.black,
                          onTap: () async {
                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Report Critique',
                                    message:
                                        'If this material was abusive, disrespectful, or uncomfortable, let us know please. This post will become flagged and removed from your timeline.');

                            if (!confirm) return;

                            _critiqueDetailsBloc.add(
                              ReportCritiqueEvent(),
                            );
                          },
                          label: 'Report',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          labelBackgroundColor: Colors.black,
                        ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    MovieView(
                      movieModel: movie,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage('${critiqueUser.imgUrl}'),
                      ),
                      title: Text('${critiqueUser.username}'),
                      trailing: Text(
                        '${timeago.format(critique.created, allowFromNow: true)}',
                      ),
                    ),
                    Container(
                      color: COLOR_NAVY,
                      width: double.infinity,
                      height: 100,
                      child: Center(
                        child: Padding(
                          child: Text(
                            '\"${critique.message}\"',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                    ),

                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Text(
                              'View All Comments',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              locator<ModalService>().showAlert(
                                  context: context,
                                  title: 'todo',
                                  message: 'todo');
                            },
                          )
                        ],
                      ),
                    )
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 40),
                    //   child: TextFormField(
                    //     controller: _commentController,
                    //     keyboardType: TextInputType.text,
                    //     textInputAction: TextInputAction.done,
                    //     validator: locator<ValidationService>().isEmpty,
                    //     maxLines: 2,
                    //     maxLength: 150,
                    //     maxLengthEnforced: true,
                    //     decoration: InputDecoration(
                    //         hintText:
                    //             'What do you think about ${critiqueUser.username}\'s critique?'),
                    //   ),
                    // ),
                    // FullWidthButton(
                    //   text: 'Post Comment',
                    //   buttonColor: Colors.grey,
                    //   textColor: Colors.white,
                    //   onPressed: () {},
                    // )
                  ],
                ),
              ));
        }

        if (state is ErrorState) {
          return Center(
            child: Text('Error: ${state.error.toString()}'),
          );
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showAlert(context: context, title: '', message: message);
  }
}
