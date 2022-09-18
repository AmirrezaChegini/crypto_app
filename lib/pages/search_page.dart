import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/models/crypto.dart';
import 'package:crypto_app/pages/crypto_page.dart';
import 'package:crypto_app/utils/constants.dart';
import 'package:flutter/material.dart';

class SearchPage extends ModalRoute {
  List<Crypto> cryptoList;
  List<Crypto> filterCryptoList = [];
  TextEditingController edtCtrl = TextEditingController();
  SearchPage(this.cryptoList);

  @override
  Color? get barrierColor => Constants.black.withOpacity(0.6);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
        //create animation for whole search page
    // add fade animation
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    edtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Scaffold(
      backgroundColor: Constants.navyBlue,
      resizeToAvoidBottomInset: false,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 13,
            child: _textField(context),
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
            (context, index) =>
                _sliverListChild(filterCryptoList[index], context),
          ),
        ),
      ],
    );
  }

  Widget _sliverListChild(Crypto crypto, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        color: Constants.white,
        elevation: 4,
        child: InkWell(
          //go to crypto page
          onTap: () => goToCryptoPage(crypto, context),
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

  Widget _textField(BuildContext context) {
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
                    //when user tab the close btn text filed will empty and show nothing in search list
                    edtCtrl.clear();
                    filterCryptoList = [];
                    //set state for modal route
                    changedExternalState();
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

  void goToCryptoPage(Crypto crypto, BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CryptoPage(crypto)),
    );
  }

  void searchList(String value) {
    if (value.isEmpty) {
      //when text filed is empty show nothing.
      filterCryptoList = [];
    } else {
      //when user writing in text field show crypto based on user's input
      filterCryptoList = cryptoList
          .where((crypto) =>
              crypto.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    //set state in modal route
    changedExternalState();
  }
}
