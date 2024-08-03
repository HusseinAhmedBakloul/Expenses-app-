import 'dart:io'; // Import this for File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:signup/Models/AccountModel.dart';
import 'package:signup/login/Signin.dart';

const Color primaryColor = Color.fromARGB(255, 58, 55, 199);
const Color secondaryColor = Color.fromARGB(119, 223, 225, 230);

class Person extends StatefulWidget {
  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final accountModel = Provider.of<AccountModel>(context, listen: false);
    _nameController = TextEditingController(text: accountModel.name);
    _emailController = TextEditingController(text: accountModel.email);
    _passwordController = TextEditingController(text: accountModel.password);
    _phoneController = TextEditingController(text: accountModel.phone);
    if (accountModel.imagePath.isNotEmpty) {
      _imageFile = File(accountModel.imagePath);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path); 
        });
      }
    } catch (e) {
      // Handle any errors that might occur during image picking
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountModel = Provider.of<AccountModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/Screenshot 2024-08-01 123502.png', // Ensure this path matches your asset location
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.25), // Optional: to add a transparency effect
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'My Profile',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                           SizedBox(width: 5),
                           Image.asset('images/Screenshot_2024-08-01_214645-removebg-preview.png', height: 25,)
                        ],
                      ),
                    ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: .5, color: primaryColor),
                            color: Colors.white,
                          ),
                          child: _imageFile == null
                              ? const Icon(Icons.person, size: 60, color: primaryColor)
                              : ClipOval(
                                  child: Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 9,
                          right: 3,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: primaryColor),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 21,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTextField('Name', _nameController),
                  _buildTextField('Email', _emailController),
                  _buildTextField('Password', _passwordController),
                  _buildTextField('Phone', _phoneController),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        accountModel.updateAccount(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          phone: _phoneController.text,
                          imagePath: _imageFile?.path ?? '',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account updated successfully')),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Save Update',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signin()), 
                   );
                  },
                    child: const Text('Log out', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: .5, color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 1, left: 15),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: '',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
