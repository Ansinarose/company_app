// ignore_for_file: unnecessary_null_comparison

import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';


class CategorySelectionWidget extends StatefulWidget {
  final TextEditingController controller;

  const CategorySelectionWidget({Key? key, required this.controller, required List<String> selectedCategories, required Null Function(dynamic categories) onSelectedCategories}) : super(key: key);

  @override
  _CategorySelectionWidgetState createState() => _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  final List<String> categories = [
    'Sliding Windows',
    'Door Partitions',
    'Waterproof Bathroom Doors',
    'Aluminium Wardrobe',
    'Aluminium Kitchen Cabinet',
    'Aluminium Window Fabrication',
    'Exterior Cladding',
    'Interior Cladding',
    'Customized Designs',
    'False Ceilings',
    'Acoustic Ceilings',
    'Decorative Ceilings',
    'Fibre False Ceiling Designs',
    'Interior Gypsum Board Work',
    'Glass Partitions',
    'Glass Doors',
    'Glass Railings',
    'Custom Glass Installations',
    'Dining Area Designs',
    'Bedroom Designs',
    'Cupboards (Plywood)',
    'Custom Furniture Designs',
    'Stair Railings',
    'Staircase Fabrication',
   'Custom Stair Designs',
  ];

  List<String> selectedCategories = [];

  void _showCategoryDialog() async {
    final List<String> selectedItems = await showDialog(
      context: context,
      builder: (context) {
        List<String> tempSelectedCategories = List.from(selectedCategories);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Select Categories',
                style: AppTextStyles.subheading(context),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: categories.map((category) {
                    return CheckboxListTile(
                      value: tempSelectedCategories.contains(category),
                      title: Text(category),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelectedCategories.add(category);
                          } else {
                            tempSelectedCategories.remove(category);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.body(context),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(selectedCategories);
                  },
                ),
                TextButton(
                  child: Text(
                    'OK',
                    style: AppTextStyles.body(context),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(tempSelectedCategories);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedItems != null) {
      setState(() {
        selectedCategories = selectedItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          readOnly: true,
          onTap: _showCategoryDialog,
          decoration: InputDecoration(
            labelText: 'Categories',
            suffixIcon: Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: mediaQuery.size.height * 0.2, // Adjust the height based on screen size
          child: ListView.builder(
            itemCount: selectedCategories.length,
            itemBuilder: (context, index) {
              final category = selectedCategories[index];
              return ListTile(
                title: Text(category),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      selectedCategories.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}