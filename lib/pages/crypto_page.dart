import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/models/crypto.dart';
import 'package:crypto_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class CryptoPage extends StatefulWidget {
  final Crypto crypto;
  CryptoPage(this.crypto);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  List<String> ChipseTitle = [
    'Today',
    'Week',
    'Month',
  ];
  List<bool> chipsSelected = [
    true,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.navyBlue,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        widget.crypto.name,
        style: TextStyle(
          color: Constants.white2,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: Container(
          height: 200,
          child: Row(
            children: [
              SizedBox(width: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: '${Constants.iconCryptoApi}${widget.crypto.id}.png',
                  fit: BoxFit.fill,
                  width: 70,
                  height: 70,
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Text(
                      'Price : \$${widget.crypto.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Constants.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Highest Price : \$${widget.crypto.highPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Constants.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Lowest Price : \$${widget.crypto.lowPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Constants.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Market Cap : \$${widget.crypto.marketCap.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Constants.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Constants.white2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //show crypto chart
          SvgPicture.network(
            chartCryptoApi(),
            fit: BoxFit.fill,
            height: 200,
            width: double.infinity,
            color: Constants.orange,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(
                ChipseTitle.length,
                (index) => ChoiceChip(
                  label: Text(ChipseTitle[index]),
                  selected: chipsSelected[index],
                  onSelected: (value) {
                    //for show which chipse is selected
                    setState(() {
                      //first select false all chipse
                      for (var i = 0; i < ChipseTitle.length; i++) {
                        chipsSelected[i] = false;
                      }
                      //then the chipse choosen by the user are selected
                      chipsSelected[index] = true;
                    });
                  },
                  backgroundColor: Constants.white2,
                  selectedColor: Colors.grey.withOpacity(0.3),
                  elevation: 0,
                  pressElevation: 1,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //this method call crypto chart api base on crypto and chipse selected
  String chartCryptoApi() {
    if (chipsSelected[0] == true) {
      return 'https://s3.coinmarketcap.com/generated/sparklines/web/1d/2781/${widget.crypto.id}.svg';
    } else if (chipsSelected[1] == true) {
      return 'https://s3.coinmarketcap.com/generated/sparklines/web/7d/2781/${widget.crypto.id}.svg';
    } else {
      return 'https://s3.coinmarketcap.com/generated/sparklines/web/30d/2781/${widget.crypto.id}.svg';
    }
  }
}
