import 'package:flutter/material.dart';
import 'package:sign2/features/Recommendation%20System/model/learning_center_model.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_text_styles.dart';

class CenterDetailsScreen extends StatelessWidget {
  final LearningCenter center;
  const CenterDetailsScreen({super.key, required this.center});
  ///TODO:add responsiveness to the screen 
  ///the texts style is aleady defined in another file 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(47),
                        bottomRight: Radius.circular(47),
                      ),
                      border: Border(
                        bottom: BorderSide(color: AppColors.darkNavy),
                      ),
                    ),
                    width: 482,
                    height: 420,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(47),
                        bottomRight: Radius.circular(47),
                      ),
                      child: Image.asset(
                        'assets/images/${center.image}.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.darkNavy,
      
                        /// el looon weeheshhh
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          center.name,
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.darkNavy,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: AppColors.darkNavy),
                            Text(
                              center.rating,
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.darkNavy,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      center.address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(41, 16, 74, 0.8),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      center.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(41, 16, 74, 0.8),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${center.price}LE / Week",
                          style: TextStyle(
                            fontSize: 22,
                            color: AppColors.darkNavy,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(136, 48),
                            backgroundColor: AppColors.darkNavy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text("Call", style: AppTextStyle.buttonText),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.call_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
