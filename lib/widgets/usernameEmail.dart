import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        Colors,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FontWeight,
        Icon,
        IconData,
        InkWell,
        MainAxisAlignment,
        Padding,
        Row,
        Text,
        TextStyle,
        Widget;
import 'package:get/get.dart';

import '../utils/constants.dart';

Widget buildShowUserNameAndEmail(
    {String? text, required Function onPress, IconData? icon}) {
  return Container(
    width: double.infinity,
    // padding: kDefaultPadding.copyWith(top: 8, bottom: 12),
    height: Get.height * 0.08,
    decoration: BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text!,
            // style: kTextStyle.copyWith(
            //   fontWeight: FontWeight.w600,
            // ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),

          InkWell(
            onTap: onPress(),
            child: Icon(
              icon,
              color: Colors.white70,
            ),
          ),
          // IconButton(onPressed: onPress, )
        ],
      ),
    ),
  );
}
