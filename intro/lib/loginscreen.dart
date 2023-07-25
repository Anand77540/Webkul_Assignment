import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signUpScreen.dart';

//login screen
class LoginScreen extends StatelessWidget {
    LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

   //message
  showPopup(BuildContext context,dynamic msg){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$msg')));
  }

  //login API call
  Future<void> loginUserApiCall(context,userData) async {
    try {
      var response = await http.post(
          //Uri.parse("http://127.0.0.1:5000/api/v1/login"),
        //when you are running with another network
        // you have to give IPV4 address at the place of192.168.0.109..
          Uri.parse("http://192.168.0.100:5000/api/v1/login"),
          headers: {
            "Content-Type":"application/json"
          },
          body: jsonEncode(userData)
      );

      dynamic res = await await jsonDecode(response.body);
      if (response.statusCode == 200) {
        showPopup(context,'${res['message']}');
        Navigator.popAndPushNamed(context, '/dashboard');
      } else {
        showPopup(context,'${res['message']}');
      }
    } catch (e) {
      showPopup(context,'$e');
    }
  }

 //onlogin function
  void onLoginPressed(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    //constraints any field can't be empty
    if (email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Kindly fill all the fields')));
      return;
    }

    //user
    dynamic userData= {
      "email":email,
      "password":password,
    };

    await loginUserApiCall(context,userData);
  }

  //frontend code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/2.jpg"),
                radius: 55,
              ),
              Container(
                width: 350,
                margin: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              Container(
                width: 350,
                margin: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {onLoginPressed(context);},
                child: Text('Login'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                    },
                    child: Text('Signup'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
