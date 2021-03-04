import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:provider/provider.dart' as providers;
import "models/truck.dart" as models;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<models.Trucks> getList() {
    models.Trucks rslt = models.Trucks(DateTime.now(), []);
    rslt.update();
    return Future.value(rslt);
    //delayed(Duration(seconds: 3), () => rslt);
  }

  Future<void> updateList(models.Trucks trucks) async {
    trucks.update();
    //await Future.delayed(Duration(seconds: 3));
  }

  Future<void> _selectDate(BuildContext context, models.Trucks trukc) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(new Duration(days: 7)));
    if (picked != null && picked != trukc.mdate) trukc.updateDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: providers.MultiProvider(
          providers: [
            providers.FutureProvider<models.Trucks>(
              create: (context) => getList(),
              initialData: null,
            ),
            providers.ChangeNotifierProxyProvider<models.Trucks, models.Trucks>(
              create: null,
              update: (context, value, previous) => value,
            )
          ],
          child: providers.Consumer<models.Trucks>(
            builder: (context, value, child) {
              if (value == null)
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              else
                return Scaffold(
                  body: RefreshIndicator(
                    child: CustomScrollView(
                      slivers: [
                        _MyAppBar(value, () => _selectDate(context, value)),
                        SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return //Text(value.items[index].name);
                                Card(
                              child: ListTile(
                                title: Text(value.items[index].truckName),
                                leading: Icon(Icons.local_shipping),
                                trailing: Text(
                                    value.items[index].available.toString()),
                                //trailing: Icon(Icons.access_alarm),
                                //subtitle: Text('18'),
                              ),
                            );
                          },
                          childCount: value.items.length,
                        ))
                      ],
                    ),
                    onRefresh: () => updateList(value),
                  ),
                );
            },
          )),
      theme: appTheme,
    );
  }
}

class _MyAppBar extends StatelessWidget {
  _MyAppBar(this.m_trucs, this.onselectDate);
  final VoidCallback onselectDate;
  final models.Trucks m_trucs;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text( m_trucs.mdate.toString().substring(0, 10),
          style: Theme.of(context).textTheme.headline1),
      floating: true,
      actions: [
        IconButton(
          icon: Icon(Icons.today),
          onPressed: () => onselectDate(),
        ),
      ],
    );
  }
}
