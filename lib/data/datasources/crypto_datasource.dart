import 'package:crypto_app/data/models/crypto.dart';
import 'package:crypto_app/di.dart';
import 'package:crypto_app/utils/error_handler/app_exception.dart';
import 'package:crypto_app/utils/error_handler/check_exception.dart';
import 'package:dio/dio.dart';

abstract class CryptoDataSource {
  Future<List<Crypto>> getTop10Crypto();
  Future<List<Crypto>> getAllCrypto();
  Future<List> getCryptoPrice(String symbol);
}

class CryptoRemote implements CryptoDataSource {
  final Dio _dio = locator.get();

  @override
  Future<List<Crypto>> getTop10Crypto() async {
    try {
      Response response = await _dio
          .get(
              'https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=10&sortBy=market_cap&sortType=desc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap')
          .onError((DioError error, stackTrace) =>
              CheckException.response(error.response!));

      List<Crypto> cryptoList = response.data['data']['cryptoCurrencyList']
          .map<Crypto>((e) => Crypto.fromMapJson(e))
          .toList();

      return cryptoList;
    } catch (ex) {
      throw FetchDataEx();
    }
  }

  @override
  Future<List<Crypto>> getAllCrypto() async {
    try {
      Response response = await _dio
          .get(
              'https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=100&sortBy=market_cap&sortType=desc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap')
          .onError((DioError error, stackTrace) =>
              CheckException.response(error.response!));

      List<Crypto> cryptoList = response.data['data']['cryptoCurrencyList']
          .map<Crypto>((e) => Crypto.fromMapJson(e))
          .toList();

      return cryptoList;
    } catch (ex) {
      throw FetchDataEx();
    }
  }

  @override
  Future<List> getCryptoPrice(String symbol) async {
    try {
      Response response = await _dio
          .get(
              'https://min-api.cryptocompare.com/data/pricemulti?fsyms=$symbol&tsyms=USD,EUR')
          .onError((DioError error, stackTrace) =>
              CheckException.response(error.response!));
      var usd = response.data[symbol]['USD'];
      var eur = response.data[symbol]['EUR'];

      response = await _dio
          .get('https://price.xstack.ir:8080/api/price')
          .onError((DioError error, stackTrace) =>
              CheckException.response(error.response!));

      var rial = response.data['dollar'];

      List prices = [usd, eur, rial];
      return prices;
    } catch (ex) {
      throw FetchDataEx();
    }
  }
}
