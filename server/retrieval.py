"""TF-IDF retrieval over the curated FAQ (data/faq.json).

Each FAQ item contributes several "documents": its main question and every
alternative phrasing. A query is scored against all of them with a blend of
word n-gram and character n-gram TF-IDF cosine similarity (char n-grams make it
robust to typos and Roman-Urdu-ish spellings), and each item keeps its best score.
"""
from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path

import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer

DATA = Path(__file__).resolve().parent.parent / "data" / "faq.json"

# Light normalisation so common student spellings hit the same terms.
_SYNONYMS = {
    r"\bfees\b": "fee",
    r"\bhostal\b": "hostel",
    r"\buni\b": "university",
    r"\bcs\b": "computer science",
    r"\bee\b": "electrical engineering",
    r"\bme\b(?= department| dept)": "mechanical engineering",
    r"\bdept\b": "department",
    r"\bpoint\b": "bus",
    r"\bkab\b": "when",
    r"\bkahan\b": "where",
    r"\bkitni\b": "how much",
}


def normalise(text: str) -> str:
    t = text.lower().strip()
    for pat, rep in _SYNONYMS.items():
        t = re.sub(pat, rep, t)
    return re.sub(r"[^\w\s%-]", " ", t)


@dataclass
class Match:
    id: int
    category: str
    question: str
    answer: str
    score: float

    def public(self) -> dict:
        return {"id": self.id, "category": self.category, "question": self.question,
                "score": round(self.score, 3)}


class FaqIndex:
    def __init__(self, path: Path = DATA, char_weight: float = 0.5):
        raw = json.loads(path.read_text(encoding="utf-8"))
        self.note: str = raw.get("_note", "")
        self.items: list[dict] = raw["items"]
        self.by_id = {it["id"]: it for it in self.items}
        self.char_weight = char_weight

        docs, owners = [], []
        for it in self.items:
            for q in [it["question"], *it.get("alternatives", [])]:
                docs.append(normalise(q))
                owners.append(it["id"])
        self.owners = np.array(owners)
        self.word = TfidfVectorizer(ngram_range=(1, 2), sublinear_tf=True, stop_words="english")
        self.char = TfidfVectorizer(analyzer="char_wb", ngram_range=(3, 5), sublinear_tf=True)
        self.Xw = self.word.fit_transform(docs)
        self.Xc = self.char.fit_transform(docs)

    def search(self, query: str, k: int = 3) -> list[Match]:
        q = normalise(query)
        sw = (self.Xw @ self.word.transform([q]).T).toarray().ravel()
        sc = (self.Xc @ self.char.transform([q]).T).toarray().ravel()
        s = (1 - self.char_weight) * sw + self.char_weight * sc
        best: dict[int, float] = {}
        for owner, score in zip(self.owners, s):
            if score > best.get(owner, -1.0):
                best[owner] = float(score)
        top = sorted(best.items(), key=lambda kv: kv[1], reverse=True)[:k]
        out = []
        for i, score in top:
            it = self.by_id[int(i)]
            out.append(Match(int(i), it["category"], it["question"], it["answer"], score))
        return out
