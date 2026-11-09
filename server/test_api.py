"""API tests. Run: python -m pytest server -q   (works without any LLM key)."""
import os

os.environ["LLM_API_KEY"] = ""  # force the no-LLM fallback path

from fastapi.testclient import TestClient  # noqa: E402

from server import llm  # noqa: E402
from server.app import app, index  # noqa: E402

llm.API_KEY = ""
client = TestClient(app)


def test_faq_has_150_plus_entries():
    assert len(index.items) >= 150
    assert all(it["answer"] and it["question"] for it in index.items)


def test_health():
    r = client.get("/api/health").json()
    assert r["status"] == "ok" and r["llm_online"] is False


def test_chat_answers_from_faq_without_llm():
    r = client.post("/api/chat", json={"message": "how much is the hostel fee?"}).json()
    assert r["source"] == "faq"
    assert r["matches"][0]["question"] == "What is the hostel fee?"


def test_chat_out_of_scope():
    r = client.post("/api/chat", json={"message": "how do I cook biryani"}).json()
    assert r["source"] == "fallback"


def test_empty_message_rejected():
    assert client.post("/api/chat", json={"message": ""}).status_code == 422
