// List<LearningCenter> result = [];

import 'package:flutter/material.dart';
import 'package:sign2/features/Recommendation%20System/controller/firebase_operations.dart';
import 'package:sign2/features/Recommendation%20System/model/learning_center_model.dart';
import 'package:sign2/features/Recommendation%20System/view/search_screen.dart';
import 'package:sign2/support/custom_widgets/custom_centers_card.dart';
import 'package:sign2/support/theme/app_colors.dart';

class LearningCenters extends StatefulWidget {
  const LearningCenters({super.key});
  static String routeName="/learningCenter";

  @override
  State<LearningCenters> createState() => _LearningCentersState();
}

class _LearningCentersState extends State<LearningCenters> {
  List<LearningCenter> centers = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isEmpty = false;
  Future<void> _fetchLearningCenters() async {
    try {
      centers = await operations.fetchLearningCenters();

      if (centers.isEmpty) {
        setState(() {
          _isEmpty = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          centers = centers;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text("Error: $_errorMessage"));
    }
    if (_isEmpty) {
      return const Center(child: Text("No learning centers found."));
    }

    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 20,
          );
        },
        itemCount: (isFiltered) ? result.length : centers.length,
        itemBuilder: (context, index) {
          if (isFiltered) {
            final center = result[index];
            return CustomCentersCard(center: center);
          } else {
            final center = centers[index];
            return CustomCentersCard(center: center);
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchLearningCenters();
  }

  bool isFiltered = false;
  @override
  Widget build(BuildContext context) {
    final operations = FirebaseOperations();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.darkNavy),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Container(
              width: 320,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkNavy)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Search for a center...",
                      style:
                          TextStyle(color: AppColors.darkPurple, fontSize: 16),
                    ),
                    const Icon(Icons.search)
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: PopupMenuButton<String>(
            onSelected: (value) async {
              isFiltered = true;
              result = await operations.sortCenters(value);
              setState(() {});
            },
            icon: Icon(
              Icons.filter_list_rounded,
              color: AppColors.darkNavy,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Highest Price',
                child: Text('Highest Price'),
              ),
              const PopupMenuItem<String>(
                value: 'Lowest Price',
                child: Text('Lowest Price'),
              ),
              const PopupMenuItem<String>(
                value: 'Rating',
                child: Text('Rating'),
              ),
            ],
          ),
        ),
        _buildContent()
      ]),
    );
  }
}
