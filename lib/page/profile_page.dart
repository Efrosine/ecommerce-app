import 'package:easy_refresh/easy_refresh.dart';
import 'package:ecommerce/apiservice/api_service.dart';
import 'package:ecommerce/model/bank_user_model.dart';
import 'package:ecommerce/page/home_page.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import 'order_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;
  BankUserModel? bankUser;
  final ApiService service = ApiService();
  Future<void> setUp() async {
    await setUpUser();
    await setUpBankUser();
  }

  Future<void> setUpUser() async {
    try {
      user = await service.getUserAccount();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {});
  }

  Future<void> setUpBankUser() async {
    try {
      bankUser = await service.requestBankAccount();
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
      appBar: AppBar(title:Text('Home Page')),
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
        childBuilder: (context, physics) => ListView(
            physics: physics,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            children: [
              Card(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user?.name}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text('${user?.email}'),
                      
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${bankUser?.name}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text('${bankUser?.email}'),
                      const SizedBox(height: 8),
                      Text(
                        'Balance',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${bankUser?.balance}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              FilledButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        var emailControl = TextEditingController();
                        var passwordControl = TextEditingController();
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: emailControl,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: passwordControl,
                                  decoration: const InputDecoration(
                                      labelText: 'Password'),
                                ),
                                const SizedBox(height: 8),
                                FilledButton(
                                    onPressed: () async {
                                      try {
                                        var email = emailControl.text;
                                        var password = passwordControl.text;
                                        var message = await service.requestBind(
                                            email, password);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(message)));
                                        Navigator.pop(context);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString())));
                                      }
                                    },
                                    child: const Text('Send Request')),
                              ],
                            ),
                          ),
                        );
                      },
                    ).then(
                      (value) => setState(() {
                        setUp();
                      }),
                    );
                  },
                  child: Text('Request Bind')),
            ]),
      ),
    );
  }
}
