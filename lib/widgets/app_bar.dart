import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? trailing;
  final bool centerTitle;
  final double height;

  const AppAppBar({
    super.key,
    required this.title,
    this.trailing,
    this.centerTitle = false, // Option to center the title
    this.height = 140.0, // Default height value
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 16, right: 16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: centerTitle
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              // If title is centered, ensure it takes available space and trailing widgets are not displayed
              if (!centerTitle)
                Expanded(
                  child: title,
                ),
              if (centerTitle) title,
              if (!centerTitle)
                Row(
                  children: trailing ??
                      [], // Display trailing widgets if not centering the title
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Add more widgets here if needed
        ],
      ),
    );
  }
}
