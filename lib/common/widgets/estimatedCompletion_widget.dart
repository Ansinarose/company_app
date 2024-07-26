import 'package:flutter/material.dart';
import 'package:company_application/features/photos/model/imageFormModel.dart';
import 'package:company_application/common/constants/app_colors.dart';

class EstimatedCompletionWidget extends StatelessWidget {
  final ImageFormModel model;

  const EstimatedCompletionWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showEstimatedCompletionDialog(context),
      child: Text(
        model.estimatedCompletion.isEmpty
            ? 'Select Estimated Completion'
            : model.estimatedCompletion,
        style: TextStyle(color: AppColors.textPrimaryColor),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void _showEstimatedCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Estimated Completion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEstimationOption(context, 'Upto 10 days'),
              _buildEstimationOption(context, 'In between 10-20 days'),
              _buildEstimationOption(context, 'Approximately 1 month'),
              _buildEstimationOption(context, 'More than 1 month'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEstimationOption(BuildContext context, String option) {
    return ListTile(
      title: Text(option),
      onTap: () {
        model.setEstimatedCompletion(option);
        Navigator.of(context).pop();
      },
    );
  }
}