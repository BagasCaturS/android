import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isVideoPlaybackEnabled = true;
  bool _areNotificationsEnabled = true;
  bool _isWifiOnlyEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Video Playback'),
            trailing: Switch(
              value: _isVideoPlaybackEnabled,
              onChanged: (value) {
                setState(() {
                  _isVideoPlaybackEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Notification Settings'),
            trailing: Switch(
              value: _areNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _areNotificationsEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Downloads'),
            subtitle: ListTile(
              title: Text('WiFi-only'),
              trailing: Switch(
                value: _isWifiOnlyEnabled,
                onChanged: (value) {
                  setState(() {
                    _isWifiOnlyEnabled = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingPage(),
  ));
}
