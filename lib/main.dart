import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    createSharedPrefencesInstance();
    super.initState();
  }

  createSharedPrefencesInstance() async {
    // create
    sharedPreferences = await SharedPreferences.getInstance();
    // initials
    print("get information from locale");
    usernameController.text = sharedPreferences.getString("usernameKey");
    passwordController.text = sharedPreferences.getString("passwordKey");
    print("valid keys: " + sharedPreferences.getKeys().toString());
  }

  void clearOnLocale() {
    usernameController.clear();
    passwordController.clear();
    sharedPreferences.clear();
  }

  void resetPasswordOnLocale() async {
    passwordController.clear();
    sharedPreferences.remove("passwordKey");
    // await sharedPreferences.setString("passwordKey", "");
    if (sharedPreferences.containsKey("passwordKey")) print("Şifre silinemedi");
  }

  void saveToLocale() {
    try {
      sharedPreferences
          .setString("usernameKey", usernameController.text)
          .then((result) {
        print("usernameKey set result $result");
      });
      sharedPreferences
          .setString("passwordKey", passwordController.text)
          .then((result) {
        print("passwordKey set result $result");
      });
    } catch (e) {
      print("Error:: $e");
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Text(
                "Hata oluştu",
                textAlign: TextAlign.center,
              )
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(osInformation()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              usernameWidget(),
              SizedBox(height: 10),
              passwordWidget(),
              SizedBox(height: 10),
              ButtonBar(
                children: [
                  resetPasswordButton(),
                  resetAllButton(),
                  loginButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget usernameWidget() {
    return TextField(
      controller: usernameController,
      decoration: InputDecoration(
        labelText: "Username",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget passwordWidget() {
    return TextField(
      controller: passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget loginButton() {
    return TextButton(
      child: Text("Login"),
      onPressed: () {
        saveToLocale();
      },
    );
  }

  Widget resetAllButton() {
    return TextButton(
      child: Text("Reset All"),
      onPressed: () {
        clearOnLocale();
      },
    );
  }

  Widget resetPasswordButton() {
    return TextButton(
      child: Text("Reset Password"),
      onPressed: () {
        resetPasswordOnLocale();
      },
    );
  }

  String osInformation() {
    if (Platform.isIOS) {
      return "iOS Device";
    } else if (Platform.isAndroid) {
      return "Android Device";
    } else {
      return "Other Device";
    }
  }
}
