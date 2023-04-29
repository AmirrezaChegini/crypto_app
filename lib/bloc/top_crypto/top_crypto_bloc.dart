import 'package:crypto_app/bloc/top_crypto/top_crypto_event.dart';
import 'package:crypto_app/bloc/top_crypto/top_crypto_state.dart';
import 'package:crypto_app/data/repositories/crypto_repository.dart';
import 'package:crypto_app/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopCryptoBloc extends Bloc<TopCryptoEvent, TopCryptoState> {
  final ICryptoRepository _repository = locator.get();

  TopCryptoBloc() : super(LoadingTopCryptoState()) {
    on<TopCryptoEvent>((event, emit) async {
      emit(LoadingTopCryptoState());
      var either = await _repository.getTop10Crypto();

      either.fold((l) {
        emit(FailedTopCryptoState(l));
      }, (r) {
        emit(CompletedTopCryptoState(r));
      });
    });
  }
}
