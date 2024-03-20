import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pica/shared/theme.dart';

class OutlineFormField extends StatelessWidget {
  final String title;
  final String placeholderText;
  final bool numberOnly;
  final TextEditingController controller;

  const OutlineFormField({
    super.key,
    this.title = '',
    required this.placeholderText,
    this.numberOnly = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFF808080),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFF808080),
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != ''
              ? Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      title,
                      style: poppins.copyWith(
                          fontWeight: semiBold, color: const Color(0xFF186968)),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: 38,
            child: TextFormField(
              controller: controller,
              keyboardType: numberOnly ? TextInputType.number : null,
              style: poppins.copyWith(
                  fontSize: 12, color: const Color(0xFF232323)),
              decoration: InputDecoration(
                hintText: placeholderText,
                hintStyle: poppins.copyWith(
                    fontSize: 12, color: const Color(0xFFB1B1B1)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextReadOnly extends StatelessWidget {
  final String title;
  final String value;

  const TextReadOnly({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: poppins.copyWith(
              fontWeight: semiBold, color: const Color(0xFF186968)),
        ),
        Text(
          value,
          style: poppins.copyWith(fontSize: 12, color: const Color(0xFF232323)),
        ),
      ],
    );
  }
}

// Form Dropdown
class CustomFormDropdownProfil extends StatefulWidget {
  final String title;
  final List<String> listItems;
  final TextEditingController controller;
  const CustomFormDropdownProfil(
      {super.key,
      required this.title,
      required this.listItems,
      required this.controller});

  @override
  State<CustomFormDropdownProfil> createState() =>
      _CustomFormDropdownProfilState();
}

class _CustomFormDropdownProfilState extends State<CustomFormDropdownProfil> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Text(
          widget.title,
          style: poppins.copyWith(fontWeight: semiBold, color: neutral600),
        ),
        const SizedBox(
          height: 8,
        ),
        DropdownButton2<String>(
          underline: Container(),
          isExpanded: true,
          iconStyleData: const IconStyleData(icon: Icon(Icons.arrow_drop_down)),
          hint: Text(
            'Pilih role',
            style: poppins.copyWith(
                fontWeight: medium, fontSize: 14, color: neutral200),
          ),
          items: widget.listItems
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: poppins.copyWith(
                          fontWeight: medium, fontSize: 14, color: neutral600),
                    ),
                  ))
              .toList(),
          menuItemStyleData: const MenuItemStyleData(height: 35),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
              widget.controller.text = value;
            });
          },
          buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40, //Tinggi Form
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: neutral200,
                  ),
                  borderRadius: BorderRadius.circular(4.25))),
          dropdownStyleData: const DropdownStyleData(
              maxHeight: 350, //Tinggi Pop Up Dropdown
              decoration: BoxDecoration(
                color: Color(0xFFF2F4F7),
                boxShadow: [],
              )),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              widget.controller.clear();
            }
          },
        ),
      ],
    );
  }
}
