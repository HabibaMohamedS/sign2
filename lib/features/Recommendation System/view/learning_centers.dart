import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Recommendation%20System/model/firebase_operations.dart';
import 'package:sign2/features/Recommendation%20System/model/learning_center_model.dart';
import 'package:sign2/support/custom_widgets/custom_centers_card.dart';
import 'package:sign2/support/theme/app_colors.dart';


///TODO :add responsiveness ti=o the screen
class LearningCenters extends StatelessWidget {
  static const String routeName = "/learningCentersScreen";
  const LearningCenters({super.key});

  @override
  Widget build(BuildContext context) {
    final operations = FirebaseOperations();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.darkNavy,
        ),
      ),
      body: FutureBuilder<List<LearningCenter>>(
        future: operations.fetchLearningCenters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No learning centers found."));
          }
    
          final centers = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 30),
                  itemCount: centers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 24,
                          right: 24,
                          left: 24,
                        ),
                        child: TextFormField(
                          style: TextStyle(color: AppColors.darkNavy),
                          decoration: InputDecoration(
                            focusColor: AppColors.darkNavy,
                            hintText: "Search for a center",
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_alt_outlined),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.darkNavy),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    }
                    final center = centers[index - 1];
                    return CustomCentersCard(center: center);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
