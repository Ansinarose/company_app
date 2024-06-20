import 'package:company_application/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    required this.prefixIcon,
    this.validator,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = AppColors.textPrimaryColor;
    Color hintColor = AppColors.textPrimaryColor;
    Color labelColor = AppColors.textPrimaryColor;
    // ignore: unused_local_variable
    Color borderColor = AppColors.textPrimaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isObscured,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: labelColor),
          prefixIcon: Icon(widget.prefixIcon, color: textColor),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: textColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
          hintText: widget.labelText,
          hintStyle: TextStyle(color: hintColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
        style: TextStyle(color: textColor),
        validator: widget.validator,
      ),
    );
  }
}