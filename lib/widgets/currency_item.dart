import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/data/models/crypto.dart';
import 'package:crypto_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class CurrencyItem extends StatelessWidget {
  const CurrencyItem({super.key, required this.crypto});
  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        crypto.name,
        style: const TextStyle(
          fontFamily: 'pj-bold',
        ),
      ),
      subtitle: Text(
        crypto.symbol,
        style: const TextStyle(
          fontFamily: 'pj-bold',
        ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: CachedNetworkImage(
          imageUrl: crypto.image,
          fit: BoxFit.fill,
          width: 45,
          height: 45,
        ),
      ),
      trailing: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$ ${crypto.price.toStringAsFixed(3)}',
              style: const TextStyle(
                fontFamily: 'pj-bold',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  crypto.percentChange >= 0
                      ? Icons.north_east_outlined
                      : Icons.south_east_outlined,
                  size: 18,
                  color:
                      crypto.percentChange >= 0 ? MyColors.green : MyColors.red,
                ),
                const SizedBox(width: 5),
                Text(
                  '\$ ${crypto.percentChange.toStringAsFixed(3)} %',
                  style: TextStyle(
                    fontFamily: 'pj-bold',
                    fontSize: 12,
                    color: crypto.percentChange >= 0
                        ? MyColors.green
                        : MyColors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
