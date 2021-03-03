//import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert' as convert;

class Truck extends ChangeNotifier {
  Truck({this.name, this.date, this.available});
  final String name;
  final DateTime date;
  final int available;
}

class Trucks extends ChangeNotifier {
  Trucks(this.items);
  List<Truck> items;

  void update() async {
    items = await this.getList();
    notifyListeners();
  }

  Future<List<Truck>> getList() {
    List<Truck> rslt = [];
    for (int i = 0; i < 100; i++) {
      rslt.add(Truck(
          name: DateTime.now().toString(), date: DateTime.now(), available: i));
    }
    return Future.value(rslt);
  }
}
