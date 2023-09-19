import 'package:flutter/material.dart';

class Searchtext extends StatelessWidget {
  const Searchtext({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TextInputWidget extends StatelessWidget {
  final String? labelText, hintText;
  final Function? onSubmit, onChanged;
  final TextEditingController? controller;
  const TextInputWidget(
      {this.controller,
      this.hintText,
      this.labelText,
      this.onChanged,
      this.onSubmit,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText == null ? "label" : labelText!,
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
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            hintText: hintText ?? "hint",
            hintStyle: TextStyle(
              color: Colors.black45,
            ),
          ),
          onFieldSubmitted: onSubmit == null ? (value) {} : onSubmit!(),
          onChanged: onChanged == null ? (value) {} : onChanged!(),
        ),
      ],
    );
  }
}
