import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'loginscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // message
  showPopup(BuildContext context,dynamic msg){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$msg')));
  }

   //API call of signup
  Future createUserApiCall(context,userData) async {
    try {
      var response = await http.post(
          // Uri.parse("http://127.0.0.1:5000/api/v1/signup"),
        //when you are running with another network
        // you have to give IPV4 address at the place of192.168.0.109..
          // Uri.parse("http://192.168.0.100:5000/api/v1/signup"),
        Uri.parse("https://new-flask-server-webkul-assignment.onrender.com/api/v1/signup"),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(userData)
      );
      dynamic res = await jsonDecode(response.body);
      if (response.statusCode == 201) {
        showPopup(context,'${res['message']}');
        Navigator.pop(context);
      } else {
        showPopup(context,'${res['message']}');
      }
    } catch (e) {
      showPopup(context,'Error : $e');
    }
  }

  //  onSignUp function
  void _onSignUpPressed(BuildContext context) async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    //Constraints any field can't be empty
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Kindly fill all the fields')));
      return;
    }
    //Constraints password and confirm password should be same
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password and Confirm Password do not match.')));
      return;
    }

    //user
    dynamic userData= {
        "name":name,
        "email":email,
        "password":password,
    };

    await createUserApiCall(context,userData);
  }

  //frontend page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/download.png'),
                radius: 55,
              ),
              Container(
                width: 350,
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    hintText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),
              Container(
                width: 350,
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
              ),
              Container(
                width: 350,
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    hintText: 'Enter Password',
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
              ),
              Container(
                width: 350,
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    hintText: 'Enter Same Password Again',
                    prefixIcon: const Icon(Icons.key),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  _onSignUpPressed(context);
                },
                child: const Text('Sign Up'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already you have an account.'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: const Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
