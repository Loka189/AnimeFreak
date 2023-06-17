import 'package:flutter/material.dart';
import 'package:initstate/homepage.dart';
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
  int index = 0;
  var pages = [const HomeScreen(), const Search()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff06142E),
          Color(0xff06142E),
        ])),
        child: pages[index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff1B3358),
        selectedIconTheme: const IconThemeData(
            color: Color(
              0xffb6d9f8,
            ),
            size: 35),
        selectedItemColor: const Color(0xffe4f2ff),
        unselectedIconTheme:
            const IconThemeData(color: Color(0xff7fb6e9), size: 30),
        unselectedItemColor: const Color(0xff7fb6e9),
        selectedFontSize: 18,
        unselectedFontSize: 15,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color(0xff1B3358)),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Color(0xff1B3358)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Color(0xff1B3358)),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Color(0xff1B3358)),
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
