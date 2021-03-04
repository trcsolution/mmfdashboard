//import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class Truck extends ChangeNotifier {
  Truck({this.truckName, this.date, this.capacity, this.available});
  String truckName;
  DateTime date;
  int capacity;
  int available;
  Truck.fromJson(Map<String, dynamic> json) {
    truckName = json['truckName'];
    capacity = json['capacity'];
    available = json['available'];
    DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ssZ"); //dd.MM.yyyy
    date = format.parse(json['date']);

    //date = DateFormat('MMMM d, yyyy', 'en_US').parse(json['date']));
    //date = json['date'];
  }
}

class Trucks extends ChangeNotifier {
  Trucks(this.mdate, this.items);
  DateTime mdate;
  List<Truck> items;

  void updateDate(DateTime date) async {
    mdate = date;
    items = await this.getList();
    notifyListeners();
  }

  void update() async {
    items = await this.getList();
    notifyListeners();
  }

  Future<List<Truck>> getList() async {
    var responseData = await http.get("http://68.183.255.173/api/dashboard");
    var jsonResponse = convert.jsonDecode(responseData.body);

    var items = List.from(jsonResponse);
    List<Truck> rslt = [];
    for (var item in items) {
      var d = Truck.fromJson(item);
      if (DateFormat('yyyy-MM-dd').format(d.date) ==
          DateFormat('yyyy-MM-dd').format(this.mdate)) rslt.add(d);
    }

    // for (int i = 0; i < 100; i++) {
    //   rslt.add(Truck(
    //       truckName: DateTime.now().toString(),
    //       date: DateTime.now(),
    //       available: i));
    // }
    return Future.value(rslt);
  }
}
