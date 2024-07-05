import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/constants/textform_field.dart';
import 'package:company_application/common/widgets/curved_appbar.dart';
import 'package:company_application/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
// Create a user model (see next step)

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(
        title: 'Welcome to ALFA Aluminium',
        titleTextStyle: AppTextStyles.whiteBody(context),
        ),
      backgroundColor: AppColors.scaffoldBackgroundcolor,
     
       body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Text('Login to your account', style: AppTextStyles.heading(context)),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: 'Username',
                      controller: usernameController,
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Username';
                        }
                        
                        return null;
                      }, onChanged: (value) {  },
                    ),
                    SizedBox(height: 20,),
                    CustomTextFormField(
                      labelText: 'Password',
                      controller: passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      }, onChanged: (value) {  },
                    ),
                    SizedBox(height: 50,),
                    Center(
                      child: TextButton(onPressed: (){
                      if(_formKey.currentState?.validate() ?? false){
                        String username = usernameController.text.trim();
                        String password = passwordController.text.trim();
                      
                        if(username == 'ALFA' && password == '123456'){
                          Provider.of<User>(context, listen: false).login(username);
                           Navigator.pushReplacementNamed(context, '/home');
                                        } else {
                      // Show an error message (you can use a SnackBar or Dialog)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid username or password',
                        )),
                      );
                        }
                      }
                      }, child: Text('Login'),
                      style: AppButtonStyles.largeButton(context),),
                    )
             ],   )
              )
            )
       )      
    );
  }
}
