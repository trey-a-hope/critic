import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/recipe_model.dart';
import 'package:critic/repositories/recipe_repository.dart';
import 'package:critic/ui/drawer/drawer_view.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'rowy_view_model.dart';

class RowyView extends StatelessWidget {
  RowyView({Key? key}) : super(key: key);

  /// Key that holds the current state of the scaffold.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_RowyViewModel>(
      init: _RowyViewModel(),
      builder: (model) => BasicPage(
        scaffoldKey: _scaffoldKey,
        drawer: DrawerView(),
        child: Scaffold(
          body: model.isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(controller: model.foodItemController)
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => model.submit(),
                      child: Text('Submit'),
                    ),
                    Divider(),
                    Text(model.recipe.title, style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold,)),
         Padding(padding: EdgeInsets.symmetric(vertical: 10), child:            CircleAvatar(
           radius: 50,
           backgroundImage: NetworkImage(
             model.recipe.image[0]['downloadURL'],
           ),
         ),),

                Expanded(child:     Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(children: [Text(
                    model.recipe.instructions,
                    textAlign: TextAlign.center,
                  ),],)
                ),),
                  ],
                ),
          // body: ListView.builder(itemCount: 1,  itemBuilder: (_, index) => ListTile(title: Text(model.recipe.title),),)
        ),
        title: 'Recipe',
      ),
    );
  }
}
