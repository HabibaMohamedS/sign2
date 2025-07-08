 import 'package:flutter/material.dart';
 import 'package:sign2/features/Quizzes/view_model/quiz_controller.dart';

 class OptionTile extends StatelessWidget {
  final String label;
  final int index;
  final bool isSelected;
  final bool isSubmitted;
  final bool isCorrect;
  final QuizController controller;

  const OptionTile({
   required this.label,
   required this.index,
   required this.isSelected,
   required this.isSubmitted,
   required this.isCorrect,
   required this.controller,
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

   return RadioListTile<int>(
    value: index,
    groupValue: controller.selectedOption.value,
    onChanged: isSubmitted ? null : (value) {
     if (value != null) controller.selectOption(value);
    },
    title: Text(label),
    secondary: feedbackIcon != null
        ? Icon(feedbackIcon, color: iconColor)
        : null,
   );
  }
 }
