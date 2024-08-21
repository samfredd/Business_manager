import 'package:business_manager/auth/sign_up_screen.dart';
import 'package:business_manager/backend_services.dart/auth_service.dart'; // Ensure this import has the updated login logic
import 'package:business_manager/widgets/app_button.dart';
import 'package:business_manager/widgets/app_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use min to center vertically
              children: [
                const Icon(
                  Icons.person,
                  size: 200,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: emailController,
                  label: "Email or Username", // Update label to reflect that it can be either
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                AppButton(
                  onTap: () => login(context), // Ensure this uses the updated login logic
                  text: 'Login',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
