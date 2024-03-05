import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz/views/home/home_screen.dart';
import 'package:flutter_quiz/views/profile/profile_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  int selectedIndex = 0;
  _onItemTapped(int index) {
    setState(() {
      print("index ================== $index");
      selectedIndex = index;
    });
  }

  getScreen() {
    switch (selectedIndex) {
      case 0:
        return HomePage();
      case 1:
        return ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor3 = Color(0xFF5170FD);

    return Scaffold(
      body: getScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border.all(width: .3)),
        child: DefaultTabController(
          length: 2,
          initialIndex: selectedIndex,
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(top: 13),
              child: TabBar(
                  labelColor: bgColor3,
                  onTap: _onItemTapped,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(color: bgColor3, width: 2),
                    insets: EdgeInsets.fromLTRB(32, 0, 32, 24 + 32),
                  ),
                  tabs: const [
                    Tab(
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.home),
                          Text(
                            'Home',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      child: Column(
                        children: [
                          Icon(Icons.person),
                          Text(
                            'Profile',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
