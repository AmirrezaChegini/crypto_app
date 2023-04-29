import 'package:crypto_app/bloc/top_crypto/top_crypto_bloc.dart';
import 'package:crypto_app/bloc/top_crypto/top_crypto_event.dart';
import 'package:crypto_app/bloc/top_crypto/top_crypto_state.dart';
import 'package:crypto_app/data/models/banner_icon.dart';
import 'package:crypto_app/data/models/crypto.dart';
import 'package:crypto_app/utils/my_colors.dart';
import 'package:crypto_app/widgets/banner_icon.dart';
import 'package:crypto_app/widgets/currency_item.dart';
import 'package:crypto_app/widgets/refresh_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<BannerIconData> bannerIcons = [
    BannerIconData('Buy', Icons.control_point_duplicate_outlined),
    BannerIconData('Sell', Icons.paid_outlined),
    BannerIconData('Send', Icons.add_card_outlined),
    BannerIconData('Receive', Icons.payment_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: TopHeader(),
              ),
            ),
            SliverToBoxAdapter(
              child: MainBanner(bannerIcons: bannerIcons),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<TopCryptoBloc, TopCryptoState>(
                builder: (context, state) {
                  if (state is LoadingTopCryptoState) {
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const CircularProgressIndicator(
                        color: MyColors.blue,
                      ),
                    );
                  }

                  if (state is FailedTopCryptoState) {
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: RefreshBtn(
                        onTap: () {
                          BlocProvider.of<TopCryptoBloc>(context)
                              .add(TopCryptoEvent());
                        },
                      ),
                    );
                  }

                  if (state is CompletedTopCryptoState) {
                    return CurrencyList(cryptoList: state.cryptoList);
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyList extends StatelessWidget {
  const CurrencyList({super.key, required this.cryptoList});
  final List<Crypto> cryptoList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: MyColors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Text(
              'Top 10 Market',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'pj-bold',
                color: MyColors.black,
              ),
            ),
          ),
          ...List.generate(
            cryptoList.length,
            (index) => CurrencyItem(crypto: cryptoList[index]),
          ),
        ],
      ),
    );
  }
}

class MainBanner extends StatelessWidget {
  const MainBanner({super.key, required this.bannerIcons});

  final List<BannerIconData> bannerIcons;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: MyColors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          const InnerBanner(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4,
              (index) => BannerIcon(bannerIconData: bannerIcons[index]),
            ),
          )
        ],
      ),
    );
  }
}

class InnerBanner extends StatelessWidget {
  const InnerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: MyColors.darkGrey,
          boxShadow: const [
            BoxShadow(
              color: MyColors.darkGrey,
              blurRadius: 15,
              blurStyle: BlurStyle.normal,
              spreadRadius: -10,
              offset: Offset(0, 14),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Your Balance',
            style: TextStyle(
              fontFamily: 'pj-medium',
              color: MyColors.white,
            ),
          ),
          const Text(
            'USD 52.500,65',
            style: TextStyle(
              fontFamily: 'pj-bold',
              fontSize: 24,
              color: MyColors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ProfitContainer(text: 'Profit: \$ 5520'),
              SizedBox(width: 20),
              ProfitContainer(text: 'Yeild: 8.98 %'),
            ],
          )
        ],
      ),
    );
  }
}

class ProfitContainer extends StatelessWidget {
  const ProfitContainer({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: MyColors.grey,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'pj-medium',
          color: MyColors.white,
        ),
      ),
    );
  }
}

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning 👋',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'pj-bold',
                color: MyColors.grey,
              ),
            ),
            Text(
              'Amirreza Chegini',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'pj-bold',
                color: MyColors.darkGrey,
              ),
            )
          ],
        ),
        Material(
          borderRadius: BorderRadius.circular(10),
          color: MyColors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: MyColors.backColor,
            highlightColor: MyColors.backColor,
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: MyColors.grey.withOpacity(0.3),
                ),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: MyColors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
