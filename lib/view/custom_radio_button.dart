import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CustomRadioButton({super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Ink(
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueGrey),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected?const Color(0xff00B8CD):Colors.blueGrey,
                  ),
                  const SizedBox(width: 15),
                  Text(label, style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
