import 'dart:async';

import 'package:business_manager/widgets/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // Ensure you add the sign_in_with_apple package

// Controllers
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController usernameController = TextEditingController();
final TextEditingController phoneNumberController = TextEditingController();

String verificationMethod = 'email'; // 'email' or 'phone'
String phoneVerificationMethod = 'text'; // 'text' or 'call'

// Login Function

// Check if input is an email
bool isEmail(String input) {
  return input.contains('@');
}

// Login Function with Username Validation
Future<void> login(BuildContext context) async {
  String input = emailController.text.trim();

  try {
    UserCredential userCredential;
    if (isEmail(input)) {
      // Login with email
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: input,
        password: passwordController.text,
      );
    } else {
      // Convert the input to lowercase for case-insensitive username search
      String lowercaseUsername = input.toLowerCase();

      // Check if username exists in Firestore
      String? email = await fetchEmailFromUsername(lowercaseUsername);
      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username does not exist')),
        );
        return;
      }

      // Proceed with login using the retrieved email
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );
    }

    User? user = userCredential.user;
    if (user != null) {
      // Navigate to BottomNav with the user ID
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav(userId: user.uid)),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to login: ${e.toString()}')),
    );
  }
}

// Function to fetch email from username
Future<String?> fetchEmailFromUsername(String username) async {
  try {
    // Ensure the username is in lowercase for a case-insensitive search
    String lowercaseUsername = username.toLowerCase();

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username_lower',
            isEqualTo: lowercaseUsername) // Match with lowercase username field
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['email'];
    } else {
      return null; // Return null if username does not exist
    }
  } catch (e) {
    throw FirebaseAuthException(
      code: 'user-not-found',
      message: 'Failed to fetch email: ${e.toString()}',
    );
  }
}


// Sign Up Function
Future<void> signUp(BuildContext context,
    {required String verificationMethod,
    required String phoneVerificationMethod}) async {
  try {
    // Normalize username for case-insensitive check
    final username = usernameController.text.trim().toLowerCase();

    // Check if the username already exists
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username_lower', isEqualTo: username)
        .get();

    if (userQuery.docs.isNotEmpty) {
      throw Exception('Username already exists');
    }

    // Capitalize the first letter of the username
    final capitalizedUsername = username.isNotEmpty
        ? username[0].toUpperCase() + username.substring(1)
        : '';

    // Create the user account
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    User? user = userCredential.user;

    if (user != null) {
      if (verificationMethod == 'email') {
        await user.sendEmailVerification();
        await _promptEmailVerification(
            context, user, username); // Prompt for email verification
      } else if (verificationMethod == 'phone') {
        int? resendToken;
        await verifyPhoneNumber(context, phoneNumberController.text,
            phoneVerificationMethod, resendToken);
      }

      // Store user information in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': capitalizedUsername,
        'username_lower': username, // Store the lowercase username
        'email': user.email,
      });
    }
  } catch (e) {
    print('Error during sign-up: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: ${e.toString()}')),
      );
    }
  }
}


// Prompt for Email Verification
Future<void> _promptEmailVerification(
    BuildContext context, User user, String capitalizedUsername) async {
  int resendTimer = 60; // Timer in seconds
  Timer? timer;

  void startResendTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer > 0) {
        resendTimer--;
      } else {
        timer.cancel();
      }
    });
  }

  bool isVerified = false;

  // Start the timer when the dialog is shown
  startResendTimer();

  // Show dialog to prompt the user to verify their email
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Verify your email'),
            content: const Text(
                'Please verify your email address by clicking the link sent to your email.'),
            actions: [
              TextButton(
                onPressed: () async {
                  await user.reload();
                  isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
                  if (isVerified) {
                    timer?.cancel();
                    Navigator.of(context).pop(); // Close dialog
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNav(
                            userId: user.uid,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Sign up successful and email verified!')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Email not verified yet. Please check your inbox.')),
                    );
                  }
                },
                child: const Text('I have verified'),
              ),
              TextButton(
                onPressed: resendTimer == 0
                    ? () async {
                        await user.sendEmailVerification();
                        setState(() {
                          resendTimer = 60; // Restart timer
                          startResendTimer();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Verification email resent. Please check your inbox.')),
                        );
                      }
                    : null,
                child: Text(
                  resendTimer == 0
                      ? 'Resend email'
                      : 'Resend in $resendTimer seconds',
                  style: TextStyle(
                    color: resendTimer == 0 ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );

  // Clean up the timer when the dialog is dismissed
  timer?.cancel();
}

// Verify Phone Number Function
Future<void> verifyPhoneNumber(BuildContext context, String phoneNumber,
    String verificationMethod, int? resendToken) async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const BottomNav(
                    userId: '',
                  )),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number verified successfully!')),
        );
      }
    },
    verificationFailed: (FirebaseAuthException e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      }
    },
    codeSent: (String verificationId, int? resendToken) {
      if (context.mounted) {
        _promptPhoneVerification(
            context, verificationId); // Prompt for phone verification
      }
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-retrieval timeout
    },
    forceResendingToken: verificationMethod == 'call' ? resendToken : null,
  );
}

// Prompt for Phone Verification
Future<void> _promptPhoneVerification(
    BuildContext context, String verificationId) async {
  String smsCode = '';

  // Show dialog to prompt the user to enter the verification code sent to their phone
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter verification code'),
        content: TextField(
          onChanged: (value) {
            smsCode = value;
          },
          decoration: const InputDecoration(hintText: 'Verification code'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: smsCode,
              );

              try {
                await FirebaseAuth.instance.signInWithCredential(credential);
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomNav(
                              userId: '',
                            )),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Phone number verified successfully!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Failed to verify phone number: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}

// Sign Out Function
Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign out successful!')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: ${e.toString()}')),
      );
    }
  }
}

// Google Sign-In Function
Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const BottomNav(
                userId: '',
              )),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed in with Google successfully!')),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to sign in with Google: ${e.toString()}')),
    );
    print(e);
  }
}

// Apple Sign-In Function

Future<void> signInWithApple(BuildContext context) async {
  try {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId:
            'YOUR_CLIENT_ID', // Replace with your client ID from Apple Developer Console
        redirectUri:
            Uri.parse('YOUR_REDIRECT_URI'), // Replace with your redirect URI
      ),
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const BottomNav(
                  userId: '',
                )),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed in with Apple successfully!')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to sign in with Apple: ${e.toString()}')),
      );
      print(e);
    }
  }
}

// Function to trigger sign-up with verification
Future<void> vsignUp(BuildContext context) async {
  try {
    await signUp(
      context,
      verificationMethod: verificationMethod,
      phoneVerificationMethod: phoneVerificationMethod,
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: ${e.toString()}')),
      );
    }
  }
}

Future<String> fetchUsername(String? userId) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (doc.exists) {
    return doc['username'] ?? 'Unknown User';
  } else {
    return 'Unknown User';
  }
}
