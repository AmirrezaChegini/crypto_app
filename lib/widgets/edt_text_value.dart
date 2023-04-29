import 'package:crypto_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class EdtTextValue extends StatelessWidget {
  const EdtTextValue({super.key, required this.edtCtrl});
  final TextEditingController edtCtrl;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: edtCtrl,
      keyboardType: TextInputType.number,
      cursorColor: MyColors.darkGrey,
      enabled: false,
      style: const TextStyle(
        color: MyColors.black,
        fontFamily: 'pj-bold',
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
