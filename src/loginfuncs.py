import requests

BASE_URL = "http://localhost:5000"

def register_user(username: str, password: str):
    """Sends a registration request to the backend."""
    url = f"{BASE_URL}/register"
    payload = {"username": username, "password": password}

    response = requests.post(url, json=payload)

    if response.status_code == 201:
        return response.json()["message"]
    else:
        return response.json()["error"]

def login_user(username: str, password: str):
    """Sends a login request to the backend."""
    url = f"{BASE_URL}/login"
    payload = {"username": username, "password": password}

    response = requests.post(url, json=payload)

    if response.status_code == 200:
        return response.json()["message"]
    else:
        return response.json()["error"]

# if __name__ == "__main__":
#     # Example usage
#     print(register_user("testuser", "securepassword"))
#     print(login_user("testuser", "securepassword"))
#     ^^ these test cases appear to work, but I'm unable to properly test anything since we don't have a frontend yet
