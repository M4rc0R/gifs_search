import 'package:flutter/material.dart';
import 'package:gifs_search/UI/gif_page.dart';
import 'package:gifs_search/UI/home_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      hintColor: Color(0xFFdbdbdb),
      primaryColor: Color(0xFFdbdbdb),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFdbdbdb))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFdbdbdb))),
        hintStyle: TextStyle(color: Color(0xFFdbdbdb)),
      ),
    ),
  ));
}
