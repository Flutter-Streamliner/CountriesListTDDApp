import 'package:countries_ttd/features/countries_list/presentation/pages/countries_list_page.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries App',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: CountriesListPage(),
    );
  }
}