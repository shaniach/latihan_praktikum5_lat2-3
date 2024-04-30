import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Universitas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UniversityList(),
    );
  }
}

class UniversityList extends StatefulWidget {
  @override
  _UniversityListState createState() => _UniversityListState();
}

class _UniversityListState extends State with WidgetsBindingObserver {
  List<dynamic> universitas = [];

  @override
  void initState() {
    super.initState();
    fetchUniversitas();
  }

  Future<void> fetchUniversitas() async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));
    if (response.statusCode == 200) {
      setState(() {
        universitas = json.decode(response.body);
      });
    } else {
      throw Exception('Gagal menampilkan universitas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Perguruan Tinggi di Indonesia'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: universitas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: universitas.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.black,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Center(child: Text(universitas[index]['name'])),
                  subtitle:
                      Center(child: Text(universitas[index]['web_pages'][0])),
                );
              },
            ),
    );
  }
}
