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
  bool isShiftPressed = false; // Flag for shift button (uppercase/lowercase)

  final List<List<String>> keyboardRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  ];

  final List<List<String>> specialCharRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
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

  void toggleShift() {
    setState(() {
      isShiftPressed = !isShiftPressed;
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
              SizedBox(
                height: widget.keyboardHeight * 0.13,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.language_rounded),
                      color: widget.textColor,
                      iconSize: widget.keyboardHeight * 0.06,
                      onPressed: () {
                        setState(() {
                          isSpecialPressed = !isSpecialPressed;
                        });
                      },
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.backspace_rounded),
                      color: widget.textColor,
                      iconSize: widget.keyboardHeight * 0.06,
                      onPressed: deleteLastChar,
                    ),
                  ],
                ),
              ),

              // Main keyboard layout (numbers and letters)
              if (!isSpecialPressed) ...[
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
                              String buttonKey = isShiftPressed
                                  ? key.toUpperCase()
                                  : key.toLowerCase();
                              inputValue += buttonKey;
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
              ],
            ],
          ),
        ),
        // Shift button and space button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: toggleShift,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(widget.keybordButtonColor),
                padding: MaterialStateProperty.all(EdgeInsets.all(10)),
              ),
              child: Icon(
                Icons.arrow_circle_up_outlined,
                color: widget.textColor,
                size: widget.keyboardHeight * 0.05,
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                inputValue += ' ';
                widget.onChange(inputValue);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(widget.keybordButtonColor),
                padding: MaterialStateProperty.all(EdgeInsets.all(10)),
              ),
              child: Text(
                'Space',
                style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.keyboardHeight * 0.05),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
