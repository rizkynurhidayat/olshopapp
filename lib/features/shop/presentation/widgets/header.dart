import 'package:flutter/material.dart';

import 'package:olshopapp/core/themes/theme.dart';

Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Choose your skincare!', style: TextStyle(color: AppColors.secondaryText, fontSize: 12)),
            SizedBox(height: 4),
            Text('Hi, Jelly 💄', style: TextStyle(color: AppColors.primaryText, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const CircleAvatar(
          backgroundColor: AppColors.surfaceWhite,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Ganti dengan asset lokal
        ),
      ],
    );
  }