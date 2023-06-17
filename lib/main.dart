import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'horizontal.dart';
import 'search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Testing',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var titles = [];
  var episodes = [];
  var synopsis = [];
  var img = [];
  var rank = [];
  var year = [];
  var scores = [];

  @override
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
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        const Color(0xff135c84),
        const Color(0xff80d0c7),
      ])),
      child: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Horizontal();
                },
              ));
            },
            child: const Text(
              "AnimeFreak",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ListTile(
                    leading: Image.network(img[index]),
                    title: Text(
                      titles[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      'Rank: ${rank[index]}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: const Color(0xff135c84),
                            title: Text(
                              titles[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                            content: SingleChildScrollView(
                              child: Text(
                                synopsis[index],
                                style: const TextStyle(color: Colors.white),
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
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.home, color: Colors.white, size: 35),
                  const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const Search();
                    },
                  ));
                },
                child: Column(
                  children: [
                    Icon(Icons.search, color: Colors.white, size: 35),
                    const Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(Icons.person, color: Colors.white, size: 35),
                  const Text(
                    'Profile',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  Icon(Icons.settings, color: Colors.white, size: 35),
                  const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    ));
  }
}

// ignore: camel_case_types
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
