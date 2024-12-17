import 'package:ecommerce/page/home_page.dart';
import 'package:ecommerce/page/order_page.dart';
import 'package:ecommerce/page/profile_page.dart';
import 'package:flutter/material.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

List<Widget> pages = [
  HomePage(),
  OrderPage(),
  ProfilePage(),
];

class _NavPageState extends State<NavPage> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: Text('Home'),
              onTap: () => setState(() {}),
            ),
            ListTile(
              title: Text('Order'),
              onTap: () => setState(() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(),
                    ));
              }),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () => setState(() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ));
              }),
            ),
          ],
        ),
      ),
      body: pages[pageIndex],
    );
  }
}
