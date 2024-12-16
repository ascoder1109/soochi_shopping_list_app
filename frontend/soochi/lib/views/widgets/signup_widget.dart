import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/dtos/user_registration_dto.dart';

import 'package:soochi/routes.dart';

import '../viewmodels/signup_viewmodel.dart';

class SignupWidget extends StatelessWidget {
  const SignupWidget({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Form(
          key: _formKey,
          child: Consumer<SignupViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  // Username TextField
                  TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: "Enter your username",
                      labelText: "Username",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Email TextField
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      labelText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password TextField
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),


                  if (viewModel.isLoading)
                    const CircularProgressIndicator(),

                  // Error message
                  if (viewModel.errorMessage.isNotEmpty)
                    Text(
                      viewModel.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),

                  // Signup Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              String userName = userNameController.text;
                              String email = emailController.text;
                              String password = passwordController.text;

                              UserRegistrationDTO registrationDTO = UserRegistrationDTO(
                                userName: userName,
                                email: email,
                                password: password,
                              );


                              await viewModel.signup(context, registrationDTO);
                            }
                          },
                          style: ButtonStyle(
                            elevation: const WidgetStatePropertyAll(0),
                            foregroundColor: WidgetStateProperty.all(Colors.white),
                            backgroundColor: WidgetStateProperty.all(Colors.blue),
                          ),
                          child: const Text("Sign Up"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),


                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, Routes.login);
                    },
                    child: const Text("Already have an account? Log in here"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
