import 'package:flutter/material.dart';
import 'dart:io'; // To handle file paths and image display
import 'package:image_picker/image_picker.dart';
import 'package:pingup/Services/index.dart';
import 'package:pingup/Widgets/LoginPage.dart'; // For picking images

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final MainService mainService = getIt<MainService>();

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  File? _profileImage; // Store the selected profile image
  String? _errorMessage;
  bool _isLoading = false;

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path); // Set the selected image
      });
    }
  }

  Future<void> _handleRegister() async {
    if(! _formKey.currentState!.validate() ) return;
    if(_profileImage == null)
    {
      setState(() {
        _errorMessage = "Profile photo is required!";
      });
      return;
    }
    setState(() {
      _isLoading = true; // Show spinner when request starts
      _errorMessage = null;
    });

    final response = await mainService.registerUser(nameController.text, emailController.text, passwordController.text, _profileImage);

    if(response['success'])
    {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
          return const LoginPage();
        },
        settings: const RouteSettings(
          arguments: "You are registered Successfully!",
        )
        )
      );
    }
    else
    {
      setState(() {
        _errorMessage = response['message'];
      });
    }
    setState(() {
      _isLoading = false; // hide spinner when request ends
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Icon(
                    Icons.person_add,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Register to PingUp',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Profile Image Picker
                GestureDetector(
                  onTap: _pickImage, // When tapped, open image picker
                  child: CircleAvatar(
                    radius: 60,
                    child: _profileImage == null
                        ? Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: Colors.grey[400],
                    ) : ClipOval(
                      child: Image.file(
                        _profileImage!,
                        width: 120, // Matches the size of the CircleAvatar (2 * radius)
                        height: 120,
                        fit: BoxFit.cover, // Ensures the image covers the avatar without zooming in too much
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name Input Field
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validator: (name) {
                          if (name == null || name.length<3) {
                            return 'Name must be at least 3 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Name',
                          prefixIcon: const Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Input Field
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'Please enter email';
                          }
                          final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email);
                          if (!emailValid) return 'Enter a valid email';
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
                        validator: (password) {
                          if (password == null || password.length < 8) {
                            return 'Password must be at least 8 characters long.';
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

                    TextFormField(
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                      // Register Button
                      ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                // Login Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Go back to login page
                    },
                    child: Text(
                      'Already have an account? Login here',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
