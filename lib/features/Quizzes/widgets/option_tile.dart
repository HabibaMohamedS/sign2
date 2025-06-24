import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Quizzes/view_model/quiz_controller.dart';

class OptionTile extends StatelessWidget {
  final String label;
  final int index;
  final bool isSelected;
  final bool isSubmitted;
  final bool isCorrect;

  const OptionTile({
    required this.label,
    required this.index,
    required this.isSelected,
    required this.isSubmitted,
    required this.isCorrect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    IconData? feedbackIcon;
    Color? iconColor;

    if (isSubmitted) {
      if (isSelected && isCorrect) {
        feedbackIcon = Icons.check;
        iconColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        feedbackIcon = Icons.close;
        iconColor = Colors.red;
      } else if (!isSelected && isCorrect) {
        feedbackIcon = Icons.check;
        iconColor = Colors.green;
      }
    }

    return ListTile(
      leading: Radio<int>(
        value: index,
        groupValue: Get.find<QuizController>().selectedOption.value,
        onChanged: isSubmitted ? null : (value) {
          Get.find<QuizController>().selectOption(value!);
        },
      ),
      title: Text(label),
      trailing: feedbackIcon != null
          ? Icon(feedbackIcon, color: iconColor)
          : null,
    );
  }
}
