#Code for the Word Ladder Game. Will need to make adjustments as the project is continuously developed,
#such as connecting some functions to the frontend interactions.

from typing import List #Allows for the type hinting of certain arrays/lists

word_answers: list[str] = ["DOG", "FOOD", "BOWL", "PIN", "KNIT"] #The answer to the puzzle. Used for testing.

#Function for hiding the middle words for the puzzle
def hide_words(word_list: list[str]) -> list[str]:
    word: int = 0
    new_list: list[str] = word_list.copy()
    while word < len(word_list)-1:
        blank_word: list[str] = list(word_list[word+1])
        index: int = 1
        while index <= len(blank_word) - 1:
            blank_word[index] = "_"
            index += 1
            new_list[word+1] = "".join(blank_word)
        word += 1
    return new_list

#Function for printing the word ladder w/ the hidden words
def print_ladder(word_list_with_blanks: list[str]) -> None:
    word: int = 0
    while word < len(word_list_with_blanks):
        print(word_list_with_blanks[word])
        word += 1

#Function for the player guessing the word
def guess_word(word_list: list[str], word_placement: int) -> bool:
    while True:
        user_input: str = input("Enter a word: ")  # User's guess at the next word
        if len(user_input) == len(word_list[word_placement]):
            break
        else:
            print("Please enter a word of the correct length")
    if user_input.upper() == word_list[word_placement].upper():
        return True
    else:
        return False

#Function for playing the game
def play_game(word_list: list[str]) -> tuple[int, int]:
    words_to_print: list[str] = hide_words(word_list)
    print_ladder(words_to_print)
    words_guessed: int = 0
    word_to_guess: int = 1
    incorrect_guesses: int = 0
    while words_guessed < len(word_list)-1:
        if guess_word(word_list, word_to_guess):
            words_to_print[word_to_guess] = word_list[word_to_guess]
            word_to_guess += 1
            words_guessed += 1
            print("You got it right!")
            print_ladder(words_to_print)
        else:
            incorrect_guesses += 1
            print("You go it wrong!")
            print_ladder(words_to_print)
    print("You win! Congratulations!")
    return 10000-(100*incorrect_guesses), incorrect_guesses

play_game(word_answers) #Testing the play_game method and all associated methods