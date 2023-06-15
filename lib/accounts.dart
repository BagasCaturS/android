import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int selectedAccountIndex = 0;
  List<String> accounts = [
    'John Dis Nute',
    'Jane Smitherin Smith',
    "Michael Poppin' Cherries",
    'Saga Yo Mam',
    'Anita Blake Boy',
  ];

  void selectAccount(int index) {
    setState(() {
      selectedAccountIndex = index;
    });
  }

  Widget buildAccountCard(int index) {
    final accountName = accounts[index];
    final profileImage = 'assets/p_pic/profile_${index + 1}.jpeg'; // Replace with the actual image asset path

    return Card(
      elevation: selectedAccountIndex == index ? 4.0 : 1.0,
      color: selectedAccountIndex == index ? Colors.blue[100] : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(profileImage),
        ),
        title: Text(
          accountName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          selectAccount(index);
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Account'),
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return buildAccountCard(index);
        },
      ),
    );
  }
}
