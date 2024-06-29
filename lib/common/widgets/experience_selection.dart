import 'package:flutter/material.dart';

class ExperienceSelectionWidget extends StatefulWidget {
  final TextEditingController controller;

  const ExperienceSelectionWidget({Key? key, required this.controller}) : super(key: key);

  @override
  _ExperienceSelectionWidgetState createState() => _ExperienceSelectionWidgetState();
}

class _ExperienceSelectionWidgetState extends State<ExperienceSelectionWidget> {
  final List<String> experiences = [
    'Less than 1 year',
    '1-2 years',
    '3-5 years',
    'More than 5 years',
  ];

  String? selectedExperience;

  void _showExperienceDialog() async {
    final String? selected = await showDialog(
      context: context,
      builder: (context) {
        String? tempSelectedExperience = selectedExperience;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Experience Level'),
              content: SingleChildScrollView(
                child: Column(
                  children: experiences.map((experience) {
                    return RadioListTile<String>(
                      value: experience,
                      groupValue: tempSelectedExperience,
                      title: Text(experience),
                      onChanged: (String? value) {
                        setState(() {
                          tempSelectedExperience = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(selectedExperience);
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(tempSelectedExperience);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedExperience = selected;
        widget.controller.text = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          readOnly: true,
          onTap: _showExperienceDialog,
          decoration: InputDecoration(
            labelText: 'Experience Level',
            suffixIcon: Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(),
          ),
        ),
        // if (selectedExperience != null)
        //   ListTile(
        //     title: Text(selectedExperience!),
        //     trailing: IconButton(
        //       icon: Icon(Icons.cancel),
        //       onPressed: () {
        //         setState(() {
        //           selectedExperience = null;
        //           widget.controller.clear();
        //         });
        //       },
        //     ),
        //   ),
      ],
    );
  }
}