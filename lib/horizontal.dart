import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Horizontal extends StatefulWidget {
  @override
  State<Horizontal> createState() => _HorizontalState();
}

class _HorizontalState extends State<Horizontal> {
  var titles = [];
  var episodes = [];
  var synopsis = [];
  var img = [];
  var rank = [];
  var year = [];
  var scores = [];
  void initState() {
    super.initState();

    getTopAnimeData();
  }

  Future<void> getTopAnimeData() async {
    var obj = provideTopAnime();
    var anime = await obj.getTopAnime();
    titles = anime['titles'];
    img = anime['images'];
    episodes = anime['episodes'];
    synopsis = anime['synopsis'];
    scores = anime['scores'];
    rank = anime['rank'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              color: const Color.fromARGB(255, 0, 0, 0),
              child: const Text(
                'AnimeFreak',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      width: 140,
                      color: Colors.white,
                      child: Image.network(
                        img[index],
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  );
                },
                itemCount: titles.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class provideTopAnime {
  Future<Map> getTopAnime() async {
    Response response =
        await get(Uri.parse('https://api.jikan.moe/v4/top/anime'));
    Map Alldata = jsonDecode(response.body);
    List data = Alldata['data'];
    int length = data.length;
    List titles = [];
    List IDs = [];
    List images = [];
    List episodes = [];
    List synopsis = [];
    List scores = [];
    List rank = [];
    List year = [];
    Map mainData = {
      'titles': titles,
      'IDs': IDs,
      'images': images,
      'episodes': episodes,
      'synopsis': synopsis,
      'scores': scores,
      'rank': rank,
      'year': year,
    };
    for (var i = 0; i < length; i++) {
      titles.add(data[i]['title_english']);
      IDs.add(data[i]['mal_id']);
      images.add(data[i]['images']['jpg']['small_image_url']);
      episodes.add(data[i]['episodes']);
      synopsis.add(data[i]['synopsis']);
      scores.add(data[i]['score']);
      rank.add(data[i]['rank']);
      year.add(data[i]['year']);
    }
    return mainData;
  }
}
