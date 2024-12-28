import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final Color? textColor;
  final bool endIcon;

  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.textColor = Colors.black,
    this.endIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor),
                const SizedBox(width: 10),
                Text(title, style: TextStyle(color: textColor)),
              ],
            ),
            if (endIcon)
              const Icon(
                FontAwesomeIcons.chevronRight,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
