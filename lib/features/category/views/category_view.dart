import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/features/category/views/add_category.dart';
import 'package:company_application/features/home/views/home_screen.dart';
import 'package:company_application/features/services/model/service.dart';
import 'package:flutter/material.dart';

class CategoryViewScreen extends StatelessWidget {
  const CategoryViewScreen({super.key, required Service service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
      ),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   floatingActionButton: FloatingActionButton(
    backgroundColor: AppColors.textPrimaryColor,
    onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryAddScreen()));
    },
    tooltip: 'Increment',
    child: Icon(Icons.add,color: Colors.white,),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30)
    ),
    ),
   bottomNavigationBar: BottomAppBar(
    color: AppColors.textPrimaryColor,
    shape: CircularNotchedRectangle(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
          }, icon: Icon(Icons.home,color: Colors.white)),
        IconButton(onPressed: (){}, icon: Icon(Icons.settings,color: Colors.white))
      ],
    ),
   ),
    );
  }
}