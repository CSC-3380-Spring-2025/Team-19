#Code for the Wheel of Fortune Game. Will need to make adjustments as the project is continuously developed,
#such as connecting some functions to the frontend interactions.

from typing import List, Any  #Allows for the type hinting of certain arrays/lists

fortune_answer: str = "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG" #The answer to the puzzle, for testing
fortune_category: str = "PANGRAM"

#Function for converting the sentence into a blank sentence to be filled in
#sentence: The sentence the user is trying to find
#return: A list representing a list of blank spaces, matching the structure of sentence
def create_blank(sentence: str) -> list[str]:
    letter: int = 0 #Used for going from letter to letter in the answer sentence
    sentence_fill: list[str] = list(sentence) #sentence broken into a list of letters (Python doesn't have char)
    while letter <= len(sentence_fill)-1: #Loop through sentence_fill, replacing the letters with " " or "_"
        if sentence_fill[letter] != " " and sentence_fill[letter] != "'":
            sentence_fill[letter] = "_"
        letter += 1
    return sentence_fill

#Function for determining the action the user takes. Actual input will be from buttons in the frontend UI,
#which will need to connect to this.
#Retrun: The number representing what the user is doing
def user_action() -> int:
    input_type = input("Do you want to guess a letter or the sentence? ") #Done for testing, remove once ready
    if input_type == "1": #1 is the user selecting the button to guess a letter
        return 1
    elif input_type == "2": #2 is the user selecting the button to guess the sentence
        return 2
    else:
        print("Error with user action: Unknown action") #Once game is developed, this should be impossible to trigger.
        return 0

#Function for the user attempting to guess the sentence.
#sentence: The sentence the user is trying to find.
#return: True if the user found the sentence, False if the user is incorrect.
def sentence_attempt(sentence: str) -> bool:
    user_input: str = input("Please enter a sentence: ") #User's attempt to solve the sentence
    if user_input.upper() == sentence.upper():
        return True
    else:
        return False

#Function for the user attempting to guess a letter in the sentence.
#sentence: The sentence the user is trying to find.
#blank_sentence: The list representation of the blank sentence
#Return: The partially filled in blank sentence
def letter_attempt(sentence: str, blank_sentence: list[str]) -> list[str]:
    while True:
        user_input: str = input("Please enter a letter: ") #User's guess at a letter
        if len(user_input) == 1:
            break
        else:
            print("Please enter only a single letter")
    if user_input.upper() in sentence.upper() and not (user_input.upper() in blank_sentence):
        sentence_fill: list[str] = list(sentence)
        place: int = 0
        while place < len(sentence_fill):
            if sentence_fill[place] == user_input.upper():
                blank_sentence[place] = user_input.upper()
            place += 1
    return blank_sentence

#Function for calculating the user's score
#letter: The nuber of letters the user needed to guess
#attempts: The number of failed sentence guesses
#Return: The score
def calc_score(letters: int, attempts: int) -> int:
    score: int = 10000
    score -= letters*50
    score -= attempts*100
    if score < 0:
        score -= score
    return score

#Function for the user to actually play the game.
#sentence: The sentence the user is trying to find.
#Return: The number of letters needed to be guessed, the number of failed sentence attempts, and their score.
def play_game(sentence:str, category:str) -> tuple[int, int, int]:
    game_going: bool = True #Keeps track of if the user has won or not
    letters_attempted: int = 0 #Number of letters the user tried/correctly guessed
    incorrect_attempts: int = 0 #Number of incorrect attempts at guessing the sentence
    blank_sentence: list[str] = create_blank(sentence)
    print(category.upper())
    print("".join(blank_sentence))
    while game_going:
        action: int = user_action()
        if action == 1:
            blank_sentence = letter_attempt(sentence, blank_sentence)
            letters_attempted += 1
            print("".join(blank_sentence))
        elif action == 2:
            if sentence_attempt(sentence):
                game_going = False
                print(sentence)
                print("You got it!")
            else:
                print("".join(blank_sentence))
                incorrect_attempts += 1
    return calc_score(letters_attempted, incorrect_attempts), letters_attempted, incorrect_attempts

play_game(fortune_answer, fortune_category) #Testing the play_game method and all associated methods
