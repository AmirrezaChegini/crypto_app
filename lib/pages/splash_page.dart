import 'package:crypto_app/models/crypto.dart';
import 'package:crypto_app/pages/home_page.dart';
import 'package:crypto_app/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    //call api
    callCryptoApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Image.asset(
          'assets/images/bitcoin.png',
          width: 250,
          height: 250,
        ),
        SizedBox(height: 25),
        Text(
          'C  R  Y  P  T  O',
          style: TextStyle(
            color: Constants.navyBlue,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 25),
        SpinKitSpinningLines(
          color: Constants.navyBlue,
          size: 50,
        )
      ],
    );
  }

  Future<void> callCryptoApi() async {
    try {
      Response response = await Dio().get(Constants.allCryptoApi);

      //get data as list
      List<Crypto> cryptoList = response.data['data']['cryptoCurrencyList']
          .map<Crypto>((e) => Crypto.fromMapJson(e))
          .toList();

      //go to home page after get data correctly
      Future.delayed(
        Duration(seconds: 1),
        () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HomePage(cryptoList),
              transitionDuration: Duration(seconds: 1),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
      );
    } catch (e) {
      //show snackBar with error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text('No Internet Connection'),
          action: SnackBarAction(
            onPressed: () => callCryptoApi(),
            label: 'Retry',
          ),
        ),
      );
    }
  }
}
