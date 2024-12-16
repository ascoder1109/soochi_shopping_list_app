import 'package:flutter/material.dart';

import '../widgets/signup_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200,),
            const Text("Soochi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 56),),
            const SizedBox(height: 20,),
            SignupWidget(formKey: _formKey),

          ],
        ),
      ),
    );
  }
}
