import 'package:crypto_app/bloc/all_crypto/all_crypto_bloc.dart';
import 'package:crypto_app/bloc/all_crypto/all_crypto_event.dart';
import 'package:crypto_app/bloc/all_crypto/all_crypto_state.dart';
import 'package:crypto_app/data/models/crypto.dart';
import 'package:crypto_app/utils/my_colors.dart';
import 'package:crypto_app/widgets/currency_item.dart';
import 'package:crypto_app/widgets/edt_text_search.dart';
import 'package:crypto_app/widgets/refresh_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptoPage extends StatelessWidget {
  const CryptoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backColor,
      body: SafeArea(
        child: BlocBuilder<AllCryptoBloc, AllCryptoState>(
          builder: (context, state) {
            if (state is LoadingAllCryptoState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MyColors.blue,
                ),
              );
            }
            if (state is CompletedAllCryptoState) {
              return Body(cryptoList: state.allCrypto);
            }
            if (state is FailedAllCryptoState) {
              return Center(
                child: RefreshBtn(
                  onTap: () {
                    BlocProvider.of<AllCryptoBloc>(context)
                        .add(AllCryptoEvent());
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Body extends StatefulWidget {
  Body({super.key, required this.cryptoList});
  List<Crypto> cryptoList;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Crypto> cryptoList2 = [];

  @override
  void initState() {
    super.initState();
    cryptoList2 = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: EdtTextSearch(
                onChanged: (value) {
                  setState(() {
                    value.isNotEmpty
                        ? widget.cryptoList = widget.cryptoList.where((e) {
                            return e.name
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList()
                        : widget.cryptoList = cryptoList2;
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: MyColors.white,
                border: Border.all(
                  width: 1,
                  color: MyColors.grey.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: List.generate(
                  widget.cryptoList.length,
                  (index) => CurrencyItem(crypto: widget.cryptoList[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
