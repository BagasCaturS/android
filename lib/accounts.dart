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
  final int maxProfileCount = 6;

  void selectAccount(int index) {
    setState(() {
      selectedAccountIndex = index;
    });
  }

  void addProfile() {
    if (accounts.length >= maxProfileCount) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Max Profile Reached'),
            content: Text('You have reached the maximum profile count.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Show dialog to enter the profile name
      showDialog(
        context: context,
        builder: (context) {
          String profileName = '';

          return AlertDialog(
            title: Text('Add New Profile'),
            content: TextField(
              onChanged: (value) {
                profileName = value;
              },
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Add'),
                onPressed: () {
                  // Add the new profile with the entered name
                  setState(() {
                    accounts.add(profileName);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: addProfile,
        child: Icon(Icons.add),
      ),
    );
  }
}
