import 'dart:io';
import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';

class ImagePreviewWidget extends StatelessWidget {
  final File? imageFile;
  final List<File>? imageFiles;
  final Function(int)? onRemove;

  const ImagePreviewWidget({
    Key? key,
    this.imageFile,
    this.imageFiles,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageFiles != null && imageFiles!.isNotEmpty) {
      return Container(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageFiles!.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Image.file(
                    imageFiles![index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                if (onRemove != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => onRemove!(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.cancel,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );
    } else if (imageFile != null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        alignment: Alignment.center,
        child: Image.file(
          imageFile!,
          width: 180,
          height: 180,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.camera_alt, size: 50, color: AppColors.textPrimaryColor),
      );
    }
  }
}