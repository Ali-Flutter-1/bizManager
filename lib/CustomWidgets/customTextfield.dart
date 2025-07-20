import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final bool isPassword;
  final double width;
  final double height;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int? maxLength;

  const CustomTextField({
    super.key,
    this.labelText,
    required this.hintText,
    this.isPassword = false,
    this.width = 300,
    this.height = 60,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          suffixIcon: widget.isPassword
              ? Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          )
              : null,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        style: const TextStyle(fontSize: 16, fontFamily: 'Font1'),
      ),
    );
  }
}
