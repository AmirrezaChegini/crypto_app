import 'package:crypto_app/data/models/crypto.dart';

abstract class AllCryptoState {}

class LoadingAllCryptoState extends AllCryptoState {}

class CompletedAllCryptoState extends AllCryptoState {
  List<Crypto> allCrypto;
  CompletedAllCryptoState(this.allCrypto);
}

class FailedAllCryptoState extends AllCryptoState {
  String errorMessage;
  FailedAllCryptoState(this.errorMessage);
}
