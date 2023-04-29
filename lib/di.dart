import 'package:crypto_app/data/datasources/crypto_datasource.dart';
import 'package:crypto_app/data/repositories/crypto_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

var locator = GetIt.I;

Future<void> initLocator() async {
  locator.registerSingleton<Dio>(
      Dio(BaseOptions(connectTimeout: const Duration(seconds: 5))));

  //datasource
  locator.registerSingleton<CryptoDataSource>(CryptoRemote());

  //repository
  locator.registerSingleton<ICryptoRepository>(CryptoRepository());
}
