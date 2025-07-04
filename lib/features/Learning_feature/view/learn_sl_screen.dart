import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/features/Learning_feature/view_model/learn_sl_state_management.dart';
import 'package:sign2/support/theme/app_images.dart';
import '../../../support/theme/app_text_styles.dart';
import '../../../support/theme/app_colors.dart';

import '../widgets/popular_category_slider_card.dart';
import '../widgets/slider_card.dart';
import 'category_details_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LearnSlScreen extends StatelessWidget {
  static const String routeName = "/learnSlScreen";
  final LearnSlViewModel viewModel = Get.put(LearnSlViewModel());

  LearnSlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
     
        body: Obx(() {
          if (viewModel.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final popular = [...viewModel.categories]..shuffle();
          final selectedPopular = popular.take(10).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 3.h, right: 10.w, left: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Get.back(),
                  ),
                  // _buildTitle("Your Progress"),
                  // LinearProgressIndicator(
                  //   value: 0.5,
                  //   backgroundColor: const Color.fromARGB(62, 158, 158, 158),
                  //   borderRadius: BorderRadius.circular(32.r),
                  //   color: AppColors.orange,
                  //   minHeight: 32.0.h,
                  // ),
                  _buildTitle("Learn ArSL 🌟"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                    child: Text(
                      "Master Arabic Sign Language one step at a time",
                      style: AppTextStyle.caption,
                    ),
                  ),

                  _buildTitle("Categories"),
                  CarouselSlider(
                    options: CarouselOptions(
                      initialPage: 1,
                      height: 302.h,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.7,
                    ),
                    items:
                        viewModel.categories.map((category) {
                          return SliderCard(
                            categoryName: category.title ?? "",
                            cardContent:
                                "Find out how to do Arabic ${category.title} in ArSL.",
                            onTap: () {
                              Get.toNamed(
                                CategoryDetailsScreen.routeName,
                                arguments: {
                                  'playlistId': category.playlistId,
                                  'title': category.title,
                                },
                              );
                            },
                          );
                        }).toList(),
                  ),
                  _buildTitle("Popular"),

                  SizedBox(
                    height: 250.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedPopular.length,
                      itemBuilder: (context, index) {
                        final category = selectedPopular[index];
                        return Padding(
                          padding: EdgeInsets.all(8.0.h),
                          child: PopularCategorySliderCard(
                            title: category.title ?? '',
                            onTap: () {
                              Get.toNamed(
                                CategoryDetailsScreen.routeName,
                                arguments: {
                                  'playlistId': category.playlistId,
                                  'title': category.title,
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTitle(String text) => Padding(
    padding: EdgeInsets.all(18.0.h),
    child: Text(text, style: AppTextStyle.titles),
  );
}
