import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/models/crypto.dart';
import 'package:crypto_app/pages/crypto_page.dart';
import 'package:crypto_app/utils/constants.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List<Crypto> cryptoList;
  SearchPage(this.cryptoList);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Crypto> filterCryptoList = [];
  TextEditingController edtCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    edtCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.navyBlue,
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 13,
            child: _textField(),
          ),
          Expanded(
            flex: 87,
            child: Container(
              decoration: BoxDecoration(
                color: Constants.white2,
              ),
              child: _searchResult(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchResult() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: filterCryptoList.length,
            (context, index) => _sliverListChild(filterCryptoList[index]),
          ),
        ),
      ],
    );
  }

  Widget _sliverListChild(
    Crypto crypto,
  ) {
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

  Widget _textField() {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: edtCtrl,
              //when user start writing this method started
              onChanged: (value) => searchList(value),
              keyboardType: TextInputType.text,
              cursorColor: Constants.navyBlue,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                fillColor: Constants.white,
                filled: true,
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(100),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      //when user tab the close btn text filed will empty and show nothing in search list
                      edtCtrl.clear();
                      filterCryptoList = [];
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: Constants.navyBlue,
                  ),
                  splashRadius: 20,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: () {
              //when user tab cancel btn go back to home page.
              Navigator.pop(context);
            },
            child: Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Constants.white2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goToCryptoPage(Crypto crypto) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CryptoPage(crypto),
        transitionDuration: Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void searchList(String value) {
    setState(() {
      if (value.isEmpty) {
        //when text filed is empty show nothing.
        filterCryptoList = [];
      } else {
        //when user writing in text field show crypto based on user's input
        filterCryptoList = widget.cryptoList
            .where((crypto) =>
                crypto.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }
}
