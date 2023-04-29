import 'package:crypto_app/data/models/banner_icon.dart';
import 'package:crypto_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class BannerIcon extends StatelessWidget {
  const BannerIcon({super.key, required this.bannerIconData});

  final BannerIconData bannerIconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.blue,
            ),
            child: Icon(
              bannerIconData.iconData,
              color: MyColors.white,
            ),
          ),
          Text(
            bannerIconData.text,
            style: const TextStyle(
              fontFamily: 'pj-bold',
              color: MyColors.darkGrey,
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }
}
