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
  final int? maxLines;
  final bool? obscureText;
  final TextInputType? textInputType;
  final String? labelText, hintText;
  final String? Function(String?)? onSubmit, onChanged, validator;
  final TextEditingController? controller;
  final IconButton? visibilityIcon;
  const TextInputWidget(
      {this.controller,
      this.maxLines,
      this.visibilityIcon,
      this.hintText,
      this.labelText,
      this.onChanged,
      this.onSubmit,
      this.obscureText,
      this.textInputType,
      this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText == null ? "" : labelText!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        TextFormField(
          keyboardType: textInputType ?? TextInputType.text,
          obscureText: obscureText ?? false,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            suffixIcon: visibilityIcon ?? const SizedBox.shrink(),
            hintText: hintText ?? "",
            hintStyle: TextStyle(
              color: Colors.black45,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.orange,
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
      ],
    );
  }
}

class TextInputWidgetWithoutLabel extends StatelessWidget {
  final int? maxLines;
  final bool? obscureText;
  final TextInputType? textInputType;
  final String? hintText;
  final String? Function(String?)? onSubmit, onChanged, validator;
  final TextEditingController? controller;
  final IconButton? visibilityIcon;
  const TextInputWidgetWithoutLabel(
      {this.controller,
      this.maxLines,
      this.visibilityIcon,
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
      minLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        filled: true,
        fillColor: Colors.grey,
        suffixIcon: visibilityIcon ?? const SizedBox.shrink(),
        hintText: hintText ?? "",
        hintStyle: TextStyle(
          color: Colors.black45,
        ),
        border: OutlineInputBorder(
          gapPadding: 2,
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 2,
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.orange,
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
    );
  }
}

class TextInputWidgetWithoutLabelForDialog extends StatelessWidget {
  final int? maxLines;
  final bool? obscureText;
  final TextInputType? textInputType;
  final String? hintText;
  final String? Function(String?)? onSubmit, onChanged, validator;
  final TextEditingController? controller;
  final IconButton? visibilityIcon;
  const TextInputWidgetWithoutLabelForDialog(
      {this.controller,
      this.maxLines,
      this.visibilityIcon,
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
        minLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: visibilityIcon ?? const SizedBox.shrink(),
          hintText: hintText ?? "",
          hintStyle: TextStyle(
            color: Colors.black45,
          ),
          border: OutlineInputBorder(
            gapPadding: 2,
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 2,
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.orange,
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
