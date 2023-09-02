import os
import pytest
from base64 import b64encode
from requests import post


this_dir = os.path.dirname(os.path.abspath(__file__))
base_url = os.environ["URL"]
authorized_keys = [line.strip() for line in open(f"{this_dir}/authorized_keys")]


def password_json(password: str) -> dict[str, str]:
    return {
        "username": "username",
        "remoteAddress": "127.0.0.1:1234",
        "connectionId": "0",
        "passwordBase64": b64encode(password.encode()).decode(),
    }


def test_password_auth_is_disabled() -> None:
    response = post(f"{base_url}/password", json=password_json(password="test"))
    assert response.status_code == 200

    json = response.json()
    assert json["success"] == False


def pubkey_json(pubkey: str) -> dict[str, str]:
    return {
        "username": "username",
        "remoteAddress": "127.0.0.1:1234",
        "connectionId": "0",
        "publicKey": pubkey,
    }


@pytest.mark.parametrize("key", authorized_keys)
def test_public_key_in_authorized_keys_is_enabled(key: str) -> None:
    response = post(f"{base_url}/pubkey", json=pubkey_json(pubkey=key))
    assert response.status_code == 200

    json = response.json()
    assert json["success"] == True


def test_random_pubkey_is_disabled() -> None:
    response = post(
        f"{base_url}/pubkey", json=pubkey_json(pubkey="ssh-rsa random_pubkey")
    )
    json = response.json()
    assert json["success"] == False
