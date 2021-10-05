import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:url_launcher/url_launcher.dart';

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
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          height: 1,
                          color: Colors.white,
                        ),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]["name"]),
                        subtitle: Text(snapshot.data[index]["location"]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                    location: snapshot.data[index])),
                          );
                        },
                      );
                    });
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error!!!!!"));
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.location}) : super(key: key);

  final Map<String, dynamic> location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(location["name"],
                  style: const TextStyle(
                      fontSize: 32.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(location["location"]),
              const SizedBox(height: 8.0),
              Text("${location["start"]} ~ ${location["end"]}"),
              TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft),
                  onPressed: () async {
                    String url = location["link"];
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Cant not launch $url';
                    }
                  },
                  child: const Text(
                    "Go to Official Website",
                  )),
            ],
          ),
        ));
  }
}
