import json
from typing import Dict

# File to store tutorial status
# Possibly will be moved to a database, but just using local files right now for ease
FILE_PATH = "../../PythonProject2/tutorial_status.json"


def load_status() -> Dict[int, Dict[str, bool]]:
    """Loads the tutorial status from a JSON file"""
    try:
        with open(FILE_PATH, "r") as file:
            return json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        return {}


def save_status(status: Dict[int, Dict[str, bool]]) -> None:
    """Saves the tutorial status to a JSON file"""
    with open(FILE_PATH, "w") as file:
        json.dump(status, file, indent=4)


def has_seen_tutorial(user_id: int, game: str) -> bool:
    """Checks if the user has seen the tutorial for the given game"""
    status = load_status()
    return status.get(user_id, {}).get(game, False)


def mark_tutorial_seen(user_id: int, game: str) -> None:
    """Marks the tutorial as seen for the user"""
    status = load_status()
    if user_id not in status:
        status[user_id] = {}
    status[user_id][game] = True
    save_status(status)


def show_tutorial(user_id: int, game: str) -> None:
    """Displays the tutorial for the game"""
    #All descriptions can be altered later, just a baseline for now
    tutorial_text: Dict[str, str] = {
        #WIP name
        "Wheel of Fortune": (
            "Welcome to Wheel of Fortune!\n"
            "You will be given a blank sentence with missing letters.\n"
            "A category hint will help you narrow down the answer.\n"
            "You have two options on your turn:\n"
            "1. Guess a letter - If the letter is in the sentence, it will be revealed.\n"
            "2. Guess the full sentence - If correct, you win!\n"
            "Your score starts at a base value and decreases with each guessed letter and incorrect sentence attempt.\n"
            "Once the puzzle is solved, your score will also take time into account.\n"
            "Try to solve the puzzle with the fewest guesses and as quickly as possible!"
        ),
        "Word Ladder": (
            "Welcome to Word Ladder!\n"
            "You will be given a starting word and a hint for the next word, which begins with the first letter provided.\n"
            "Each word connects to the next in a meaningful way, forming a continuous chain.\n"
            "For example: 'dog' → 'F___' (where the answer could be 'food').\n"
            "Your goal is to correctly complete the sequence as efficiently as possible.\n"
            "Think of words that logically follow the previous one and match the given hint!"
        ),
        "Connections": (
            "Welcome to Connections!\n"
            "You will be given a set of 16 words.\n"
            "Your goal is to find four groups of four words that share a common theme.\n"
            "Select four words that you think belong together and submit your guess.\n"
            "If correct, the words will be grouped together. If incorrect, you will receive a 'one away' hint if only one word is incorrect.\n"
            "You have a total of four incorrect attempts before the game ends.\n"
            "Think critically about the relationships between words and find all the correct groups!"
        )
    }
    print(tutorial_text.get(game, "Invalid game."))
    mark_tutorial_seen(user_id, game)

#Command line testing, not incredibly practical error wise at the moment. Once done testing, make sure to delete calls.
#As of right now, testing the function will result in an error once the game info is printed, as it is not connected to any files.
def test_how_to_play() -> None:
    if __name__ == "__main__":
        user_id: int = int(input("Enter your user ID: "))
        game: str = input("Enter the game (Wheel of Fortune/Word Ladder/Connections): ").strip()

        action: str = input("Type 'play' to start the game or 'help' for instructions: ").strip().lower()
        if action in ["play", "help"]:
            show_tutorial(user_id, game)
        else:
            print("Invalid input.")
