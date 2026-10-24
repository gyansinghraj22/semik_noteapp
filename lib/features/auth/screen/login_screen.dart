import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noteapp/features/auth/bloc/login_bloc.dart';
import 'package:noteapp/features/auth/bloc/login_event.dart';
import 'package:noteapp/features/auth/bloc/login_state.dart';
import 'package:noteapp/features/note/screen/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Close keyboard

      final formData = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
      };

      context.read<LoginBloc>().add(UserLoginEvent(formData: formData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Atelier Notes",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFEEEBFF),
              child: Icon(Icons.person, color: Color(0xFF6737EA)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 81, 45, 240),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "ATELIER NOTES",
                            style: TextStyle(
                              color: Color.fromARGB(255, 44, 33, 243),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Welcome Back",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                                fontFamily: 'serif',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Sign in to sync your encrypted thoughts, "
                  "sketches, and notes across all your trusted devices.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 95, 94, 94),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 40),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email address is required";
                    }
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      size: 17,
                      color: Color.fromARGB(255, 44, 44, 44),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 60,
                      minHeight: 48,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Email Address",
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    hintText: "Enter your email",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Master passphrase is required";
                    }
                    if (value.length < 6) {
                      return "Passphrase must be at least 6 characters long";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 17,
                      color: Color.fromARGB(255, 44, 44, 44),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 60,
                      minHeight: 48,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Master PassPhrase",
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    hintText: "Enter your password",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Handle forgot password action
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 33, 243),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // BlocConsumer handles state side-effects & submit button rendering
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is UserLoginSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login Successful!"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Navigate to HomePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    } else if (state is UserLoginErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.error.message ?? "Login failed. Please try again.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is LoginInitialState && state != context.read<LoginBloc>().state; // You can also create a dedicated UserLoginLoadingState

                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 92, 48, 225),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoading ? null : _submitForm,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),

                // Divider Row
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Or Continue With',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Social Logins
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          side: const BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1.2,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_logo.png',
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Continue with Google",
                              style: TextStyle(
                                color: Color(0xFF252525),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 16, 16, 16),
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.apple,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Continue with Apple",
                              style: TextStyle(
                                color: Color.fromARGB(255, 252, 252, 252),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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