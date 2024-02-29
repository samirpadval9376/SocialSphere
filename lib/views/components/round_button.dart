import 'package:flutter/material.dart';
import 'package:social_media_app/utils/color_util.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final Color color, textColor;
  final bool isLoading;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPress,
    this.color = AppColor.primaryColor,
    this.textColor = AppColor.primaryColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPress,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 16,
                        color: textColor,
                      ),
                ),
        ),
      ),
    );
  }
}
