import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).indicatorColor),
            strokeWidth: 3.0,
          ),
          SizedBox(height: 20),
          Text(
            'Loading...',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
