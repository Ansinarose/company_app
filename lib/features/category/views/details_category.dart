// import 'package:flutter/material.dart';
// import 'package:company_application/common/constants/app_colors.dart';
// import 'package:company_application/common/constants/app_text_styles.dart';

// class CategoryDetailPage extends StatelessWidget {
//   final String categoryName;

//   const CategoryDetailPage({Key? key, required this.categoryName}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundcolor,
//       appBar: AppBar(
//         backgroundColor: AppColors.textPrimaryColor,
//         title: Text(categoryName, style: AppTextStyles.heading(context)),
//         bottom: TabBar(
//           tabs: [
//             Tab(text: 'Total Workers'),
//             Tab(text: 'Available Workers'),
//             Tab(text: 'Photos'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         children: [
//           Center(child: Text('Total Workers Section', style: AppTextStyles.body(context))),
//           Center(child: Text('Available Workers Section', style: AppTextStyles.body(context))),
//           Center(child: Text('Photos Section', style: AppTextStyles.body(context))),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;

  const CategoryDetailPage({Key? key, required this.categoryName}) : super(key: key);

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
              Tab(text: 'Available Workers'),
              Tab(text: 'Photos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Total Workers Section', style: AppTextStyles.body(context))),
            Center(child: Text('Available Workers Section', style: AppTextStyles.body(context))),
         //   Center(child: Text('Photos Section', style: AppTextStyles.b)),
          ],
        ),
      ),
    );
  }
}
