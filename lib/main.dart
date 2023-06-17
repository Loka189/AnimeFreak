import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
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
  int index = 0;
  var pages = [HomePage(), Search()];

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
          Color(0xff06142E),
          Color(0xff06142E),
        ])),
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Horizontal();
                  },
                ));
              },
              child: GradientText(
                colors: const [
                  Color(0xff7fb6e9),
                  Color(0xffb6d9f8),
                  Color(0xffe4f2ff)
                ],
                "AnimeFreak",
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: const Color(0xff1B3358)),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: const Color(0xff1B3358)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: const Color(0xff1B3358)),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: const Color(0xff1B3358)),
        ],
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
    );
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
