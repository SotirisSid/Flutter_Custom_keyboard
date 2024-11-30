import 'package:flutter/material.dart';
import 'ck_controller.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({
    super.key,
    required this.backgroundColor,
    required this.bottomPaddingColor,
    required this.bottomPaddingHeight,
    required this.keyboardHeight,
    required this.keyboardWidth,
    required this.onChange,
    required this.onTapColor,
    required this.textColor,
    required this.keybordButtonColor,
    required this.elevation,
    required this.controller,
  });

  final double keyboardHeight, keyboardWidth;
  final Function(String) onChange;
  final Color backgroundColor;
  final Color onTapColor;
  final Color textColor;
  final Color bottomPaddingColor;
  final double bottomPaddingHeight;
  final Color keybordButtonColor;
  final WidgetStateProperty<double> elevation;
  final CKController controller;

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  late String inputValue = '';
  bool isSpecialPressed =
      false; // Flag to toggle between normal and special character keyboards

  // Defining the layout for the keyboard rows (numbers and characters)
  final List<List<String>> keyboardRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  ];

  // Special characters layout
  final List<List<String>> specialCharRows = [
    ['+', '-', '=', '/', '!', '@', '#', r'$', '%'],
    ['^', '&', '*', '(', ')', '_', ':', ';', '"'],
    ['<', '>', '?', '.', ',', '`', '~'],
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        inputValue = widget.controller.initialValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: widget.keyboardHeight,
          width: widget.keyboardWidth,
          color: widget.backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // The "Special Characters" button to toggle between keyboards
              SizedBox(
                height: widget.keyboardHeight * 0.13,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSpecialPressed = !isSpecialPressed;
                        });
                      },
                      style: ButtonStyle(
                        elevation: widget.elevation,
                        backgroundColor: WidgetStateProperty.all<Color>(
                          widget.keybordButtonColor,
                        ),
                        overlayColor: WidgetStateProperty.all<Color>(
                          widget.onTapColor,
                        ),
                      ),
                      child: Text(
                        'Special Characters',
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: widget.keyboardHeight * 0.06,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // The main keyboard (number and letters)
              if (!isSpecialPressed) ...[
                // Normal key rows
                ...keyboardRows.map((row) {
                  return SizedBox(
                    height: widget.keyboardHeight * 0.13,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: row.map((key) {
                        return SizedBox(
                          width: widget.keyboardWidth * 0.08,
                          child: TextButton(
                            onPressed: () {
                              inputValue += key;
                              widget.onChange(inputValue);
                            },
                            style: ButtonStyle(
                              elevation: widget.elevation,
                              backgroundColor: WidgetStateProperty.all<Color>(
                                widget.keybordButtonColor,
                              ),
                              overlayColor: WidgetStateProperty.all<Color>(
                                widget.onTapColor,
                              ),
                            ),
                            child: Text(
                              key,
                              style: TextStyle(
                                color: widget.textColor,
                                fontSize: widget.keyboardHeight * 0.06,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ] else ...[
                // Special character key rows
                ...specialCharRows.map((row) {
                  return SizedBox(
                    height: widget.keyboardHeight * 0.17,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: row.map((key) {
                        return SizedBox(
                          width: widget.keyboardWidth * 0.08,
                          child: TextButton(
                            onPressed: () {
                              inputValue += key;
                              widget.onChange(inputValue);
                            },
                            style: ButtonStyle(
                              elevation: widget.elevation,
                              backgroundColor: WidgetStateProperty.all<Color>(
                                widget.keybordButtonColor,
                              ),
                              overlayColor: WidgetStateProperty.all<Color>(
                                widget.onTapColor,
                              ),
                            ),
                            child: Text(
                              key,
                              style: TextStyle(
                                color: widget.textColor,
                                fontSize: widget.keyboardHeight * 0.08,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
