import 'package:flutter/material.dart';
import 'package:projecthttp/homepage.dart';
// import 'package:projecthttp/lupa_password.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wow Login',
      home: Scaffold(
        appBar: AppBar(title: const Text('Wow Login')),
        body: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Selamat Datang',
            style: TextStyle(
              fontSize: 36,
              // fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your email';
              }
              return null;
            },
            onSaved: (value) {
              _email = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) {
              _password = value;
            },
          ),
          SizedBox(width: double.infinity),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                _formKey.currentState?.save();
                print("$_email $_password");
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              }
            },
            child: const Text('Login'),
          ),
          CheckboxListTile(
            title: const Text("Ingat saya"),
            value: _rememberMe,
            onChanged: (newValue) {
              setState(() {
                _rememberMe = newValue ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 30),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const LupaPass()));
            },
            child: const Text('Lupa password'),
          ),
        ],
      ),
    );
  }
}
