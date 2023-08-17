import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class SearchField extends StatelessWidget {
  SearchField({
    this.onSearch,
    this.hintText,
    this.controller,
    Key? key,
  }) : super(key: key);

  TextEditingController? controller = TextEditingController();
  final Function(String value)? onSearch;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(EvaIcons.search),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: .1),
        ),
        hintText: hintText ?? "Search by...",
      ),
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        if (onSearch != null) onSearch!(controller?.text ?? "");
      },
      onChanged: (value) {
        onSearch!(value);
      },
      textInputAction: TextInputAction.search,
      style: TextStyle(color: kFontColorPallets[1]),
    );
  }
}
