import 'package:flutter/material.dart';
import 'package:sign2/features/Recommendation%20System/model/learning_center_model.dart';
import 'package:sign2/features/Recommendation%20System/view/center_details_screen.dart';
import 'package:sign2/support/theme/app_colors.dart';

class CustomCentersCard extends StatelessWidget {
  final LearningCenter center;
  const CustomCentersCard({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, right: 22.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CenterDetailsScreen(center: center),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.29,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 4, // Soften the shadow
                offset: const Offset(0, 4),
                color: Colors.black.withOpacity(0.25),
              ),
            ],
            color: const Color.fromRGBO(255, 227, 219, 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.darkNavy),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/${center.image}.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 24, left: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      center.name,
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.darkNavy,
                        fontFamily: "Poppins-SemiBold",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${center.price} EGP",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.darkNavy,
                        fontFamily: "Poppins-SemiBold",
                        fontWeight: FontWeight.w600,
                      ),
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
