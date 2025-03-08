#Code for the Connections game. Will need to make adjustments as the project is continuously developed,
#such as connecting some functions to the frontend interactions.
import random
from typing import List, Dict, Tuple

#Sample Categories
categories = {
    "Colors": ["Red", "Blue", "Green", "Yellow"],
    "Fruits": ["Apple", "Banana", "Grape", "Orange"],
    "Animals": ["Dog", "Cat", "Horse", "Elephant"],
    "Countries": ["USA", "Canada", "France", "Germany"]
}

def display_grid(words: List[str], attempts_left: int) -> None:
    """Creates the display grid"""
    print(f"\nCurrent Grid (Attempts left: {attempts_left}):")
    for i in range(0, 16, 4):
        row = "  ".join(words[i:i + 4])
        print(row)
    print()


def check_selection(selection: List[str], words: List[str], correct_sets: set, found_categories: set) -> Tuple[
    bool, str, List[str]]:
    """Check if all words are in the grid"""
    if not all(word in words for word in selection):
        return False, "Invalid selection! One or more words are not in the grid. Try again.", words

    selection_set = frozenset(selection)

    # Check if the selection is correct
    if selection_set in correct_sets:
        print("Correct! You've found a category.")
        words = [word for word in words if word not in selection_set]  # Remove selected words
        words = list(selection) + words  # Add selected words to the top
        random.shuffle(words[4:])  # Shuffle the remaining words to keep randomness
        found_categories.add(tuple(selection))  # Add found category
        return True, "Correct!", words

    # Check if selection is "one away" (3 out of 4 correct)
    for correct_set in correct_sets:
        if len(selection_set & correct_set) == 3:
            return False, "One away!", words

    return False, "Incorrect. Try again.", words


def play_game(categories: Dict[str, List[str]]):


    # Flatten the categories and shuffle the words
    words = [word for group in categories.values() for word in group]
    random.shuffle(words)

    # Create correct sets
    correct_sets = {frozenset(words) for words in categories.values()}
    found_categories = set()

    attempts = 0
    max_attempts = 4

    display_grid(words, max_attempts - attempts)

    while attempts < max_attempts:
        user_selection = input("Enter four words separated by commas: ").split(", ")

        if len(user_selection) != 4:
            print("Please enter exactly four words.")
            continue

        correct, message, words = check_selection(user_selection, words, correct_sets, found_categories)
        print(message)

        # Only deduct a life for incorrect or "one away" answers
        if correct:
            # No life deducted for correct answers
            attempts += 0
        elif message != "Invalid selection! One or more words are not in the grid. Try again.":
            # Deduct a life for wrong or "one away" guesses
            attempts += 1

        display_grid(words, max_attempts - attempts)

        if len(found_categories) == len(categories):
            print("Congratulations! You've found all categories!")
            break

        if attempts >= max_attempts:
            print("Game over! You've used all attempts.")
            display_grid(words, max_attempts - attempts)
            break

play_game(categories) #Tests the play_game method and all other functions with sample categories
