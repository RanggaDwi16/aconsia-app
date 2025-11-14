import 'package:flutter/material.dart';

Widget statusOperasi(String status) {
  Color statusColor;
  String statusText;

  switch (status.toLowerCase()) {
    case 'selesai':
      statusColor = Colors.green;
      statusText = 'Selesai';
      break;
    case 'dijadwalkan':
      statusColor = Colors.orange;
      statusText = 'Dijadwalkan';
      break;
    case 'batal':
      statusColor = Colors.red;
      statusText = 'Batal';
      break;
    default:
      statusColor = Colors.grey;
      statusText = 'Tidak Diketahui';
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: statusColor.withOpacity(0.1),
      border: Border.all(color: statusColor),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      statusText,
      style: TextStyle(
        color: statusColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
