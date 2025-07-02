import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign2/features/Learning_feature/view/category_details_screen.dart';
import 'package:sign2/features/Learning_feature/widgets/popular_category_slider_card.dart';
import 'package:sign2/features/Learning_feature/widgets/slider_card.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_text_styles.dart';

///TODO: NEED Navigation to the homescreen
class LearnSlScreen extends StatefulWidget {
  static const String routeName = "/learnSlScreen";
  const LearnSlScreen.learnSLScreen({super.key});

  @override
  State<LearnSlScreen> createState() => _LearnSlScreenState();
}

class _LearnSlScreenState extends State<LearnSlScreen> {
  List<Map<String, dynamic>> _categories = [];
  //List<Map<String, dynamic>> _popularCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('youtube_playlists')
          .get();
      final categories = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'],
          'thumbnail': data['thumbnail'],
        };
      }).toList();

      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchLessons(String playlistId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('youtube_playlists')
        .doc(playlistId)
        .collection('videos')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'],
        'thumbnail': data['thumbnail'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final popularCategories = [..._categories]..shuffle();
    final selectedPopular = popularCategories.take(10).toList();

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.only(top: 20.h, right: 10.w, left: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(18.0.h),
                      child: Text("Your Progress", style: AppTextStyle.titles),
                    ),
                    LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: const Color.fromARGB(62, 158, 158, 158),
                      borderRadius: BorderRadius.circular(32.r),
                      color: AppColors.orange,
                      minHeight: 32.0.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(18.0.h),
                      child: Text("Learn ASL 🌟", style: AppTextStyle.titles),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(18.0.h),
                    //   child: Stack(
                    //     children: [
                    //       Container(
                    //         padding: EdgeInsets.only(right: 125.w),
                    //         height: 130.h,
                    //         width: double.infinity,
                    //         child: Text(
                    //           "Want to continue from where you left off ? Click start !",
                    //           style: AppTextStyle.caption,
                    //         ),
                    //       ),
                    //       Positioned(
                    //         bottom: 0,
                    //         right: 0,
                    //         child: ElevatedButton(
                    //           onPressed: () {},
                    //           style: ElevatedButton.styleFrom(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(10.r),
                    //             ),
                    //             backgroundColor: AppColors.darkNavy,
                    //             padding: EdgeInsets.symmetric(
                    //                 vertical: 20.h, horizontal: 35.w),
                    //           ),
                    //           child: Text(
                    //             "Start",
                    //             style: AppTextStyle.buttonLabel,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(18.0.h), //.h
    
                      child: Text("Categories", style: AppTextStyle.titles),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 302.h,
                        aspectRatio: 302 / 267,
                        initialPage: 1,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.7,
                        scrollDirection: Axis.horizontal,
                      ),
                      //for each category in categories
                      items: _categories.map((category) {
                        //Find out how to do Arabic letters in ArSL.
                        return SliderCard(
                          cardContent:
                              "Find out how to do Arabic ${category['title']} in ArSL.",
                          categoryName: category['title'],
                          onTap: () {
                            
                            Get.toNamed(
                              CategoryDetailsScreen.routeName,
                              arguments: {
                                'playlistId': category['id'],
                                'title': category['title'],
                              },
                            );
                              // Navigate or fetch lessons here
                          },
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(18.0.sp),
                      child: Text("Popular", style: AppTextStyle.titles),
                    ),
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
                              title: category['title'],
                              onTap: (){
                                Get.toNamed(
                              CategoryDetailsScreen.routeName,
                              arguments: {
                                'playlistId': category['id'],
                                'title': category['title'],
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
            ),
    );
  }
}
