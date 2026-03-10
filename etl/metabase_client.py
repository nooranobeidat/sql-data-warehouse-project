import os
import requests


class MetabaseClient:
    def __init__(self):
        self.base_url = os.getenv("METABASE_URL").rstrip("/")
        self.session_token = os.getenv("METABASE_SESSION")

    def authenticate(self):
        """Try password-based auth and update the session token."""
        resp = requests.post(
            f"{self.base_url}/api/session",
            json={
                "username": os.getenv("METABASE_USERNAME"),
                "password": os.getenv("METABASE_PASSWORD"),
            },
        )
        resp.raise_for_status()
        self.session_token = resp.json()["id"]

    def _headers(self):
        return {"X-Metabase-Session": self.session_token}

    def _validate_session(self):
        """Check if the current session token is still valid."""
        resp = requests.get(
            f"{self.base_url}/api/user/current",
            headers=self._headers(),
        )
        return resp.status_code == 200

    def ensure_authenticated(self):
        if self.session_token and self._validate_session():
            return
        self.authenticate()

    def get_card_data(self, card_id):
        """Fetch all rows from a saved question (card) as a list of dicts."""
        resp = requests.post(
            f"{self.base_url}/api/card/{card_id}/query/json",
            headers=self._headers(),
        )

        if resp.status_code == 401:
            self.authenticate()
            resp = requests.post(
                f"{self.base_url}/api/card/{card_id}/query/json",
                headers=self._headers(),
            )

        resp.raise_for_status()
        return resp.json()
