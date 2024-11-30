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
  bool isSpecialPressed = false;
  bool isShiftPressed = false;

  final List<List<String>> keyboardRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  ];

  final List<List<String>> specialCharRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')'],
    ['-', '_', '=', '+', '[', ']', '{', '}', '|', '\\'],
    [';', ':', '\'', '"', ',', '.', '/', '?', '`', '~'],
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

  void toggleShift() {
    setState(() {
      isShiftPressed = !isShiftPressed;
    });
  }

  void toggleSpecial() {
    setState(() {
      isSpecialPressed = !isSpecialPressed;
    });
  }

  void deleteLastChar() {
    if (inputValue.isNotEmpty) {
      setState(() {
        inputValue = inputValue.substring(0, inputValue.length - 1);
        widget.onChange(inputValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rowHeight = widget.keyboardHeight / 5;
    final keyWidth = widget.keyboardWidth / 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: widget.keyboardHeight,
          width: widget.keyboardWidth,
          color: widget.backgroundColor,
          child: Column(
            children: [
              // Main keyboard layout
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var row
                        in (isSpecialPressed ? specialCharRows : keyboardRows))
                      SizedBox(
                        height: rowHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: row.map((key) {
                            return SizedBox(
                              width: keyWidth,
                              child: TextButton(
                                onPressed: () {
                                  String buttonKey = isShiftPressed
                                      ? key.toUpperCase()
                                      : key.toLowerCase();

                                  setState(() {
                                    inputValue += buttonKey;
                                    widget.onChange(inputValue);

                                    // Auto-unpress Shift after pressing a letter
                                    if (isShiftPressed) {
                                      isShiftPressed = false;
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  elevation: widget.elevation,
                                  backgroundColor: WidgetStateProperty.all(
                                      widget.keybordButtonColor),
                                  overlayColor: WidgetStateProperty.all(
                                      widget.onTapColor),
                                ),
                                child: Text(
                                  isShiftPressed ? key.toUpperCase() : key,
                                  style: TextStyle(
                                    color: widget.textColor,
                                    fontSize: rowHeight * 0.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              // Bottom row with shift, special, space, and backspace buttons
              SizedBox(
                height: rowHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Shift Button
                    ElevatedButton(
                      onPressed: toggleShift,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          isShiftPressed
                              ? Colors.blue
                              : widget.keybordButtonColor,
                        ),
                        padding:
                            WidgetStateProperty.all(const EdgeInsets.all(10)),
                      ),
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: widget.textColor,
                        size: rowHeight * 0.5,
                      ),
                    ),
                    // Special Characters Button
                    ElevatedButton(
                      onPressed: toggleSpecial,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(widget.keybordButtonColor),
                        padding:
                            WidgetStateProperty.all(const EdgeInsets.all(10)),
                      ),
                      child: Icon(
                        Icons.language_rounded,
                        color: widget.textColor,
                        size: rowHeight * 0.5,
                      ),
                    ),
                    // Space Bar
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            inputValue += ' ';
                            widget.onChange(inputValue);
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              widget.keybordButtonColor),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 10)),
                        ),
                        child: Text(
                          'Space',
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: rowHeight * 0.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Backspace Button
                    ElevatedButton(
                      onPressed: deleteLastChar,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(widget.keybordButtonColor),
                        padding:
                            WidgetStateProperty.all(const EdgeInsets.all(10)),
                      ),
                      child: Icon(
                        Icons.backspace_rounded,
                        color: widget.textColor,
                        size: rowHeight * 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
