import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './index.dart';
import '../Services/index.dart';
import '../models/index.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final MainService mainService = getIt<MainService>();
  final FlutterSecureStorage secureStorage = getIt<FlutterSecureStorage>();

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _handleLogin(BuildContext context) async {
    if(! _formKey.currentState!.validate() ) return;

    setState(() {
      _isLoading = true; // Show spinner when request starts
      _errorMessage = null;
    });

    final response = await mainService.loginUser(emailController.text, passwordController.text);

    if(response['success'])
    {
      final String jwt = response['data']['accessToken'];
      final String userId = response['data']['user']['_id'];
      await secureStorage.write(key: 'jwt', value: jwt);
      await secureStorage.write(key: 'userId', value: userId);
      //print(jwt);
      if(context.mounted){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
          return Auth();
        })
        );
      }
    }
    else
    {
      setState(() {
        _errorMessage = response['message'];
      });
    }
    setState(() {
      _isLoading = false; // Show spinner when request starts
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final successMessage = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Icon(
                    Icons.message,
                    size: 80,
                    color: Theme.of(context).primaryColor, // WhatsApp green
                  ),
                ),
                const SizedBox(height: 30),
                // Welcome Text
                const Center(
                  child: Text(
                    'Login to PingUp',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                const SizedBox(height: 20,),
                if (successMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      successMessage,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20,),
                Form(
                  key: _formKey,
                    child: Column(
                      children: [
                        // Email Input Field
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (email)
                          {
                            if(email==null || email.isEmpty)
                            {
                              return "Please enter email";
                            }
                            final bool emailValid =
                            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email);
                            if(!emailValid) return "Enter a valid email";
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: const Icon(Icons.email, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Password Input Field
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          obscuringCharacter: "*",
                          validator: (password){
                            if(password==null || password.length<8 )
                            {
                                return "Password must be at least 8 characters long.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Login Button
                        ElevatedButton(
                          onPressed:()=>_handleLogin(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor, // WhatsApp green
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                )),
                // Register Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Register Page
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>
                          const RegisterPage()
                        )
                      );
                    },
                    child: Text(
                      'Don’t have an account? Register here',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor, // WhatsApp green lighter
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
