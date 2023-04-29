import 'package:crypto_app/bloc/all_crypto/all_crypto_event.dart';
import 'package:crypto_app/bloc/all_crypto/all_crypto_state.dart';
import 'package:crypto_app/data/repositories/crypto_repository.dart';
import 'package:crypto_app/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCryptoBloc extends Bloc<AllCryptoEvent, AllCryptoState> {
  final ICryptoRepository _repository = locator.get();

  AllCryptoBloc() : super(LoadingAllCryptoState()) {
    on<AllCryptoEvent>((event, emit) async {
      emit(LoadingAllCryptoState());

      var either = await _repository.getAllCrypto();

      either.fold((l) {
        emit(FailedAllCryptoState(l));
      }, (r) {
        emit(CompletedAllCryptoState(r));
      });
    });
  }
}
