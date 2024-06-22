import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/constants/textform_field.dart';
import 'package:company_application/common/widgets/curved_appbar.dart';
import 'package:company_application/common/widgets/photo_selection.dart';
import 'package:flutter/material.dart';

class AddServicePage extends StatelessWidget {
  final Function(String) onAddService;

  AddServicePage({required this.onAddService});

  final TextEditingController _Servicecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: CurvedAppBar(
        
 title: '',
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            
            children: [
              // TextField(
              //   controller: _controller,
              //   decoration: InputDecoration(labelText: 'Service Name'),
              // ),
              // SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     onAddService(_controller.text);
              //     Navigator.pop(context);
              //   },
              //   child: Text('Add Service'),
              // ),
               Text('ADD A SERVICE',style: AppTextStyles.subheading(context),),
               SizedBox(height: 30,),
              CustomTextFormField(
                labelText: 'Service Name', controller: _Servicecontroller, prefixIcon: Icons.design_services_sharp),
                SizedBox(height: 30,),
                PhotoWidget(),
                SizedBox(height: 30,),
                TextButton(onPressed: (){
                  onAddService(_Servicecontroller.text);
                  Navigator.of(context).pop();
                }, child: Text('SUBMIT'),
                style: AppButtonStyles.largeButton(context),)
            ],
          ),
        ),
      ),
    );
  }
}
