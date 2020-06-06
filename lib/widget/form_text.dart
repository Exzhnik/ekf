import 'package:flutter/material.dart';

class FormText extends StatelessWidget {
  FormText(this.textEditingController, this.text, this.input, {Key key})
      : super(key: key);

  final TextEditingController textEditingController;
  final TextInputType input;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: TextFormField(
        decoration: InputDecoration(labelText: text),
        textAlign: TextAlign.center,
        controller: textEditingController,
        keyboardType: input,
      ),
    );
  }
}
