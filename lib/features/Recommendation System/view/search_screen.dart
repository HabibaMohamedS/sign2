import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp_dictionary/features/Recommendation%20System/controller/firebase_operations.dart';
import 'package:gp_dictionary/features/Recommendation%20System/model/learning_center_model.dart';
import 'package:gp_dictionary/support/custom_widgets/custom_centers_card.dart';
import 'package:gp_dictionary/support/theme/app_colors.dart';

final searchController = Get.put(SearchController());
final TextEditingController controller = TextEditingController();
final operations = FirebaseOperations();
List<LearningCenter> result = [];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              style: TextStyle(color: AppColors.darkNavy),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        result = await operations
                            .searchCentersByName(controller.text);
                        setState(() {});
                        print("###### $result");
                      },
                      icon: const Icon(Icons.search)),
                  label: Text(
                    "Search for a center...",
                    style: TextStyle(color: AppColors.darkPurple, fontSize: 16),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.darkNavy),
                      borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: result.length,
                itemBuilder: (context, index) {
                  var center = result[index];
                  return CustomCentersCard(center: center);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
