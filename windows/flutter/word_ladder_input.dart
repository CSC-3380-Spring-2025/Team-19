import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Code for handling keyboard input for the Word Ladder game.
// This implementation supports both physical keyboard input and will be modified later to support an on-screen keyboard.
// Due to our unfamiliarity with Dart, I have added extensive comments to the code to make it easier to understand/modify in the future.

// Stateful widget to handle user input for the Word Ladder game
class WordLadderInput extends StatefulWidget {
  final int wordLength; // The required length of the word input
  final Function(String) onWordEntered; // Callback for when a valid word is entered
  final bool Function(String) isValidWord; // Function to validate if the input word is correct

  // Constructor for WordLadderInput
  const WordLadderInput({
    required this.wordLength,
    required this.onWordEntered,
    required this.isValidWord,
    super.key,
  });

  @override
  WordLadderInputState createState() => WordLadderInputState(); // Connects the widget to the state class (needed for user interaction, such as keyboard inputs)
}

// Created to allow the stateful widget that has user input to change with the input (normally widgets in Flutter have to be constant)
class WordLadderInputState extends State<WordLadderInput> {
  late FocusNode _focusNode; // Keeps track of input focus
  List<String> currentInput = []; // Stores the current word input by the user as a list of characters for easier manipulation

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(); // Initializes focus node for managing keyboard input
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Disposes of focus node to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(), // Requests focus when the user taps on this widget, ensuring keyboard input is captured where the user's input is actually placed
      child: KeyboardListener(
        focusNode: _focusNode, // Ensures the widget can capture keyboard events
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) { // Checks if a key is pressed down
            final keyLabel = event.logicalKey.keyLabel;

            // If the key is a single letter (A-Z or a-z), convert it to uppercase and add it to input
            if (keyLabel.length == 1 && keyLabel.contains(RegExp(r'[a-zA-Z]'))) {
              onKeyPressed(keyLabel.toUpperCase());
            }
            // If backspace is pressed, delete the last character
            else if (event.logicalKey == LogicalKeyboardKey.backspace) {
              onDelete();
            }
            // If enter is pressed, attempt to submit the word
            else if (event.logicalKey == LogicalKeyboardKey.enter) {
              onEnter();
            }
          }
        },
        child: const SizedBox.shrink(), // Placeholder for integration with on-screen keyboard UI (will require modification later)
      ),
    );
  }

  // Adds letters to the input
  void onKeyPressed(String letter) {
    if (currentInput.length < widget.wordLength) { // Ensure input does not exceed required length
      setState(() {
        currentInput.add(letter); // Add entered character to input list
      });
    }
  }

  // Deletes the last character in user input
  void onDelete() {
    if (currentInput.isNotEmpty) { // Ensure there's a character to delete
      setState(() {
        currentInput.removeLast(); // Removes the last letter from the list
      });
    }
  }

  // Submits the word the user entered
  void onEnter() {
    if (isEnterEnabled()) { // Check if the entered word is valid
      widget.onWordEntered(currentInput.join()); // Convert list to a string and notify the game of the entered word
      setState(() {
        currentInput.clear(); // Clear input for the next word
      });
    }
  }

  // Determines if the enter button should be enabled
  bool isEnterEnabled() {
    return currentInput.length == widget.wordLength && widget.isValidWord(currentInput.join());
  }
}