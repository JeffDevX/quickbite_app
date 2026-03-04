import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FoodWidget extends StatelessWidget {
  final String foodImage;
  final String foodName;
  final double foodPrice;
  const FoodWidget({
    super.key,
    required this.foodImage,
    required this.foodName,
    required this.foodPrice,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: foodImage,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0.10,
                    right: 0.10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor('FF4400'),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${foodPrice.toDouble().toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor('FF4400'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
