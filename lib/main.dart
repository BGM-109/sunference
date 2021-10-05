import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future getData() async {
    var url =
        "https://raw.githubusercontent.com/junsuk5/mock_json/main/conferences.json";
    var uri = Uri.parse(url);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List data = convert.jsonDecode(response.body);
      return data;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conference',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Conference"),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const Divider(height: 1,color: Colors.white,),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]["name"]),
                        subtitle: Text(snapshot.data[index]["location"]),
                        onTap: (){},
                      );
                    });
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error!!!!!"));
              } else {
                return const CircularProgressIndicator();
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            getData();
          },
        ),
      ),
    );
  }
}
