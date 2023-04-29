import 'package:crypto_app/bloc/all_crypto/all_crypto_bloc.dart';
import 'package:crypto_app/bloc/all_crypto/all_crypto_event.dart';
import 'package:crypto_app/bloc/top_crypto/top_crypto_bloc.dart';
import 'package:crypto_app/bloc/top_crypto/top_crypto_event.dart';
import 'package:crypto_app/cubit/bottom_nav_cubit.dart';
import 'package:crypto_app/pages/crypto_page.dart';
import 'package:crypto_app/pages/exchange_page.dart';
import 'package:crypto_app/pages/home_page.dart';
import 'package:crypto_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainApplicationPage extends StatefulWidget {
  const MainApplicationPage({super.key});

  @override
  State<MainApplicationPage> createState() => _MainApplicationPageState();
}

class _MainApplicationPageState extends State<MainApplicationPage> {
  final TextEditingController _edtCtrl1 = TextEditingController();
  final TextEditingController _edtCtrl2 = TextEditingController();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<TopCryptoBloc>(context).add(TopCryptoEvent());
    BlocProvider.of<AllCryptoBloc>(context).add(AllCryptoEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _edtCtrl1.dispose();
    _edtCtrl2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: BlocBuilder<BottomNavCubit, int>(
        builder: (context, state) => IndexedStack(
          index: state,
          children: [
            const HomePage(),
            const CryptoPage(),
            ExchangePage(
              edtCtrl1: _edtCtrl1,
              edtCtrl2: _edtCtrl2,
            ),
          ],
        ),
      ),
    );
  }
}
