import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soochi/routes.dart';
import '../../core/dtos/user_login_request_dto.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Form(
          key: _formKey,
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  TextFormField(
                    controller: emailController, // Set controller for email
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
                  TextFormField(
                    controller: passwordController, // Set controller for password
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
                  if (viewModel.errorMessage.isNotEmpty)
                    Text(
                      viewModel.errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                            if (_formKey.currentState?.validate() ?? false) {

                              String email = emailController.text;
                              String password = passwordController.text;

                              UserLoginRequestDTO loginRequestDTO = UserLoginRequestDTO(
                                email: email,
                                password: password,
                              );


                              await viewModel.login(context, loginRequestDTO);
                            }
                          },
                          style: ButtonStyle(
                            elevation: const WidgetStatePropertyAll(0),
                            foregroundColor: WidgetStateProperty.all(Colors.white),
                            backgroundColor: WidgetStateProperty.all(Colors.blue),
                          ),
                          child: const Text("Login"),
                        ),
                      ),
                    ],
                  ),
                  TextButton(onPressed: () {
                    Navigator.popAndPushNamed(context, Routes.signup);
                  }, child: const Text("Don't have an account? Tap here and register"))
                ],

              );
            },
          ),
        ),
      ),
    );
  }
}
