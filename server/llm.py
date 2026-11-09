"""Tiny OpenAI-compatible LLM client (Groq by default, OpenAI or local Ollama also work).

Configuration comes from .env:
    LLM_BASE_URL  e.g. https://api.groq.com/openai/v1  (Ollama: http://localhost:11434/v1)
    LLM_API_KEY   your key (Ollama: any non-empty string)
    LLM_MODEL     e.g. llama-3.1-8b-instant

If no key is set, or a call fails, `available()` is False / `chat()` returns None,
and the caller falls back to the retrieved FAQ answer.
"""
from __future__ import annotations

import os
from pathlib import Path

from dotenv import load_dotenv

load_dotenv(Path(__file__).resolve().parent.parent / ".env")

BASE_URL = os.getenv("LLM_BASE_URL", "https://api.groq.com/openai/v1")
API_KEY = os.getenv("LLM_API_KEY", "").strip()
MODEL = os.getenv("LLM_MODEL", "llama-3.1-8b-instant")

_client = None


def available() -> bool:
    return bool(API_KEY)


def _get_client():
    global _client
    if _client is None:
        from openai import OpenAI
        _client = OpenAI(base_url=BASE_URL, api_key=API_KEY, timeout=15.0)
    return _client


def chat(system: str, user: str, temperature: float = 0.2, max_tokens: int = 300) -> str | None:
    """Return the model's reply, or None if the LLM is not configured or the call fails."""
    if not available():
        return None
    try:
        resp = _get_client().chat.completions.create(
            model=MODEL,
            messages=[{"role": "system", "content": system},
                      {"role": "user", "content": user}],
            temperature=temperature,
            max_tokens=max_tokens,
        )
        return (resp.choices[0].message.content or "").strip() or None
    except Exception as exc:  # network error, bad key, rate limit...
        print(f"[llm] call failed, falling back to retrieval: {exc}")
        return None
