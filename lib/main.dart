import 'package:crypto_app/bloc/all_crypto/all_crypto_bloc.dart';
import 'package:crypto_app/bloc/top_crypto/top_crypto_bloc.dart';
import 'package:crypto_app/cubit/bottom_nav_cubit.dart';
import 'package:crypto_app/cubit/crypto_price_cubit.dart';
import 'package:crypto_app/di.dart';
import 'package:crypto_app/pages/main_application_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await initLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => TopCryptoBloc()),
        BlocProvider(create: (context) => AllCryptoBloc()),
        BlocProvider(create: (context) => CryptoPriceCubit()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApplicationPage(),
    );
  }
}
