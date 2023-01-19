import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

PreferredSize buildAppBar({
  required BuildContext context,
  required IconData leadingIcon,
  required String title,
  required List<Widget> actions,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(48.0),
    child: AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            leadingIcon,
            color: Colors.black,
          )),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        // style: kOnBoardHeadingTextStyle.copyWith(
        //   fontSize: Get.height * 0.028,
        // ),
      ),
      centerTitle: true,
      actions: actions,
    ),
  );
}
