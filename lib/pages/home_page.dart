import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/models/crypto.dart';
import 'package:crypto_app/pages/crypto_page.dart';
import 'package:crypto_app/pages/search_page.dart';
import 'package:crypto_app/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  List<Crypto> cryptoList;
  HomePage(this.cryptoList);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double height = 80;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.navyBlue,
      body: _body(),
    );
  }

  Widget _body() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _sliverAppBar(),
        ];
      },
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Constants.white2,
        ),
        child: RefreshIndicator(
          //refresh data
          onRefresh: () => refreshCryptoApi(),
          color: Constants.navyBlue,
          child: _customScrollView(),
        ),
      ),
    );
  }

  Widget _customScrollView() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 30),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Crypto Wallet',
              style: TextStyle(
                color: Constants.navyBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: widget.cryptoList.length,
            (context, index) => _sliverListChild(widget.cryptoList[index]),
          ),
        ),
      ],
    );
  }

  Widget _sliverListChild(Crypto crypto) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        color: Constants.white,
        elevation: 4,
        child: InkWell(
          //go to crypto page
          onTap: () => goToCryptoPage(crypto),
          splashColor: Constants.grey,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(8),
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                SizedBox(width: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: '${Constants.iconCryptoApi}${crypto.id}.png',
                    fit: BoxFit.fill,
                    width: 55,
                    height: 55,
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crypto.name,
                        maxLines: 1,
                        style: TextStyle(
                          color: Constants.navyBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        crypto.symbol,
                        style: TextStyle(
                          color: Constants.black.withOpacity(0.4),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '${crypto.percentChange24.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: crypto.percentChange24 >= 0
                            ? Constants.green
                            : Constants.pink,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      crypto.percentChange24 >= 0
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: crypto.percentChange24 >= 0
                          ? Constants.green
                          : Constants.pink,
                      size: 20,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: true,
      backgroundColor: Constants.navyBlue,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/person.png',
                    height: 60,
                    width: 60,
                  ),
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Constants.white2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    //go to search page
                    onPressed: () => goToSearchPage(),
                    icon: Icon(
                      Icons.search,
                    ),
                    color: Constants.white2,
                    iconSize: 35,
                    splashRadius: 30,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'USD',
                    style: TextStyle(
                      color: Constants.grey.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    ' \$${totalBalance()}',
                    style: TextStyle(
                      color: Constants.white2,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //for get total price value in home page
  String totalBalance() {
    double x = 0;
    for (var i = 0; i < widget.cryptoList.length; i++) {
      x += widget.cryptoList[i].price;
    }
    return x.toStringAsFixed(4);
  }

  void goToSearchPage() {
    Navigator.push(context, SearchPage(widget.cryptoList));
  }

  void goToCryptoPage(Crypto crypto) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CryptoPage(crypto)),
    );
  }

  Future<void> refreshCryptoApi() async {
    try {
      Response response = await Dio().get(Constants.allCryptoApi);

      setState(() {
        widget.cryptoList = response.data['data']['cryptoCurrencyList']
            .map<Crypto>((e) => Crypto.fromMapJson(e))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text('No Internet Connection'),
          action: SnackBarAction(
            onPressed: () => refreshCryptoApi(),
            label: 'Retry',
          ),
        ),
      );
    }
  }
}
