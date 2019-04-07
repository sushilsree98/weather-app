import 'package:flutter/material.dart';
import 'UI/climate.dart';

void main(){
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"weather app",
      home:climate(),
    )
  );
}