// ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'package:company_application/common/constants/app_colors.dart';
// import 'package:flutter/material.dart';

// class CustomTextFormField extends StatefulWidget {
//   final String labelText;
//   final TextEditingController controller;
//   final bool obscureText;
//   final IconData prefixIcon;
//   final String? Function(String?)? validator;

//   const CustomTextFormField({
//     Key? key,
//     required this.labelText,
//     required this.controller,
//     this.obscureText = false,
//     required this.prefixIcon,
//     this.validator,
//   }) : super(key: key);

//   @override
//   _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
// }

// class _CustomTextFormFieldState extends State<CustomTextFormField> {
//   late bool _isObscured;

//   @override
//   void initState() {
//     super.initState();
//     _isObscured = widget.obscureText;
//   }

//   @override
//   Widget build(BuildContext context) {
//     Color textColor = AppColors.textPrimaryColor;
//     Color hintColor = AppColors.textPrimaryColor;
//     Color labelColor = AppColors.textPrimaryColor;
//     // ignore: unused_local_variable
//     Color borderColor = AppColors.textPrimaryColor;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: widget.controller,
//         obscureText: _isObscured,
//         decoration: InputDecoration(
//           labelText: widget.labelText,
//           labelStyle: TextStyle(color: labelColor),
//           prefixIcon: Icon(widget.prefixIcon, color: textColor),
//           suffixIcon: widget.obscureText
//               ? IconButton(
//                   icon: Icon(
//                     _isObscured ? Icons.visibility : Icons.visibility_off,
//                     color: textColor,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isObscured = !_isObscured;
//                     });
//                   },
//                 )
//               : null,
//           hintText: widget.labelText,
//           hintStyle: TextStyle(color: hintColor),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//         ),
//         style: TextStyle(color: textColor),
//         validator: widget.validator,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/constants/textform_field.dart';

class ImageFormScreen extends StatefulWidget {
  final String imageUrl;

  const ImageFormScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ImageFormScreenState createState() => _ImageFormScreenState();
}

class _ImageFormScreenState extends State<ImageFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Details'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              CustomTextFormField(
                labelText: 'Title',
                controller: _titleController,
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              CustomTextFormField(
                labelText: 'Description',
                controller: _descriptionController,
                prefixIcon: Icons.description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _submitForm,
                child: Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement form submission logic
      print('Title: ${_titleController.text}');
      print('Description: ${_descriptionController.text}');
      // You can add logic here to save the form data or perform any other action
      Navigator.pop(context);
    }
  }
}