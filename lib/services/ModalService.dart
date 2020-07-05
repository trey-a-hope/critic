import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ServiceLocator.dart';
import 'ValidationService.dart';

enum Categories {
  GoodMorning,
  GoodAfternoon,
  GoodNight,
  HappyBirthday,
  HappyAnniversary,
  Congrats,
  Apology,
  Condolence
}

abstract class IModalService {
  void showInSnackBar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required String message});

  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message});
  Future<String> showPasswordResetEmail({@required BuildContext context});
  Future<String> showChangeEmail({@required BuildContext context});
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String message});
  Future<bool> showConfirmationWithImage(
      {@required BuildContext context,
      @required String title,
      @required String message,
      @required File file});

  Future<Categories> showCategoryOptionsDialog(
      {@required BuildContext context, @required String title});

  Future<int> showOptions(
      {@required BuildContext context,
      @required String title,
      @required List<String> options});
}

class ModalService extends IModalService {
  Future<Categories> showCategoryOptionsDialog(
      {@required BuildContext context, @required String title}) async {
    if (Platform.isIOS) {
      return await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          List<CupertinoActionSheetAction> actions = [
            CupertinoActionSheetAction(
              child: Text('Good Morning'),
              onPressed: () {
                Navigator.pop(context, Categories.GoodMorning);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Good Afternoon'),
              onPressed: () {
                Navigator.pop(context, Categories.GoodAfternoon);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Good Night'),
              onPressed: () {
                Navigator.pop(context, Categories.GoodNight);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Happy Birthday'),
              onPressed: () {
                Navigator.pop(context, Categories.HappyBirthday);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Happy Anniversary'),
              onPressed: () {
                Navigator.pop(context, Categories.HappyAnniversary);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Congrats'),
              onPressed: () {
                Navigator.pop(context, Categories.Congrats);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Apology'),
              onPressed: () {
                Navigator.pop(context, Categories.Apology);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Condolence'),
              onPressed: () {
                Navigator.pop(context, Categories.Condolence);
              },
            ),
          ];

          return CupertinoActionSheet(
            title: Text(title),
            actions: actions,
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        },
      );
    } else {
      return await showDialog<Categories>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          if (Platform.isIOS) {
            return null;
          } else {
            return SimpleDialog(
              title: Text(title),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Categories.GoodMorning);
                  },
                  child: Text('Good Morning'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Categories.GoodAfternoon);
                  },
                  child: Text('Good Afternoon'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Categories.GoodNight);
                  },
                  child: Text('Good Night'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Categories.HappyBirthday);
                  },
                  child: Text('Happy Birthday'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Categories.HappyAnniversary);
                  },
                  child: Text('Happy Anniversary'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Categories.Congrats);
                  },
                  child: Text('Congrats'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Categories.Apology);
                  },
                  child: Text('Apology'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, Categories.Condolence);
                  },
                  child: Text('Condolence'),
                )
              ],
            );
          }
        },
      );
    }
  }

  @override
  void showInSnackBar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required String message}) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Future<String> showPasswordResetEmail({@required BuildContext context}) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Reset Password'),
        content: Form(
          key: formKey,
          autovalidate: autovalidate,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            maxLengthEnforced: true,
            // maxLength: MyFormData.nameCharLimit,
            onFieldSubmitted: (term) {},
            validator: locator<ValidationService>().email,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'Email',
              icon: Icon(Icons.email),
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('SUBMIT'),
            onPressed: () {
              final FormState form = formKey.currentState;
              if (!form.validate()) {
                autovalidate = true;
              } else {
                Navigator.of(context).pop(emailController.text);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Future<String> showChangeEmail({@required BuildContext context}) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Change Email'),
        content: Form(
          key: formKey,
          autovalidate: autovalidate,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            maxLengthEnforced: true,
            // maxLength: MyFormData.nameCharLimit,
            onFieldSubmitted: (term) {},
            validator: locator<ValidationService>().email,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'New Email',
              icon: Icon(Icons.email),
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('SUBMIT'),
            onPressed: () {
              final FormState form = formKey.currentState;
              if (!form.validate()) {
                autovalidate = true;
              } else {
                Navigator.of(context).pop(emailController.text);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: const Text('YES', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: const Text('NO', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Future<bool> showConfirmationWithImage(
      {@required BuildContext context,
      @required String title,
      @required String message,
      @required File file}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Center(
          child: Image.file(file),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'NO',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: const Text(
              'YES',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }

  @override
  Future<int> showOptions(
      {@required BuildContext context,
      @required String title,
      @required List<String> options}) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          List<CupertinoActionSheetAction> actions =
              List<CupertinoActionSheetAction>();

          //Build actions based on optino titles.
          for (var i = 0; i < options.length; i++) {
            actions.add(
              CupertinoActionSheetAction(
                child: Text(options[i]),
                onPressed: () {
                  Navigator.of(context).pop(i);
                },
              ),
            );
          }

          return CupertinoActionSheet(
            title: Text(title),
            actions: actions,
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        },
      );
    } else {
      return await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          List<ListTile> actions = List<ListTile>();

          actions.add(
            ListTile(
              title: Text(title),
            ),
          );

          for (var i = 0; i < options.length; i++) {
            actions.add(
              ListTile(
                title: Text(options[i]),
                onTap: () {
                  Navigator.of(context).pop(i);
                  //return i;
                },
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: actions,
          );
        },
      );
    }
  }
}
