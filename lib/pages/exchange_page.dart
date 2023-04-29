import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/bloc/all_crypto/all_crypto_bloc.dart';
import 'package:crypto_app/bloc/all_crypto/all_crypto_state.dart';
import 'package:crypto_app/bloc/top_crypto/top_crypto_bloc.dart';
import 'package:crypto_app/bloc/top_crypto/top_crypto_event.dart';
import 'package:crypto_app/cubit/crypto_price_cubit.dart';
import 'package:crypto_app/data/models/crypto.dart';
import 'package:crypto_app/utils/my_colors.dart';
import 'package:crypto_app/widgets/edt_text_value.dart';
import 'package:crypto_app/widgets/refresh_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangePage extends StatelessWidget {
  const ExchangePage({
    super.key,
    required this.edtCtrl1,
    required this.edtCtrl2,
  });

  final TextEditingController edtCtrl1;
  final TextEditingController edtCtrl2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            BlocBuilder<AllCryptoBloc, AllCryptoState>(
              builder: (context, state) {
                if (state is LoadingAllCryptoState) {
                  return const CircularProgressIndicator(
                    color: MyColors.blue,
                  );
                }
                if (state is CompletedAllCryptoState) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                        color: MyColors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PayValue(
                          widget: EdtTextValue(edtCtrl: edtCtrl1),
                          text: 'Your Pay',
                          cryptoList: state.allCrypto,
                        ),
                        Divider(
                          color: MyColors.grey.withOpacity(0.3),
                          thickness: 1,
                        ),
                        BlocListener<CryptoPriceCubit, String>(
                          listener: (context, state) {
                            edtCtrl2.text = state;
                          },
                          child: GetValue(
                            widget: EdtTextValue(edtCtrl: edtCtrl2),
                            text: 'Your Get',
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is FailedAllCryptoState) {
                  return RefreshBtn(
                    onTap: () {
                      BlocProvider.of<TopCryptoBloc>(context)
                          .add(TopCryptoEvent());
                    },
                  );
                }
                return const SizedBox();
              },
            ),
            const Spacer(),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 1,
                ),
                itemBuilder: (context, index) {
                  if (index == 11) {
                    return TextButton.icon(
                      onPressed: () {
                        edtCtrl1.text = edtCtrl1.text
                            .substring(0, edtCtrl1.text.length - 1);
                      },
                      onLongPress: () {
                        edtCtrl1.text = '';
                      },
                      icon: const Icon(Icons.backspace),
                      label: const SizedBox(),
                      style: TextButton.styleFrom(
                        foregroundColor: MyColors.black,
                      ),
                    );
                  } else {
                    List<String> padNumbers = [
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                      '.',
                      '0',
                    ];

                    return TextButton(
                      onPressed: () {
                        edtCtrl1.text += padNumbers[index];
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: MyColors.black,
                        textStyle: const TextStyle(
                          fontFamily: 'pj-bold',
                          fontSize: 24,
                        ),
                      ),
                      child: Text(padNumbers[index]),
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (edtCtrl1.text.isNotEmpty) {
                  BlocProvider.of<CryptoPriceCubit>(context)
                      .getPrices(double.parse(edtCtrl1.text));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.blue,
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(
                  fontFamily: 'pj-bold',
                  fontSize: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Swap'),
            ),
          ],
        ),
      ),
    );
  }
}

class PayValue extends StatefulWidget {
  const PayValue(
      {super.key,
      required this.widget,
      required this.text,
      required this.cryptoList});
  final Widget widget;
  final String text;
  final List<Crypto> cryptoList;

  @override
  State<PayValue> createState() => _PayValueState();
}

class _PayValueState extends State<PayValue> {
  late Crypto value;

  @override
  void initState() {
    super.initState();

    value = widget.cryptoList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  fontFamily: 'pj-bold',
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 50,
                child: widget.widget,
              )
            ],
          ),
        ),
        DropdownButton(
          items: <DropdownMenuItem>[
            ...List.generate(
              widget.cryptoList.length,
              (index) => DropdownMenuItem(
                value: widget.cryptoList[index],
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl: widget.cryptoList[index].image,
                        fit: BoxFit.fill,
                        width: 35,
                        height: 35,
                      ),
                    ),
                    Text(
                      widget.cryptoList[index].symbol,
                      style: const TextStyle(
                        fontFamily: 'pj-bold',
                        color: MyColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onChanged: (v) {
            setState(() {
              value = v;
            });

            BlocProvider.of<CryptoPriceCubit>(context).symbol = v.symbol;
          },
          menuMaxHeight: 300,
          borderRadius: BorderRadius.circular(15),
          icon: const Icon(Icons.arrow_forward_ios_outlined),
          iconSize: 18,
          hint: Row(
            children: [
              CachedNetworkImage(
                imageUrl: value.image,
                fit: BoxFit.fill,
                height: 35,
                width: 35,
              ),
              const SizedBox(width: 10),
              Text(
                value.symbol,
                style: const TextStyle(
                  fontFamily: 'pj-bold',
                  color: MyColors.darkGrey,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          underline: const SizedBox(),
        ),
      ],
    );
  }
}

class GetValue extends StatefulWidget {
  const GetValue({
    super.key,
    required this.widget,
    required this.text,
  });
  final Widget widget;
  final String text;

  @override
  State<GetValue> createState() => _GetValueState();
}

class _GetValueState extends State<GetValue> {
  List<String> values = ['Dollar', 'Euro', 'Rial'];
  late String value;

  @override
  void initState() {
    super.initState();
    value = values[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  fontFamily: 'pj-bold',
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 50,
                child: widget.widget,
              )
            ],
          ),
        ),
        DropdownButton(
          onChanged: (v) {
            setState(() {
              value = v;
            });
            BlocProvider.of<CryptoPriceCubit>(context).type = v;
          },
          items: <DropdownMenuItem>[
            ...List.generate(
              values.length,
              (index) => DropdownMenuItem(
                value: values[index],
                alignment: Alignment.center,
                child: Text(
                  values[index],
                  style: const TextStyle(
                    fontFamily: 'pj-bold',
                    color: MyColors.darkGrey,
                  ),
                ),
              ),
            ),
          ],
          menuMaxHeight: 300,
          borderRadius: BorderRadius.circular(15),
          icon: const Icon(Icons.arrow_forward_ios_outlined),
          iconSize: 18,
          hint: Text(
            value,
            style: const TextStyle(
              fontFamily: 'pj-bold',
              color: MyColors.darkGrey,
            ),
          ),
          underline: const SizedBox(),
        ),
      ],
    );
  }
}
