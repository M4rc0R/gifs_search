import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:gifs_search/UI/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty)
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=3kCJR5MrQ4VXrdDzq10a2ZxvGTA3uX57&limit=25&rating=g'));
    else
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=3kCJR5MrQ4VXrdDzq10a2ZxvGTA3uX57&q=$_search&limit=19&offset=$_offset&rating=g&lang=en"));

    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF85c7f2),
        title: Text(
          "Gif's Search",
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF4c4c4c),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise um gif aqui",
                  labelStyle: TextStyle(color: Color(0xFFdbdbdb)),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Future<void> share(String link) async {
    await FlutterShare.share(
        title: 'Compartilhar Gif',
        text: 'Compartilhe com quem desejar essa gif...',
        linkUrl: link,
        chooserTitle: null);
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length) {
            return GestureDetector(
                child: FadeInImage.memoryNetwork(placeholder: kTransparentImage,
                  image: snapshot
                      .data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
                onTap: ()
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GifPage(snapshot.data["data"][index])),
              );
            },
          onLongPress: () {
          share(snapshot.data['data'][index]['images']['fixed_height']
              .toString());
          },
          );
          } else {
          return Container(
          child: GestureDetector(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(
          Icons.add,
          color: Colors.white,
          size: 70.0,
          ),
          Text(
          "Carregar mais...",
          style: TextStyle(color: Colors.white, fontSize: 22.0),
          )
          ],
          ),
          onTap: () {
          setState(() {
          _offset += 19;
          });
          },
          ),
          );
          }
        });
  }
}
