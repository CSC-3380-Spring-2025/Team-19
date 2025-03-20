#Code for the timer that will run for the games

from typing import Optional
import time
import threading

class GameTimer:
    # Initializes the game's timer
    def __init__(self) -> None:
        self.seconds: int = 0  # The time in seconds
        self.running: bool = False  # Flag to track if the timer is running
        self.thread: Optional[threading.Thread] = None  # The thread used for the timer
        self.lock = threading.Lock()  # Used to ensure thread safety when updating seconds

    # Starts the timer in a new thread
    def start(self) -> None:
        if not self.running:
            self.running = True
            self.thread = threading.Thread(target=self.run)  # Starts a new thread to run the timer
            self.thread.start()

    # Counts until stopped, updates the timer every second
    def run(self) -> None:
        while self.running:
            with self.lock:
                self.seconds += 1  # Increment the timer every second
            print(self.format_time())  # Display the current time in mm:ss format
            time.sleep(1)  # Sleep for 1 second before updating again

    # Stops the timer and prints the final time
    def stop(self) -> None:
        self.running = False
        if self.thread:
            self.thread.join()  # Wait for the thread to finish before proceeding
        with self.lock:
            print(f"Final Time: {self.format_time()}")  # Display the final time when the game ends

    # Pauses the timer (if needed)
    def pause(self) -> None:
        """Pauses the timer."""
        self.running = False

    # Resumes the timer from where it left off (if needed)
    def resume(self) -> None:
        """Resumes the timer."""
        if not self.running:
            self.running = True
            self.thread = threading.Thread(target=self.run)  # Create a new thread to resume the timer
            self.thread.start()

    # Formats the time in mm:ss format
    def format_time(self) -> str:
        minutes = self.seconds // 60  # Calculate minutes
        seconds = self.seconds % 60  # Calculate remaining seconds
        return f"{minutes:02}:{seconds:02}"  # Return time in mm:ss format

# Test the timer and all of its functions (make sure to delete calls when you're done)
def test_timer():
    game_timer = GameTimer()
    game_timer.start()
    time.sleep(5)
    print("\nTimer paused after 5 seconds.")
    game_timer.pause()
    time.sleep(2)
    print("\nTimer resumed after 2 seconds.")
    game_timer.resume()
    time.sleep(5)
    game_timer.stop()

