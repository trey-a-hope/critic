import 'package:flutter/material.dart';

class ExploreTab extends StatelessWidget {
  final IconData iconData;
  final String title;

  const ExploreTab({
    Key? key,
    required this.iconData,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Theme.of(context).iconTheme.color,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
