import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Code for handling keyboard input for the Letter Quest game.
// This implementation supports both physical keyboard input and will be modified later to support an on-screen keyboard.
// Due to our unfamiliarity with Dart, extensive comments have been added to make it easier to understand/modify in the future.

// Stateful widget to handle user input for the Letter Quest game
class LetterQuestInput extends StatefulWidget {
  final String phrase; // The phrase to be guessed
  final Function(String) onGuess; // Callback for when a letter or full phrase is guessed
  final bool isGuessingLetter; // Determines if the user is guessing a single letter or solving the phrase
  
  // Constructor for LetterQuestInput
  const LetterQuestInput({
    required this.phrase,
    required this.onGuess,
    required this.isGuessingLetter,
    super.key,
  });

  @override
  LetterQuestInputState createState() => LetterQuestInputState(); // Connects the widget to the state class
}

// Created to allow the stateful widget that has user input to change with the input
class LetterQuestInputState extends State<LetterQuestInput> {
  late FocusNode _focusNode; // Keeps track of input focus
  Set<String> guessedLetters = {}; // Stores guessed letters to prevent duplicate guesses
  String currentAttempt = ""; // Stores the user's current phrase attempt

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
      onTap: () => _focusNode.requestFocus(), // Requests focus when the user taps on this widget
      child: KeyboardListener(
        focusNode: _focusNode, // Ensures the widget can capture keyboard events
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) { // Checks if a key is pressed down
            final keyLabel = event.logicalKey.keyLabel.toUpperCase();

            // If the user is guessing a single letter
            if (widget.isGuessingLetter) {
              if (keyLabel.length == 1 && keyLabel.contains(RegExp(r'[A-Z]'))) {
                onLetterGuess(keyLabel);
              }
            }
            // If the user is attempting to solve the phrase
            else {
              if (keyLabel.length == 1 && keyLabel.contains(RegExp(r'[A-Z ]'))) {
                onPhraseInput(keyLabel);
              }
              // If backspace is pressed, delete the last character of phrase input
              else if (event.logicalKey == LogicalKeyboardKey.backspace) {
                onDelete();
              }
              // If enter is pressed, attempt to submit the full phrase guess
              else if (event.logicalKey == LogicalKeyboardKey.enter) {
                onEnter();
              }
            }
          }
        },
        child: const SizedBox.shrink(), // Placeholder for integration with on-screen keyboard UI (will require modification later)
      ),
    );
  }

  // Handles guessing individual letters
  void onLetterGuess(String letter) {
    if (!guessedLetters.contains(letter)) { // Ensures letters are not guessed more than once
      setState(() {
        guessedLetters.add(letter); // Add guessed letter to the set
      });
      widget.onGuess(letter); // Notify the game of the guessed letter
    }
  }

  // Handles input when the user is solving the phrase
  void onPhraseInput(String letter) {
    setState(() {
      currentAttempt += letter; // Adds the letter to the current phrase input
    });
  }

  // Deletes the last character in the current phrase input
  void onDelete() {
    if (currentAttempt.isNotEmpty) { // Ensure there's a character to delete
      setState(() {
        currentAttempt = currentAttempt.substring(0, currentAttempt.length - 1); // Remove the last letter
      });
    }
  }

  // Submits the current phrase attempt
  void onEnter() {
    if (currentAttempt.isNotEmpty) { // Ensure input is not empty before submitting
      widget.onGuess(currentAttempt); // Notify the game of the full phrase guess
      setState(() {
        currentAttempt = ""; // Clear input for the next attempt
      });
    }
  }
}