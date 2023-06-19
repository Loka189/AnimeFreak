import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var animeName = TextEditingController();
  var mainData = {};
  var titles = [];
  var engtitles = [];
  var episodes = [];
  var synopsis = [];
  var img = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff06142E),
                Color(0xff06142E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xff1B3358),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: Colors.white,
                  cursorHeight: 18,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  controller: animeName,
                  decoration: InputDecoration(
                    hintText: 'Enter Anime Name',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(178, 255, 255, 255),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff1B3358)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff1B3358),
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          var obj = GetAnimeNameProvideDetails(animeName.text);
                          var array = await obj.fetchingData();
                          titles = array['title'];
                          engtitles = array['title_in_eng'];
                          episodes = array['episodes'];
                          synopsis = array['synopsis'];
                          img = array['images'];
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(
                      img[index],
                      scale: 1,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      engtitles[index],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'Total episodes: ${episodes[index].toString()}',
                      style: const TextStyle(
                        color: Color.fromARGB(218, 255, 255, 255),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: const Color(0xff1B3358),
                            title: Text(
                              titles[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                            content: SingleChildScrollView(
                              child: Text(
                                synopsis[index],
                                style: const TextStyle(
                                    color: Color.fromARGB(224, 255, 255, 255),
                                    fontSize: 18),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'close',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white),
                                  ))
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              )),
            ],
          )),
    );
  }
}

class GetAnimeNameProvideDetails {
  var animeName;
  GetAnimeNameProvideDetails(this.animeName);
  Future<Map> fetchingData() async {
    Response response =
        await get(Uri.parse('https://api.jikan.moe/v4/anime?q=$animeName&sfw'));
    Map Alldata = jsonDecode(response.body);
    List data = Alldata['data'];
    int length = data.length;
    List title = [];
    List Engtitle = [];
    List episodes = [];
    List synopsis = [];
    List images = [];
    Map y = {
      'title': title = [],
      'title_in_eng': Engtitle = [],
      'episodes': episodes = [],
      'synopsis': synopsis = [],
      'images': images = []
    };
    for (var i = 0; i < length; i++) {
      title.add(data[i]['title']);
      Engtitle.add(data[i]['title_english']);
      episodes.add(data[i]['episodes']);
      synopsis.add(data[i]['synopsis']);
      images.add(data[i]['images']['jpg']['small_image_url']);
    }
    return y;
  }
}
