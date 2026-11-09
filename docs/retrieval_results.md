# Retrieval evaluation

Held-out set: 68 hand-written paraphrased questions + 6 out-of-scope questions (`data/faq_eval.json`, none of them in the index). Small set, so treat the numbers as indicative.

| Retriever | Top-1 | Top-3 | Top-1 and above threshold | Out-of-scope rejected |
|---|---|---|---|---|
| Word TF-IDF (1-2 grams) | 75.0% | 85.3% | 75.0% | 33.3% |
| Char TF-IDF (3-5 grams) | 82.4% | 89.7% | 82.4% | 0.0% |
| Blend 50/50 (used by the app) | 82.4% | 94.1% | 82.4% | 16.7% |

Misses of the blended retriever (query -> retrieved question):

- `how much weight does ECAT have in the aggregate` -> What is the entry test for engineering admission?
- `can i switch from EE to CS after joining` -> Tell me about the Electrical Engineering department.
- `is MS available at narowal campus` -> Is Wi-Fi available on campus?
- `need based financial help for poor students` -> How do I apply for the Ehsaas scholarship?
- `will i get money back if i leave the university` -> Does the university provide transport?
- `how much does the hostel cost` -> Does UET Narowal have hostels?
- `is there a hostel for females` -> Does UET Narowal have hostels?
- `how many people in one hostel room` -> How do I apply for a hostel room?
- `does the bus go to sialkot` -> What is the transport fee?
- `I got an F what now` -> What can you help me with?
- `I was sick on exam day` -> What should I do on my first day?
- `i feel stressed, is there someone to talk to` -> How do I pay the fee?
