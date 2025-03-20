from flask import Flask, request, jsonify, Response
import psycopg2
from psycopg2.extensions import connection, cursor
import bcrypt
from typing import List, Tuple, Dict, Any, Optional
from datetime import date, datetime, timedelta

app: Flask = Flask(__name__)

# Database connection
conn: connection = psycopg2.connect(
    host="localhost",
    dbname="postgres",
    user="postgres",
    password="1234",
    port=5432
)
cur: cursor = conn.cursor()


@app.route('/register', methods=['POST'])
def register() -> Tuple[Response, int]:
    """Registers a new user with a hashed password."""
    data: Dict[str, Any] = request.get_json()
    username: Optional[str] = data.get('username')
    password: Optional[str] = data.get('password')

    if not username or not password:
        return jsonify({"error": "Both Username and Password are required"}), 400

    hashed_password: str = bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()

    try:
        cur.execute(
            "INSERT INTO users (username, password_hash) VALUES (%s, %s)",
            (username, hashed_password)
        )
        conn.commit()
        return jsonify({"message": "User registered successfully!"}), 201
    except psycopg2.Error as e:
        return jsonify({"error": "Username already exists"}), 400


@app.route('/login', methods=['POST'])
def login() -> Tuple[Response, int]:
    """Validates user login by checking hashed password."""
    data: Dict[str, Any] = request.get_json()
    username: Optional[str] = data.get('username')
    password: Optional[str] = data.get('password')

    cur.execute("SELECT password_hash FROM users WHERE username = %s", (username,))
    user: Optional[Tuple[Any, ...]] = cur.fetchone()

    if user and password and bcrypt.checkpw(password.encode(), user[0].encode()):
        return jsonify({"message": "Login successful!"}), 200
    else:
        return jsonify({"error": "Invalid username or password"}), 401


@app.route('/streak', methods=['POST'])
def get_game_streak() -> Tuple[Response, int]:
    """
    Retrieves the user's current game streak for a given game option.
    Expects a JSON payload with "username" and "game_option".

    Note: This endpoint currently returns dummy data.

    This is how I'm imagining the table structure looking at some point

        CREATE TABLE game_scores (
            id SERIAL PRIMARY KEY,
            username VARCHAR(255) NOT NULL,
            game_option VARCHAR(255) NOT NULL,
            score INTEGER NOT NULL,
            game_date DATE NOT NULL
        );

    Just query for the user and game option, sort in descending order by the date,
    then do some python datetime stuff in a loop to see how many of them are consecutive.
    If today's or yesterday's date aren't the first option, then the streak is 0.
    """
    data: Dict[str, Any] = request.get_json()
    username: Optional[str] = data.get('username')
    game_option: Optional[str] = data.get('game_option')

    if not username or not game_option:
        return jsonify({"error": "Both username and game_option are required"}), 400

    # cur.execute("SELECT game_date FROM game_scores WHERE username = %s AND game_option = %s ORDER BY game_date DESC", (username, game_option))
    # dates: List[Tuple[date,]] = cur.fetchall()

    # Python loop would go here but I haven't done any looking into how Postgre stores dates (I know it does but idk how to get that into Python datetime objects just yet, so this may or may not be correct.)

    # Dummy logic for demonstration: assume the streak is 5 days.

    dummy_streak: int = 5
    return jsonify({"streak": dummy_streak}), 200


@app.route('/stats', methods=['POST'])
def get_game_stats() -> Tuple[Response, int]:
    """
    Retrieves play statistics for a given game option.
    Expects a JSON payload with "username" and "game_option".

    Example statistics include win percentage and average time taken.

    Note: This endpoint currently returns dummy data.

    This is how I imagine this table looking:

        CREATE TABLE game_stats (
            id SERIAL PRIMARY KEY,
            username VARCHAR(255) NOT NULL,
            game_option VARCHAR(255) NOT NULL,
            win BOOLEAN NOT NULL,
            time_taken INTERVAL NOT NULL,
            played_at TIMESTAMP NOT NULL
        );
    """
    data: Dict[str, Any] = request.get_json()
    username: Optional[str] = data.get('username')
    game_option: Optional[str] = data.get('game_option')

    if not username or not game_option:
        return jsonify({"error": "Both username and game_option are required"}), 400


    # cur.execute("SELECT win, time_taken FROM game_stats WHERE username = %s AND game_option = %s", (username, game_option))
    # records: List[Tuple[bool, datetime.timedelta]] = cur.fetchall()
    # Use records to calculate the win percentage and average time taken.

    # Loop over dates here to find the longest consecutive streak

    # Loop over completion times here to find the average completion

    # Dummy logic for demonstration purposes:
    dummy_statistics: List[Dict[str, Any]] = [
        {"statistic": "win_percentage", "value": 75.0},
        {"statistic": "average_time_taken", "value": "2m30s"}
    ]
    return jsonify({"statistics": dummy_statistics}), 200


if __name__ == '__main__':
    app.run(debug=True)
