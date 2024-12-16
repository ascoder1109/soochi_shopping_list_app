import 'package:flutter/material.dart';

import '../widgets/login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
            const SizedBox(height: 250,),
            const Text("Soochi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 56),),
            const SizedBox(height: 20,),
            LoginWidget(formKey: _formKey),

          ],
        ),
      ),
    );
  }
}


