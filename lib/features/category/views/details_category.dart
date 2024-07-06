// ignore_for_file: unused_import

//import 'dart:html';


import 'package:company_application/features/photos/views/category_image.dart';
import 'package:company_application/features/workers/worker_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;
  final String categoryId;

  const CategoryDetailPage({
    Key? key, 
    required this.categoryName,
    required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundcolor,
        appBar: AppBar(
          backgroundColor: AppColors.textPrimaryColor,
          title: Text(categoryName, style: AppTextStyles.body(context)),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Total Workers'),
               Tab(text: 'Available workers'),
              Tab(text: 'Photos'),
             
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WorkersListView(categoryId: categoryId),
            
            Center(child: Text('available worker session',style: AppTextStyles.body(context),),),
            CategoryPhotosView(categoryId: categoryId),
          ],
        ),
      ),
    );
  }
}


