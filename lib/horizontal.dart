import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:simple_gradient_text/simple_gradient_text.dart';

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
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff06142E),
          Color(0xff06142E),
        ])),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xff06142E),
                Color(0xff06142E),
              ])),
              child: GradientText(
                colors: const [
                  Color(0xff7fb6e9),
                  Color(0xffb6d9f8),
                  Color(0xffe4f2ff)
                ],
                'AnimeFreak',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Container(
              height: 260,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Top Anime',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: const Color(0xff135c84),
                                title: const Text(
                                  'Top Anime',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var i = 0; i < titles.length; i++)
                                        Text(
                                          '${i + 1}. ${titles[i]}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ))
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'see all>',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: titles.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          color: const Color.fromARGB(255, 9, 29, 67),
                          child: Container(
                            width: 150,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          backgroundColor:
                                              const Color(0xff135c84),
                                          title: Text(
                                            titles[index],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Text(
                                              synopsis[index],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Close',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ))
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Image.network(
                                    img[index],
                                    height: 180,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      titles[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.amber),
                                        Text(
                                          '${scores[index]}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '##${rank[index]}',
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
      images.add(data[i]['images']['jpg']['large_image_url']);
      episodes.add(data[i]['episodes']);
      synopsis.add(data[i]['synopsis']);
      scores.add(data[i]['score']);
      rank.add(data[i]['rank']);
      year.add(data[i]['year']);
    }
    return mainData;
  }
}
//  Color(0xff7fb6e9),
//                                         Color(0xffb6d9f8),
//                                         Color(0xffe4f2ff)