import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status.toUpperCase()) {
      case 'PENDING':
        color = const Color(0xFFFFA000); // Amber
        text = 'Chờ duyệt';
        break;
      case 'SHIPPING':
        color = const Color(0xFF1E88E5); // Blue
        text = 'Đang giao';
        break;
      case 'COMPLETED':
        color = const Color(0xFF43A047); // Green
        text = 'Đã giao';
        break;
      case 'CANCELLED':
        color = const Color(0xFFE53935); // Red
        text = 'Đã hủy';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
