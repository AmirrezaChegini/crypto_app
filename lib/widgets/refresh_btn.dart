import 'package:crypto_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class RefreshBtn extends StatelessWidget {
  const RefreshBtn({super.key, required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.blue,
        textStyle: const TextStyle(
          fontFamily: 'pj-bold',
          fontSize: 14,
        ),
      ),
      icon: const Icon(Icons.refresh),
      label: const Text('Retry'),
    );
  }
}
