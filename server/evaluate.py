"""Evaluate FAQ retrieval on the held-out paraphrase set (data/faq_eval.json).

Reports top-1 / top-3 accuracy on in-scope queries and the rejection rate on
out-of-scope queries (best score below the server's MINIMUM threshold), for
three retriever variants. Writes docs/retrieval_results.md.

Run:  python -m server.evaluate
"""
from __future__ import annotations

import json
from pathlib import Path

from .app import MINIMUM
from .retrieval import FaqIndex

ROOT = Path(__file__).resolve().parent.parent


def run(char_weight: float) -> dict:
    idx = FaqIndex(char_weight=char_weight)
    q2id = {it["question"]: it["id"] for it in idx.items}
    data = json.loads((ROOT / "data" / "faq_eval.json").read_text(encoding="utf-8"))["queries"]
    inscope = [d for d in data if d["expected"]]
    oos = [d for d in data if not d["expected"]]
    top1 = top3 = accepted_ok = 0
    misses = []
    for d in inscope:
        target = q2id[d["expected"]]  # KeyError here means the eval set is stale
        m = idx.search(d["q"], k=3)
        ids = [x.id for x in m]
        top1 += ids[0] == target
        top3 += target in ids
        accepted_ok += ids[0] == target and m[0].score >= MINIMUM
        if ids[0] != target:
            misses.append((d["q"], m[0].question))
    rejected = sum(idx.search(d["q"], k=1)[0].score < MINIMUM for d in oos)
    return {"n_in": len(inscope), "n_oos": len(oos), "top1": top1 / len(inscope),
            "top3": top3 / len(inscope), "answered_correctly": accepted_ok / len(inscope),
            "oos_rejected": rejected / len(oos), "misses": misses}


def main() -> None:
    variants = [("Word TF-IDF (1-2 grams)", 0.0), ("Char TF-IDF (3-5 grams)", 1.0),
                ("Blend 50/50 (used by the app)", 0.5)]
    rows, final = [], None
    for name, w in variants:
        r = run(w)
        final = r if w == 0.5 else final
        rows.append(f"| {name} | {r['top1']:.1%} | {r['top3']:.1%} | {r['answered_correctly']:.1%} | {r['oos_rejected']:.1%} |")
        print(name, {k: v for k, v in r.items() if k != "misses"})
    md = [
        "# Retrieval evaluation",
        "",
        f"Held-out set: {final['n_in']} hand-written paraphrased questions + {final['n_oos']} out-of-scope questions "
        "(`data/faq_eval.json`, none of them in the index). Small set, so treat the numbers as indicative.",
        "",
        "| Retriever | Top-1 | Top-3 | Top-1 and above threshold | Out-of-scope rejected |",
        "|---|---|---|---|---|",
        *rows,
        "",
        "Misses of the blended retriever (query -> retrieved question):",
        "",
        *[f"- `{q}` -> {got}" for q, got in final["misses"]],
        "",
    ]
    (ROOT / "docs").mkdir(exist_ok=True)
    (ROOT / "docs" / "retrieval_results.md").write_text("\n".join(md), encoding="utf-8")
    print("wrote docs/retrieval_results.md")


if __name__ == "__main__":
    main()
