import 'package:business_manager/backend_services.dart/auth_service.dart';
import 'package:business_manager/widgets/app_button.dart';
import 'package:business_manager/widgets/app_textfield.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  // String _selectedVerificationMethod = 'email';
  // String _selectedPhoneVerificationMethod = 'text';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600, 
            ),
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
                    controller: usernameController,
                    label: "Username",
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: emailController,
                    label: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: passwordController,
                    label: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  // Verification Method Selection
                  // Uncomment and use this if needed
                  // DropdownButtonFormField<String>(
                  //   value: _selectedVerificationMethod,
                  //   items: const [
                  //     DropdownMenuItem(
                  //       value: 'email',
                  //       child: Text('Email Verification'),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: 'phone',
                  //       child: Text('Phone Verification'),
                  //     ),
                  //   ],
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _selectedVerificationMethod = value!;
                  //     });
                  //   },
                  //   decoration: const InputDecoration(
                  //     labelText: 'Choose Verification Method',
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // // If Phone Verification is Selected
                  // if (_selectedVerificationMethod == 'phone') ...[
                  //   AppTextField(
                  //     controller: phoneNumberController,
                  //     label: 'Phone Number',
                  //     obscureText: false,
                  //   ),
                  //   const SizedBox(height: 16),
                  //   DropdownButtonFormField<String>(
                  //     value: _selectedPhoneVerificationMethod,
                  //     items: const [
                  //       DropdownMenuItem(
                  //         value: 'text',
                  //         child: Text('Text Message'),
                  //       ),
                  //       DropdownMenuItem(
                  //         value: 'call',
                  //         child: Text('Phone Call'),
                  //       ),
                  //     ],
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _selectedPhoneVerificationMethod = value!;
                  //       });
                  //     },
                  //     decoration: const InputDecoration(
                  //       labelText: 'Receive Verification Code Via',
                  //     ),
                  //   ),
                  // ],
                  const SizedBox(height: 20),
                  // Sign Up Button
                  AppButton(
                    text: "Sign Up",
                    onTap: () => vsignUp(context), // Updated SignUp Logic
                  ),
                  const SizedBox(height: 20),
                  // Google Sign-Up Button
                  // Uncomment and use this if needed
                  // AppButton(
                  //   text: "Sign Up with Google",
                  //   onTap: () => signInWithGoogle(context), // Google Sign-Up Logic
                  // ),
                  // const SizedBox(height: 20),
                  // // Apple Sign-Up Button
                  // Uncomment and use this if needed
                  // AppButton(
                  //   text: "Sign Up with Apple",
                  //   onTap: () => signInWithApple(context), // Apple Sign-Up Logic
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
