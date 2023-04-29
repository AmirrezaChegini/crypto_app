import 'package:crypto_app/data/models/crypto.dart';

abstract class TopCryptoState {}

class LoadingTopCryptoState extends TopCryptoState {}

class CompletedTopCryptoState extends TopCryptoState {
  List<Crypto> cryptoList;
  CompletedTopCryptoState(this.cryptoList);
}

class FailedTopCryptoState extends TopCryptoState {
  String errorMessage;
  FailedTopCryptoState(this.errorMessage);
}
