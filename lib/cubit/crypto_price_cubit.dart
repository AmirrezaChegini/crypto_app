import 'package:bloc/bloc.dart';
import 'package:crypto_app/data/repositories/crypto_repository.dart';
import 'package:crypto_app/di.dart';

class CryptoPriceCubit extends Cubit<String> {
  CryptoPriceCubit() : super('');
  final ICryptoRepository _repository = locator.get();
  String type = 'Dollar';
  String symbol = 'BTC';

  Future<void> getPrices(double amount) async {
    var either = await _repository.getCryptoPrice(symbol, amount);

    either.fold((l) {
      emit(l);
    }, (r) {
      if (type == 'Dollar') {
        emit(r[0].toString());
      } else if (type == 'Euro') {
        emit(r[1].toString());
      } else if (type == 'Rial') {
        emit(r[2].toString());
      } else {
        emit(r[0].toString());
      }
    });
  }
}
