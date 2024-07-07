import 'package:flutter/material.dart';
//import 'package:get/get.dart';

class Searchtext extends StatelessWidget {
  const Searchtext({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TextInputWidget extends StatelessWidget {
  final FocusNode? focusNode;
  final Color? labelColor;
  final double? fontSize;
  final int? maxLines;
  final int? minLines;
  final bool? obscureText;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? textInputType;
  final String? labelText, hintText, initialValue;
  final void Function(String?)? onSubmit, onChanged;
  final String? Function(String?)? validator; // Corrected declaration
  final TextEditingController? controller;
  final IconButton? visibilityIcon;
  const TextInputWidget({
    this.labelColor,
    this.focusNode,
    this.controller,
    this.autovalidateMode,
    this.fontSize,
    this.initialValue,
    this.minLines,
    this.maxLines,
    this.visibilityIcon,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.onSubmit,
    this.obscureText,
    this.textInputType,
    this.validator,
    super.key, // Corrected super call
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText == null ? "" : labelText!,
          style: TextStyle(
            color: labelColor ?? const Color(0xFF673AB7),
            fontSize: fontSize ?? 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextFormField(
          focusNode: focusNode,
          style: const TextStyle(
            fontFamily: "Lato",
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          initialValue: initialValue ?? "",
          keyboardType: textInputType ?? TextInputType.text,
          obscureText: obscureText ?? false,
          maxLines: maxLines ?? 1,
          minLines: minLines,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          decoration: InputDecoration(
            errorMaxLines: 3,
            errorStyle: TextStyle(
              fontSize: 11,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
              color: Colors.red[300],
            ),
            // labelStyle: TextStyle(
            //     fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            suffixIcon: visibilityIcon ?? const SizedBox.shrink(),
            hintText: hintText ?? "",
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.34),
              fontSize: 15,
              fontFamily: "Raleway",
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFF5F5F5),
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFF5F5F5),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF673AB7),
                width: 1.5,
              ),
            ),
          ),
          onFieldSubmitted: onSubmit == null ? (value) {} : onSubmit!,
          onChanged: onChanged == null ? (value) {} : onChanged!,
          validator: validator, // Removed unnecessary null check
        ),
      ],
    );
  }
}

class TextInputWidgetWithoutLabel extends StatelessWidget {
  final int? maxLines;
  final int? minLines;
  final bool? obscureText;
  final InputBorder? enabledBorder, border;
  final TextInputType? textInputType;
  final AutovalidateMode? autovalidateMode;
  final String? initialValue;
  final String? hintText;
  final String? Function(String?)? onSubmit, onChanged, validator;
  final TextEditingController? controller;
  final IconButton? visibilityIcon;
  const TextInputWidgetWithoutLabel(
      {this.controller,
      this.minLines,
      this.initialValue,
      this.border,
      this.enabledBorder,
      this.maxLines,
      this.visibilityIcon,
      this.autovalidateMode,
      this.hintText,
      this.onChanged,
      this.onSubmit,
      this.obscureText,
      this.textInputType,
      this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      initialValue: initialValue,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorStyle: TextStyle(
          fontSize: 11,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w400,
          color: Colors.red[300],
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        suffixIcon: visibilityIcon ?? const SizedBox.shrink(),
        hintText: hintText ?? "",
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.45),
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFF5F5F5),
                width: 1.5,
              ),
            ),
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFF5F5F5),
                width: 1.5,
              ),
            ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 4,
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF673AB7),
            width: 1.5,
          ),
        ),
      ),
      onFieldSubmitted: onSubmit == null ? (value) {} : onSubmit!,
      onChanged: onChanged == null ? (value) {} : onChanged!,
      validator: validator == null
          ? (value) {
              return null;
            }
          : validator!,
    );
  }
}

class TextInputWidgetWithoutLabelForDialog extends StatelessWidget {
  final int? maxLines;
  final bool? obscureText;
  final TextInputType? textInputType;
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final String? Function(String?)? onSubmit, onChanged, validator;
  final TextEditingController? controller;
  final dynamic initialValue;
  final IconButton? visibilityIcon;
  const TextInputWidgetWithoutLabelForDialog(
      {this.controller,
      this.maxLines,
      this.visibilityIcon,
      this.autovalidateMode,
      this.initialValue,
      this.hintText,
      this.onChanged,
      this.onSubmit,
      this.obscureText,
      this.textInputType,
      this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextFormField(
        keyboardType: textInputType ?? TextInputType.text,
        obscureText: obscureText ?? false,
        maxLines: maxLines ?? 1,
        initialValue: initialValue,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
        minLines: 1,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: visibilityIcon ?? const SizedBox.shrink(),
          hintText: hintText ?? "",
          hintStyle: const TextStyle(
            color: Colors.black45,
          ),
          border: OutlineInputBorder(
            gapPadding: 2,
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 2,
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blue.shade200,
              width: 2,
            ),
          ),
        ),
        onFieldSubmitted: onSubmit == null ? (value) {} : onSubmit!,
        onChanged: onChanged == null ? (value) {} : onChanged!,
        validator: validator == null
            ? (value) {
                return null;
              }
            : validator!,
      ),
    );
  }
}
