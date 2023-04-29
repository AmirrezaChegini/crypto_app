import 'package:crypto_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class EdtTextSearch extends StatelessWidget {
  const EdtTextSearch({super.key, required this.onChanged});

  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      cursorColor: MyColors.darkGrey,
      style: const TextStyle(
        fontFamily: 'pj-bold',
        color: MyColors.darkGrey,
      ),
      onChanged: (value) => onChanged(value),
      decoration: InputDecoration(
        filled: true,
        fillColor: MyColors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: MyColors.grey.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: MyColors.grey.withOpacity(0.3),
          ),
        ),
        prefixIcon: Image.asset(
          'assets/images/search.png',
          color: MyColors.darkGrey,
        ),
        hintText: 'Search Crypto',
        hintStyle: const TextStyle(
          fontFamily: 'pj-bold',
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.all(0),
      ),
    );
  }
}
