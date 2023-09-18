import 'dart:convert';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MyMovies extends StatefulWidget {
  const MyMovies({super.key});

  @override
  State<MyMovies> createState() => _MyMoviesState();
}

class _MyMoviesState extends State<MyMovies> {
  var titles = [];
  var id = [];
  var rank = [];
  var year = [];
  var image = [];
  var imdbRating = [];
  var imdbRatingCount = [];
  var showName = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  Future<void> getMovies() async {
    var obj = topIMDBmovies();
    var data1 = await obj.getTopIMDBmovies();
    setState(() {
      titles = data1['title'];
      id = data1['id'];
      rank = data1['rank'];
      year = data1['year'];
      image = data1['image'];
      imdbRating = data1['imdb'];
      imdbRatingCount = data1['imdbRatingCount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: const Color(0xff06142E),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    'MoviesMania',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xff1B3358),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: showName,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.white,
                    cursorHeight: 18,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                        hintText: 'Search ',
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(178, 255, 255, 255),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xff1B3358)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xff1B3358),
                            ),
                            borderRadius: BorderRadius.circular(30)),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            var obj = getMovieGiveID(showName.text);
                            var x = await obj.getID();
                            print(x);
                          },
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        )),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Top IMDB Movies',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Top IMDB Movies',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (var i = 0; i < titles.length; i++)
                                      ListTile(
                                        leading: image[i] == null
                                            ? const Text('No Image')
                                            : Image.network(
                                                image[i],
                                                height: 200,
                                                width: 150,
                                              ),
                                        title: Text(
                                          titles[i],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        subtitle: Text(
                                          'IMDB Rating: ${imdbRating[i]}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                    )
                  ],
                ),
                Container(
                  height: 260,
                  child: Column(
                    children: [
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
                                  image[index] == null
                                      ? const Text('No Image')
                                      : Image.network(
                                          image[index],
                                          height: 200,
                                          width: 150,
                                        ),
                                  Expanded(
                                      child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      titles[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 17,
                                      ),
                                    ),
                                  )),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'imdb ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                backgroundColor: Colors.blue,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            imdbRating[index],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        year[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ))
                    ],
                  ),
                ),
              ],
            ),
            // Container(
            //   height: 20,
            //   color: Color.fromARGB(255, 21, 37, 114),
            // ),
          ],
        ),
      ),
    );
  }
}

class topIMDBmovies {
  Future<Map> getTopIMDBmovies() async {
    Response response = await get(
        Uri.parse('https://imdb-api.com/en/API/Top250Movies/k_hzk3kn2g'));
    Map allData = jsonDecode(response.body);
    List top250 = allData['items'];
    int length = top250.length;
    List id = [];
    List title = [];
    List rank = [];
    List year = [];
    List image = [];
    List imdb = [];
    List imdbRatingCount = [];
    Map data = {
      'id': id,
      'title': title,
      'rank': rank,
      'year': year,
      'image': image,
      'imdb': imdb,
      'imdbRatingCount': imdbRatingCount
    };
    for (int i = 0; i < length; i++) {
      id.add(top250[i]['id']);
      title.add(top250[i]['title']);
      rank.add(top250[i]['rank']);
      year.add(top250[i]['year']);
      image.add(top250[i]['image']);

      imdb.add(top250[i]['imDbRating']);
      imdbRatingCount.add(top250[i]['imDbRatingCount']);
    }
    return data;
  }
}

class getMovieGiveID {
  var showName;
  getMovieGiveID(this.showName);
  Future<int> getID() async {
    Response response = await get(
        Uri.parse('https://imdb-api.com/en/API/Search/k_hzk3kn2g/$showName'));
    Map allData = jsonDecode(response.body);
    List results = allData['results'];
    return results.length;
  }
}
