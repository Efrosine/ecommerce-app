import 'package:easy_refresh/easy_refresh.dart';
import 'package:ecommerce/apiservice/api_service.dart';
import 'package:ecommerce/model/order_model.dart';
import 'package:ecommerce/page/home_page.dart';
import 'package:flutter/material.dart';

import 'profile_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final ApiService service = ApiService();
  List<OrderModel>? orders;
  Future<void> setUp() async {
    try {
      orders = await service.getOrders();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {});
  }

  @override
  void initState() {
    setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Page')),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: Text('Home'),
              onTap: () => setState(() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              }),
            ),
            ListTile(
              title: Text('Order'),
              onTap: () => setState(() {}),
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
      body: EasyRefresh.builder(
          onRefresh: () async {
            await setUp();
          },
          onLoad: () async {
            await setUp();
          },
          childBuilder: (context, physics) => ListView.builder(
              physics: physics,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              itemCount: orders?.length ?? 0,
              itemBuilder: (context, index) {
                var order = orders![index];
                return ListTile(
                  title: Text(order.orderDate ?? 'no date'),
                  subtitle: Text(order.totalPrice.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(label: Text(order.status ?? 'no Status')),
                      if (order.status == 'pending')
                        IconButton.filled(
                            onPressed: () async {
                              try {
                                var msg = await service.requestPayment(order.id!);ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(msg)));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              }
                              setState(() {});
                            },
                            icon: Icon(Icons.payment))
                    ],
                  ),
                );
              })),
    );
  }
}
