import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  const GifPage(this._gifData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Color(0xFF85c7f2),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                share();
              },
              icon: Icon(Icons.share))
        ],
      ),
      backgroundColor: Color(0xFF4c4c4c),
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }


  Future<void> share() async {
    await FlutterShare.share(
        title: 'Compartilhar Gif',
        text: 'Compartilhe com quem desejar essa gif...',
        linkUrl: _gifData["images"]["fixed_height"]["url"],
        chooserTitle: _gifData["title"]);
  }
}
