import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomIconBox extends StatelessWidget {
  final IconButton iconButton;

  const CustomIconBox({Key? key, required this.iconButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: context.theme.canvasColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.withAlpha(40),
          width: 2,
        ),
      ),
      child: iconButton,
    );
  }
}
