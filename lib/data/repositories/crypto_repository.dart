import 'package:crypto_app/data/datasources/crypto_datasource.dart';
import 'package:crypto_app/data/models/crypto.dart';
import 'package:crypto_app/di.dart';
import 'package:crypto_app/utils/error_handler/app_exception.dart';
import 'package:dartz/dartz.dart';

abstract class ICryptoRepository {
  Future<Either<String, List<Crypto>>> getTop10Crypto();
  Future<Either<String, List<Crypto>>> getAllCrypto();
  Future<Either<String, List>> getCryptoPrice(String symbol, double amount);
}

class CryptoRepository implements ICryptoRepository {
  final CryptoDataSource _dataSource = locator.get();

  @override
  Future<Either<String, List<Crypto>>> getTop10Crypto() async {
    try {
      List<Crypto> cryptoList = await _dataSource.getTop10Crypto();
      return right(cryptoList);
    } on AppException catch (ex) {
      return left(ex.message);
    }
  }

  @override
  Future<Either<String, List<Crypto>>> getAllCrypto() async {
    try {
      List<Crypto> cryptoList = await _dataSource.getAllCrypto();
      return right(cryptoList);
    } on AppException catch (ex) {
      return left(ex.message);
    }
  }

  @override
  Future<Either<String, List>> getCryptoPrice(
      String symbol, double amount) async {
    try {
      List prices = await _dataSource.getCryptoPrice(symbol);
      var usd = prices[0];
      var eur = prices[1];
      var rial = prices[2];

      var totalUsd = amount * usd;
      var totalEur = amount * eur;
      var totalRial = rial * usd * amount;

      prices[0] = totalUsd;
      prices[1] = totalEur;
      prices[2] = totalRial;

      return right(prices);
    } on AppException catch (ex) {
      return left(ex.message);
    }
  }
}
