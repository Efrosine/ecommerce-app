import 'package:easy_refresh/easy_refresh.dart';
import 'package:ecommerce/apiservice/api_service.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/page/order_page.dart';
import 'package:flutter/material.dart';

import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductModel>? products;
  final ApiService service = ApiService();
  Future<void> setUp() async {
    try {
      products = await service.getProducts();
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
      appBar: AppBar(title: Text('Home Page')),
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
          itemCount: products?.length ?? 0,
          itemBuilder: (context, index) {
            var name = products?[index].name;
            var stock = products?[index].stock;
            return ListTile(
              title: Text('$name ($stock)'),
              subtitle: Text('Rp. ${products?[index].price}'),
              trailing: SizedBox(
                width: 75,
                child: TextField(
                  onChanged: (value) {
                    products?[index].quantity = int.tryParse(value);
                  },
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: const InputDecoration(
                      labelText: 'Quantity', border: OutlineInputBorder()),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            service.postOrders(products ?? []);
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
