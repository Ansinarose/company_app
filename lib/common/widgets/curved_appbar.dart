// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, unnecessary_null_comparison
// lib/common/widgets/curved_app_bar.dart
import 'package:company_application/common/constants/app_colors.dart';
import 'package:flutter/material.dart';



class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  final List<Widget>? actions;
  final String? backgroundImage;
  final TextStyle? titleTextStyle;
  CurvedAppBar({
    Key? key,
     required this.title,
    this.actions,
   this.backgroundImage, this.titleTextStyle
  }) : assert(title != null || backgroundImage !=null),
  super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(230.0);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _AppBarClipper(),
      child: Container(
        height: preferredSize.height,
        decoration: BoxDecoration(
          color: backgroundImage == null ? AppColors.textPrimaryColor : null,
          image:  backgroundImage != null ? DecorationImage(
            image: AssetImage(backgroundImage!),
            fit: BoxFit.cover)
            :null,
        ),
        child: AppBar(centerTitle: true,
         title: Padding(
           padding: const EdgeInsets.only(top: 20.0),
           child: Text(title,
           style: titleTextStyle ,),
         ), 
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: actions,
        ),
      ),
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height + 50, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
