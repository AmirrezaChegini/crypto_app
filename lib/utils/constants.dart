import 'package:flutter/material.dart';

class Constants {
  //Colors
  static final Color white = Colors.white;
  static final Color black = Colors.black;
  static final Color white2 = Color(0xfff8f9fd);
  static final Color navyBlue = Color(0xff111427);
  static final Color orange = Color(0xffff8901);
  static final Color pink = Color(0xffffd2f53);
  static final Color green = Color(0xff17b487);
  static final Color grey = Color(0xffeef1f8);

  //Urls
  static final String allCryptoApi =
      'https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=100&sortBy=market_cap&sortType=desc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap';

  static final String iconCryptoApi =
      'https://s2.coinmarketcap.com/static/img/coins/64x64/';

  static final String sparkLineCryptoApi =
      'https://s3.coinmarketcap.com/generated/sparklines/web/1d/2781/';
}
