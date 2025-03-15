import requests
from typing import Optional

BASE_URL: str = "http://localhost:5000"

def register_user(username: str, password: str) -> Optional[str]:
    """Sends a registration request to the backend."""
    url: str = f"{BASE_URL}/register"
    payload: dict[str, str] = {"username": username, "password": password}

    response: requests.Response = requests.post(url, json=payload)

    if response.status_code == 201:
        return response.json().get("message")
    else:
        return response.json().get("error")

def login_user(username: str, password: str) -> Optional[str]:
    """Sends a login request to the backend."""
    url: str = f"{BASE_URL}/login"
    payload: dict[str, str] = {"username": username, "password": password}

    response: requests.Response = requests.post(url, json=payload)

    if response.status_code == 200:
        return response.json().get("message")
    else:
        return response.json().get("error")

# if __name__ == "__main__":
#     # Example usage
#     print(register_user("testuser", "securepassword"))
#     print(login_user("testuser", "securepassword"))
#     ^^ these test cases appear to work, but I'm unable to properly test anything since we don't have a frontend yet
