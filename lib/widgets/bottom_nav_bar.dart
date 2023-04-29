import 'package:crypto_app/cubit/bottom_nav_cubit.dart';
import 'package:crypto_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, state) => BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: state,
        onTap: (value) =>
            BlocProvider.of<BottomNavCubit>(context).chnagePage(value),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home.png',
              color: MyColors.black,
            ),
            activeIcon: Image.asset(
              'assets/images/home.png',
              color: MyColors.blue,
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/search.png',
              color: MyColors.black,
            ),
            activeIcon: Image.asset(
              'assets/images/search.png',
              color: MyColors.blue,
            ),
            label: 'search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.currency_exchange_outlined,
              color: MyColors.black,
            ),
            activeIcon: Icon(
              Icons.currency_exchange_outlined,
              color: MyColors.blue,
            ),
            label: 'exchnage',
          ),
        ],
      ),
    );
  }
}
