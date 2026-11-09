"""UET Narowal Smart Assistant – chatbot API.

Pipeline: user question -> TF-IDF retrieval over the curated FAQ -> (optional)
LLM writes a short answer grounded only in the top retrieved FAQ entries ->
if no LLM key / LLM error, return the best retrieved answer directly.

Run:  uvicorn server.app:app --reload --port 8000
If the Flutter web build exists (build/web), it is served at http://localhost:8000/.
"""
from __future__ import annotations

from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

from . import llm
from .retrieval import FaqIndex

ROOT = Path(__file__).resolve().parent.parent
CONFIDENT = 0.30   # best score at/above this: answer from the FAQ
MINIMUM = 0.16     # below this: say we don't know and suggest topics

index = FaqIndex()
app = FastAPI(title="UET Narowal Smart Assistant API", version="1.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

SYSTEM = (
    "You are the UET Narowal Smart Assistant, a friendly guide for students of the "
    "University of Engineering and Technology (UET) Lahore, Narowal campus. Answer ONLY "
    "from the FAQ context provided. If the context does not answer the question, say you "
    "are not sure and suggest contacting the relevant office. Keep answers under 90 words, "
    "plain text, no markdown headings. Keep words like 'Sample' if the context uses them."
)

NOT_SURE = ("I'm not sure about that one. I can help with admissions, fees, scholarships, "
            "hostels, transport, departments, exams and campus facilities. You could also "
            "ask the Student Affairs office.")


class ChatIn(BaseModel):
    message: str = Field(..., min_length=1, max_length=500)


@app.get("/api/health")
def health():
    return {"status": "ok", "faq_count": len(index.items), "llm_online": llm.available(),
            "llm_model": llm.MODEL if llm.available() else None}


@app.get("/api/faq")
def faq():
    return {"note": index.note, "items": index.items}


@app.post("/api/chat")
def chat(body: ChatIn):
    matches = index.search(body.message, k=3)
    best = matches[0] if matches else None
    related = [m.public() for m in matches]

    if best is None or best.score < MINIMUM:
        return {"answer": NOT_SURE, "source": "fallback", "confident": False,
                "llm_online": llm.available(), "matches": related}

    answer, source = best.answer, "faq"
    context_items = [m for m in matches if m.score >= MINIMUM]
    context = "\n\n".join(f"Q: {m.question}\nA: {m.answer}" for m in context_items)
    reply = llm.chat(SYSTEM, f"FAQ context:\n{context}\n\nStudent question: {body.message}")
    if reply:
        answer, source = reply, "llm"

    return {"answer": answer, "source": source, "confident": best.score >= CONFIDENT,
            "llm_online": llm.available(), "matches": related}


_web = ROOT / "build" / "web"
if _web.exists():
    app.mount("/", StaticFiles(directory=_web, html=True), name="web")
