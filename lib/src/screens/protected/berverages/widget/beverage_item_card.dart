import 'package:flutter/material.dart';

class BeverageItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String number;
  final String keepingDate;
  final String expiryDate;
  final String buttonText;
  final VoidCallback onTap;

  const BeverageItemCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.number,
    required this.keepingDate,
    required this.expiryDate,
    this.buttonText = "Add",
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF2E2D2C),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 Left side (image + texts)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFFFFAE5),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                      ),
                    ),
                    Text(
                      "$number - $keepingDate",
                      style: const TextStyle(
                        color: Color(0xFFFFFAE5),
                        fontSize: 12,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                    Text(
                      "Exp - $expiryDate",
                      style: const TextStyle(
                        color: Color(0xFF8E7A72),
                        fontSize: 12,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // 🔹 Right side (button)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(6.96),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.50, -0.00),
                    end: Alignment(0.50, 1.00),
                    colors: [Color(0xFFF7D99A), Color(0xFFC3A266)],
                  ),
                  borderRadius: BorderRadius.circular(6.96),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 8,
                  ),
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 9.70,
                      fontFamily: 'Instrument Sans',
                      fontWeight: FontWeight.w700,
                      height: 1.71,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
