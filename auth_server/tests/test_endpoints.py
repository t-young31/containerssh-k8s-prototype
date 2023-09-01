import os
from requests import post


base_url = os.environ["URL"]


def test_password_auth_is_disabled() -> None:
    response = post(
        f"{base_url}/password",
        json={
            "username": "username",
            "remoteAddress": "127.0.0.1:1234",
            "connectionId": "0",
            "passwordBase64": "aGVsbG8K"  # pragma: allowlist secret
        }
    )
    print(response.text, response.status_code)
    assert False
