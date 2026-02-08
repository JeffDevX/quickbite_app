import 'package:flutter/material.dart';

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
    return Card(
      child: Column(
        children: [
          Image(image: AssetImage(foodImage)),
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
                      '\$${foodPrice.toString()}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
