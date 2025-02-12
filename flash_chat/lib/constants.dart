import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: const Color(0xff0f3057),
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(

  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: const Color(0xff0f3057), width: 2.0),
  ),
);
