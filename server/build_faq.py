"""Builds data/faq.json, the curated FAQ set behind the chatbot.

IMPORTANT: this is SAMPLE data. Campus-specific details (fees, dates, phone
numbers, room numbers, bus routes, hostel names) are realistic placeholders
written for the demo, not official UET Narowal information. Entries whose
answer is a general, well-known UET / HEC procedure are marked
"verified": false as well, because nobody has checked them against the 2026
prospectus yet. Edit this file, re-run it, and the server picks up the change.

Run:  python server/build_faq.py
"""
from __future__ import annotations

import json
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "data" / "faq.json"

# (category, question, [alternative phrasings], answer)
FAQ: list[tuple[str, str, list[str], str]] = []


def add(cat: str, q: str, alts: list[str], a: str) -> None:
    FAQ.append((cat, q, alts, a))


# ---------------------------------------------------------------- Admissions
C = "Admissions"
add(C, "How do I apply for admission to UET Narowal?",
    ["admission process", "how to get admission", "apply online"],
    "Apply through the UET Lahore online admission portal (UET Narowal is a sub-campus of UET Lahore). Create an account, fill in your academic record, upload documents, pay the processing fee and choose UET Narowal programmes in your preference list.")
add(C, "What is the entry test for engineering admission?",
    ["which test is required", "ECAT", "entrance exam"],
    "Engineering programmes require the ECAT (Engineering College Admission Test) conducted by UET Lahore. Some computer science seats may also accept other recognised tests; check the current prospectus.")
add(C, "How is the admission merit (aggregate) calculated?",
    ["merit formula", "aggregate calculation", "how is merit made"],
    "Sample formula used by UET campuses: Matric 17% + FSc / A-level equivalent 50% + ECAT 33%. Always confirm the weights in the current year's prospectus.")
add(C, "What was last year's closing merit for Computer Science?",
    ["closing merit CS", "last merit computer science", "cut off computer science"],
    "Sample figure: the last open-merit seat for BSc Computer Science at Narowal closed at about 72% aggregate. Closing merits change every year, so treat this only as a rough guide.")
add(C, "What was last year's closing merit for Electrical Engineering?",
    ["closing merit EE", "cut off electrical"],
    "Sample figure: about 74% aggregate for the last open-merit Electrical Engineering seat. It changes every year.")
add(C, "What documents are required for admission?",
    ["documents needed", "papers for admission", "admission documents list"],
    "Matric and FSc (or equivalent) mark sheets, CNIC or B-form, father's / guardian's CNIC, ECAT result card, domicile, 4 passport-size photos with blue background, and an IBCC equivalence certificate for O/A-level students.")
add(C, "When do admissions open?",
    ["admission dates", "admission schedule", "when will admission start"],
    "Sample schedule: undergraduate admissions usually open in July after the ECAT result, and classes for freshers start in late September or October. Watch the UET Lahore admissions page for the exact dates.")
add(C, "Is there a quota for students from Narowal district?",
    ["local quota", "district quota", "reserved seats Narowal"],
    "Sample policy: a share of seats is reserved for candidates with a Narowal-district domicile. Select the quota on the admission form and attach your domicile.")
add(C, "Are there reserved seats for special categories?",
    ["sports quota", "disabled quota", "army quota", "special seats"],
    "UET campuses usually reserve seats for sports, disabled persons, children of armed forces personnel, minorities and other categories listed in the prospectus. You must apply for them on the online form.")
add(C, "Can A-level students apply?",
    ["O level A level admission", "IBCC equivalence"],
    "Yes. A-level students apply with an IBCC equivalence certificate. If the final A-level result is pending, submit the equivalence based on O-level and AS results and update it later.")
add(C, "What is the admission processing fee?",
    ["application fee", "form fee", "admission form charges"],
    "Sample amount: Rs. 2,500 per application, paid through the challan generated on the admission portal.")
add(C, "How do I check the merit list?",
    ["merit list", "selection list", "am I selected"],
    "Merit lists are published on the UET Lahore admissions portal. Log in with your application ID to see your status, then pay the first-semester fee before the deadline to confirm your seat.")
add(C, "What happens if I miss the fee deadline after selection?",
    ["missed fee deadline", "late fee after merit list"],
    "Your seat is normally cancelled and offered to the next candidate in the next merit list. Contact the admissions office immediately if you have a genuine reason.")
add(C, "Can I change my department after admission?",
    ["department change", "migrate to another program", "change discipline"],
    "Department change is only possible during the admission process through the next merit lists, if your aggregate qualifies. After classes start, a change needs approval from the competent authority and is rarely granted.")
add(C, "Can I migrate from another university to UET Narowal?",
    ["transfer from another university", "migration case"],
    "Migration is considered case by case, usually only from HEC-recognised engineering universities with equivalent programmes and after the first year. Apply to the Registrar office with transcripts and a no-objection certificate.")
add(C, "Does UET Narowal offer evening or weekend programmes?",
    ["evening classes", "weekend program", "self finance evening"],
    "Sample information: no evening programmes are offered at the Narowal campus at the moment; all undergraduate classes run in the morning.")
add(C, "Does UET Narowal offer master's or PhD programmes?",
    ["MS program", "postgraduate", "MSc", "PhD"],
    "Sample information: the Narowal campus currently focuses on undergraduate programmes. Postgraduate programmes are offered at the UET Lahore main campus.")
add(C, "What is the minimum FSc marks requirement?",
    ["eligibility criteria", "minimum marks", "60 percent"],
    "For engineering programmes, PEC rules require at least 60% marks in FSc pre-engineering (or equivalent). Computer Science normally requires at least 50% with mathematics.")
add(C, "Can FSc pre-medical students apply for engineering?",
    ["pre medical to engineering", "medical students computer science"],
    "Pre-medical students can apply after passing the additional mathematics deficiency course (8 subjects) required by HEC/PEC, or for Computer Science where allowed by the prospectus.")
add(C, "Can DAE (diploma) holders apply?",
    ["DAE students", "diploma of associate engineer", "polytechnic"],
    "Yes, a separate quota exists for DAE holders in the relevant technology. They also take the ECAT and are ranked within the DAE quota.")

# ---------------------------------------------------------------- Fees
C = "Fees & Scholarships"
add(C, "What is the semester fee?",
    ["fee structure", "how much fee", "tuition fee", "per semester fee"],
    "Sample fee structure: about Rs. 62,000 per semester for engineering and Rs. 58,000 for Computer Science (regular / open merit). Self-finance seats cost more. Check the fee notice for the current year.")
add(C, "What is the fee for self-finance seats?",
    ["self finance fee", "self-finance"],
    "Sample amount: about Rs. 1,40,000 per semester for self-finance engineering seats. Self-finance seats have a separate merit list.")
add(C, "How do I pay the fee?",
    ["fee payment method", "where to pay fee", "fee challan"],
    "Download your fee challan from the student portal and pay at any branch of the designated bank, or by 1Bill / internet banking using the challan number. Keep the paid copy for record.")
add(C, "What is the fine for late fee payment?",
    ["late fee fine", "fee late charges"],
    "Sample policy: Rs. 100 per day after the due date for the first two weeks; after that your name may be struck off and readmission fee applies.")
add(C, "Can I pay the fee in installments?",
    ["fee installment", "pay fee in parts"],
    "Installments can be requested from the Treasurer office in genuine financial hardship. Submit an application with your father's income proof before the due date.")
add(C, "What scholarships are available?",
    ["scholarship list", "financial aid", "need based scholarship"],
    "Common options for UET students: HEC Ehsaas (need-based) undergraduate scholarship, Punjab Educational Endowment Fund (PEEF), merit scholarships for semester toppers, and Prime Minister's laptop / fee-reimbursement schemes when announced.")
add(C, "How do I apply for the Ehsaas scholarship?",
    ["ehsaas scholarship", "HEC need based"],
    "Apply online on the HEC Ehsaas portal when the call opens, then submit the printed form with income documents to the Student Affairs / Financial Aid office. Shortlisted students are interviewed on campus.")
add(C, "How do I apply for the PEEF scholarship?",
    ["PEEF", "punjab endowment fund"],
    "PEEF calls applications every year for students with Punjab domicile and family income below the published limit. Apply online and submit the form to the Financial Aid office.")
add(C, "Is there a merit scholarship for toppers?",
    ["merit scholarship", "position holder scholarship"],
    "Sample policy: students with a semester GPA of 3.7+ in the top 5% of their class get a tuition waiver for the next semester.")
add(C, "Is there a fee concession for siblings?",
    ["sibling concession", "brother sister discount"],
    "Sample policy: if two siblings study at UET at the same time, the younger one can apply for a 25% tuition concession at the Treasurer office.")
add(C, "Is the fee refundable if I leave?",
    ["fee refund", "refund policy"],
    "HEC refund policy: full tuition refund (minus admission fee) until the 7th day of classes, 50% until the 15th day, none afterwards. Security deposits are refunded on clearance.")
add(C, "What is the hostel fee?",
    ["hostel charges", "hostel rent"],
    "Sample amount: about Rs. 15,000 per semester for a shared room plus a refundable security of Rs. 5,000. Mess charges are separate and paid monthly.")
add(C, "What is the transport fee?",
    ["bus fee", "transport charges", "point fee"],
    "Sample amount: Rs. 9,000 per semester for a university bus pass, valid on all routes.")

# ---------------------------------------------------------------- Hostels
C = "Hostels"
add(C, "Does UET Narowal have hostels?",
    ["hostel facility", "accommodation", "is there a hostel"],
    "Yes (sample data): separate boys' and girls' hostels are available on or near campus with shared rooms, a mess, Wi-Fi and a common room.")
add(C, "How do I apply for a hostel room?",
    ["hostel registration", "hostel admission", "get hostel seat"],
    "Fill in the hostel application form on the student portal (or get it from the Hostel office) within two weeks of admission. Rooms are allotted on merit and distance from home.")
add(C, "Is there a girls' hostel?",
    ["girls hostel", "hostel for female students"],
    "Yes (sample data): a girls' hostel with a warden, female security staff and fixed in-time is available. Seats are limited, so apply early.")
add(C, "What is the hostel in-time?",
    ["hostel timing", "hostel curfew", "gate closing time hostel"],
    "Sample rules: 9:00 pm for the girls' hostel and 10:30 pm for the boys' hostel. Late entries need the warden's permission.")
add(C, "How many students share a room?",
    ["room sharing", "rooms per student", "triple room"],
    "Sample data: most rooms are shared by three students; a limited number of two-seater rooms go to senior students.")
add(C, "Is food available in the hostel?",
    ["hostel mess", "food in hostel", "mess charges"],
    "Yes. The hostel mess serves breakfast, lunch and dinner. Sample mess bill: around Rs. 9,000–11,000 per month, shared equally among members.")
add(C, "Who is the hostel warden?",
    ["warden contact", "hostel incharge"],
    "Sample information: each hostel has a resident warden from the faculty and a hostel supervisor. Their names and numbers are posted at the hostel reception.")
add(C, "Can I bring my own laptop, iron or heater to the hostel?",
    ["electric appliances in hostel", "heater allowed"],
    "Laptops and irons are allowed. Heaters, cooking stoves and other high-load appliances are not allowed in rooms for safety reasons.")
add(C, "Is Wi-Fi available in the hostel?",
    ["hostel internet", "wifi hostel"],
    "Yes (sample data): campus Wi-Fi covers the hostels. Log in with your student ID; heavy downloads may be throttled at night.")
add(C, "Can day scholars stay in the hostel during exams?",
    ["temporary hostel stay", "guest stay hostel"],
    "Temporary accommodation during exams may be given if rooms are free. Apply to the warden with a fee of the daily rate (sample: Rs. 300 per night).")
add(C, "Are visitors allowed in the hostel?",
    ["guest policy", "parents visit hostel"],
    "Parents and registered guardians may visit in the reception / visitor area during visiting hours. Visitors are not allowed in rooms.")
add(C, "What if hostel seats are full?",
    ["private hostel", "no hostel seat", "nearby accommodation"],
    "Several private hostels operate near campus in Narowal city. The Student Affairs office keeps an informal list, but verify safety and rent yourself.")

# ---------------------------------------------------------------- Transport
C = "Transport"
add(C, "Does the university provide transport?",
    ["university bus", "point service", "bus service"],
    "Yes (sample data): university buses run on fixed routes from Narowal city, Zafarwal, Shakargarh, Pasrur and Sialkot. A semester bus pass is required.")
add(C, "What are the bus routes?",
    ["bus route list", "point routes", "which areas bus covers"],
    "Sample routes: Route 1 Narowal city circular; Route 2 Shakargarh; Route 3 Zafarwal; Route 4 Pasrur; Route 5 Sialkot (via Daska road). Exact stops are on the Transport office notice board.")
add(C, "What time do the buses leave?",
    ["bus timing", "point timing", "bus departure time"],
    "Sample timings: morning pick-up starts around 6:45–7:30 am depending on the route; return buses leave campus at 2:30 pm and 4:30 pm.")
add(C, "How do I get a bus pass?",
    ["bus card", "transport card", "transport registration"],
    "Register on the student portal under Transport, pay the transport challan, then collect your bus card from the Transport office with a copy of your student ID.")
add(C, "Is there transport from Lahore?",
    ["Lahore to Narowal bus", "travel from Lahore"],
    "Sample information: there is no daily university bus from Lahore. Students travel by public transport (daewoo/coaster) to Narowal and use the city route from there.")
add(C, "Is parking available for students?",
    ["bike parking", "car parking", "motorcycle parking"],
    "Yes. Motorcycle parking is next to the main gate and a small car park is available. Display your vehicle sticker issued by the security office.")
add(C, "How do I get a vehicle sticker?",
    ["parking sticker", "vehicle pass"],
    "Apply at the Security office with your student ID, vehicle registration copy and driving licence. Stickers are free (sample policy).")

# ---------------------------------------------------------------- Departments
C = "Departments"
add(C, "Which departments are at UET Narowal?",
    ["list of departments", "programs offered", "which degrees are offered"],
    "Sample list: Electrical Engineering, Computer Engineering, Computer Science, Mechanical Engineering, and Humanities & Basic Sciences (supporting department). Open the Departments section of the app for details.")
add(C, "Tell me about the Computer Science department.",
    ["computer science department", "BSc CS", "CS program"],
    "The Department of Computer Science offers a 4-year BSc Computer Science (HEC/NCEAC curriculum) covering programming, data structures, databases, AI, networks and software engineering, with labs for programming and AI. (Sample description.)")
add(C, "Tell me about the Electrical Engineering department.",
    ["EE department", "electrical engineering program", "BSc EE"],
    "The Department of Electrical Engineering offers a PEC-accredited 4-year BSc Electrical Engineering with labs for circuits, electronics, power, control and communication. (Sample description.)")
add(C, "Tell me about the Computer Engineering department.",
    ["computer engineering", "BSc CE", "CPE department"],
    "The Department of Computer Engineering offers a 4-year BSc Computer Engineering that combines digital design, embedded systems, computer architecture and software. (Sample description.)")
add(C, "Tell me about the Mechanical Engineering department.",
    ["mechanical department", "BSc ME", "mechanical engineering"],
    "The Department of Mechanical Engineering offers a 4-year BSc Mechanical Engineering with workshops and labs for thermodynamics, fluid mechanics, machine design and manufacturing. (Sample description.)")
add(C, "What does the Humanities and Basic Sciences department teach?",
    ["basic sciences", "humanities department", "maths physics department"],
    "It teaches the shared courses every freshman takes: calculus, linear algebra, applied physics, English, Islamic studies / ethics and Pakistan studies.")
add(C, "Is the Electrical Engineering degree PEC accredited?",
    ["PEC accreditation", "is degree accredited", "pakistan engineering council"],
    "Engineering programmes at UET campuses are accredited by the Pakistan Engineering Council (PEC). Check the PEC website for the current accreditation status of each Narowal programme.")
add(C, "Is the Computer Science degree recognised by HEC?",
    ["HEC recognition", "NCEAC"],
    "Yes. UET Lahore is an HEC-recognised public university and its campuses award UET Lahore degrees. CS programmes follow the HEC / NCEAC curriculum.")
add(C, "Who is the chairman of the Computer Science department?",
    ["HOD CS", "head of department computer science", "chairperson CS"],
    "Sample information: the department is led by a Chairperson / Incharge. The current name is shown on the department page and notice board; the app keeps it as a placeholder until verified.")
add(C, "Where is the Computer Science department?",
    ["CS block location", "CS building where"],
    "Sample location: the Academic Block II, ground and first floor. Use the Campus Map tab and search 'Computer Science' for directions.")
add(C, "Where is the Electrical Engineering department?",
    ["EE block location", "electrical block"],
    "Sample location: Academic Block I. Search 'Electrical' in the Campus Map tab for directions.")
add(C, "What labs does the Computer Science department have?",
    ["CS labs", "computer labs"],
    "Sample list: two programming labs (40 PCs each), a networks lab, and an AI / data science lab with GPU workstations shared for final-year projects.")
add(C, "What labs does the Electrical department have?",
    ["EE labs", "electronics lab", "power lab"],
    "Sample list: Basic Electrical, Electronics, Digital Logic, Power & Machines, Control and Communication labs.")
add(C, "How many credit hours are required for a degree?",
    ["total credit hours", "credits to graduate"],
    "Typical requirement: about 130–136 credit hours for BSc engineering and about 130 for BSc Computer Science, spread over 8 semesters.")
add(C, "Can I do a minor in another subject?",
    ["minor degree", "elective from other department"],
    "Formal minors are not offered (sample information), but you can choose technical electives from related departments with your advisor's approval.")

# ---------------------------------------------------------------- Academics
C = "Academics & Exams"
add(C, "What is the grading system?",
    ["GPA system", "grades", "how is GPA calculated"],
    "UET uses a 4.0 GPA scale. A typical scale: A (85+) = 4.0, A- = 3.7, B+ = 3.3, B = 3.0, B- = 2.7, C+ = 2.3, C = 2.0, D = 1.0, F = 0. Confirm the exact bands in the semester rules.")
add(C, "What is the passing CGPA?",
    ["minimum CGPA", "probation", "academic probation"],
    "You must keep a CGPA of at least 2.0. Below that you are placed on probation; staying below the limit for consecutive semesters can lead to dismissal under semester rules.")
add(C, "How many absences are allowed?",
    ["attendance requirement", "75 percent attendance", "short attendance"],
    "Students need at least 75% attendance in each course to sit the final exam. Below that, you are marked 'short of attendance' and must repeat the course.")
add(C, "How is a course grade made up?",
    ["marks distribution", "sessional marks", "mid and final weight"],
    "A typical split: sessionals (quizzes, assignments, lab) 20–25%, mid-term 25–30%, final exam 50%. Each instructor shares the exact plan in the course outline.")
add(C, "When are mid-term exams?",
    ["mid term date", "midterm schedule"],
    "Mid-terms are normally held in the 8th–9th week of the semester. The exact date sheet is posted on the student portal and notice boards.")
add(C, "When are final exams?",
    ["final exam date", "finals schedule", "date sheet"],
    "Final exams start after the 16th week of teaching. The date sheet comes out about two weeks before.")
add(C, "What if I fail a course?",
    ["failed subject", "repeat course", "F grade"],
    "You repeat the course when it is offered next (often in the summer semester). The new grade replaces the F in your CGPA, but the transcript shows the course was repeated.")
add(C, "Is there a summer semester?",
    ["summer session", "summer courses"],
    "Yes (sample information): a short summer semester is offered for repeat / improvement courses when enough students register.")
add(C, "Can I improve my grade?",
    ["grade improvement", "improve GPA"],
    "Courses with a grade below the improvement limit (often C or lower) can be repeated once for improvement. The better grade counts.")
add(C, "How do I get my transcript?",
    ["transcript request", "result card", "DMC"],
    "Apply at the Examinations office (or the UET Lahore exams portal) with the fee challan. Sample processing time: 7 working days, or 2 days on urgent fee.")
add(C, "How do I apply for exam rechecking?",
    ["rechecking", "paper recheck", "result re-evaluation"],
    "Submit a rechecking application to the Controller of Examinations within 7 days of the result with the fee challan. Rechecking verifies totals and unmarked questions.")
add(C, "What is the academic calendar?",
    ["semester calendar", "academic schedule", "term dates"],
    "Sample calendar: Fall semester from October to February, Spring semester from March to July, optional Summer in July–August. The official calendar is on the university website.")
add(C, "Who is my academic advisor?",
    ["advisor", "faculty advisor", "mentor"],
    "Every student is assigned a faculty advisor at the start of the first semester. The list is posted by your department; ask your class representative (CR) if you missed it.")
add(C, "How do I register for courses?",
    ["course registration", "enroll courses", "add courses"],
    "Course registration is done on the student portal before each semester. First-semester courses are registered automatically for freshers.")
add(C, "Can I drop a course?",
    ["course withdrawal", "drop subject"],
    "Courses can be withdrawn before the deadline in the academic calendar (usually week 10). You get a W grade, which does not affect your GPA.")
add(C, "What is the final year project (FYP)?",
    ["FYP", "final year project", "capstone"],
    "In the last two semesters you complete a final-year project in a group of 2–4 students under a faculty supervisor, with proposal, mid and final evaluations.")
add(C, "Is an internship compulsory?",
    ["internship requirement", "summer internship"],
    "For engineering programmes a 6–8 week industrial internship after the 6th semester is part of the PEC requirement. The department's internship coordinator helps with placement letters.")
add(C, "What happens if I miss an exam due to illness?",
    ["missed exam", "medical exam", "makeup exam"],
    "Submit a medical certificate from a government hospital to your department within three days. If approved, you sit a special exam or get an 'I' (incomplete) grade.")
add(C, "Are class timings fixed?",
    ["class timings", "university timings", "start time"],
    "Sample timings: classes run from 8:30 am to 3:30 pm, Monday to Friday, with a break at 12:30–1:30 pm (longer on Fridays for prayers).")
add(C, "Is there a dress code?",
    ["dress code", "uniform"],
    "There is no uniform. Students are expected to dress decently; lab coats and closed shoes are required in labs and workshops.")
add(C, "What is the policy on cheating?",
    ["unfair means", "plagiarism", "copying in exam"],
    "Use of unfair means in exams or plagiarism in assignments is handled by the disciplinary committee and can lead to a zero, an F grade or suspension.")

# ---------------------------------------------------------------- Freshers
C = "Freshers"
add(C, "What should I do on my first day?",
    ["first day", "orientation", "new student guide"],
    "Attend the orientation session in the auditorium, collect your student ID card, find your department and timetable, and join your class WhatsApp/CR group. The app's Campus Map helps you find buildings.")
add(C, "When is orientation week?",
    ["orientation date", "welcome week"],
    "Sample schedule: orientation is held in the first week of classes. Departments introduce faculty, rules, labs and societies.")
add(C, "How do I get my student ID card?",
    ["ID card", "student card", "university card"],
    "Student ID cards are issued by the Student Affairs office in the first weeks. Bring a photo and your fee receipt. A lost card can be replaced for a fee (sample: Rs. 500).")
add(C, "What is the class representative (CR)?",
    ["CR", "class rep", "who is CR"],
    "Each section chooses a class representative (CR) and a girls' representative (GR) who communicate between students, faculty and the department.")
add(C, "How do I find my timetable?",
    ["timetable", "class schedule"],
    "Timetables are posted on the student portal and on department notice boards in the first week. Your CR shares updates in the class group.")
add(C, "Is ragging allowed?",
    ["ragging", "bullying", "harassment by seniors"],
    "No. Ragging and harassment are strictly prohibited. Report any incident to the Student Affairs office, the proctor or the anti-harassment committee.")
add(C, "What should I bring as a fresher?",
    ["things to bring", "fresher checklist"],
    "Bring your original documents and photocopies, a laptop if possible, a scientific calculator, lab coat for labs, and stationery. Hostel students should also bring bedding.")
add(C, "Do I need a laptop?",
    ["laptop required", "should I buy laptop"],
    "A laptop is strongly recommended, especially for Computer Science and Computer Engineering. Labs are available if you do not have one.")
add(C, "How do I join a society?",
    ["join club", "society membership", "student societies"],
    "Societies hold recruitment drives in the first month. Visit their stalls at the society fair or contact them on social media. You can join more than one.")

# ---------------------------------------------------------------- Facilities
C = "Campus Facilities"
add(C, "Where is the library?",
    ["library location", "find library"],
    "Sample location: the Central Library is next to the Admin Block. Search 'Library' in the Campus Map tab for directions.")
add(C, "What are the library timings?",
    ["library hours", "library opening time"],
    "Sample timings: 8:00 am to 6:00 pm on weekdays, extended to 8:00 pm during exams.")
add(C, "How many books can I borrow?",
    ["library borrowing", "issue books", "book loan"],
    "Sample policy: 3 books for 14 days. Late returns are fined Rs. 10 per book per day.")
add(C, "Does the library have digital resources?",
    ["HEC digital library", "e-books", "IEEE access"],
    "Yes. Through the HEC National Digital Library you can access IEEE, Springer, ScienceDirect and other databases from the campus network.")
add(C, "Is there a cafeteria on campus?",
    ["cafe", "canteen", "food on campus"],
    "Yes (sample data): the main cafeteria near the sports ground serves tea, snacks and lunch from 8 am to 5 pm.")
add(C, "Is there a mosque on campus?",
    ["prayer area", "masjid", "namaz place"],
    "Yes. The campus mosque is near the hostels, and prayer areas for female students are available in the academic blocks.")
add(C, "Is there a medical centre?",
    ["dispensary", "first aid", "doctor on campus"],
    "A medical centre / dispensary provides first aid and basic treatment during office hours. For emergencies, students are taken to DHQ Hospital Narowal.")
add(C, "What sports facilities are available?",
    ["sports", "cricket ground", "gym"],
    "Sample list: cricket and football ground, volleyball and basketball courts, table tennis and a small gym. Inter-department tournaments are held every year.")
add(C, "Is Wi-Fi available on campus?",
    ["campus internet", "wifi password", "eduroam"],
    "Yes. Campus Wi-Fi covers the academic blocks and library. Log in with your student credentials issued by the IT office.")
add(C, "Is there a photocopy shop on campus?",
    ["photocopy", "printing", "stationery shop"],
    "Yes (sample data): a photocopy and stationery shop is near the cafeteria. Printing is also available in the library at a small charge.")
add(C, "Is there a bank or ATM on campus?",
    ["ATM", "bank branch"],
    "Sample information: a bank booth with an ATM is near the Admin Block, where fee challans can also be paid.")
add(C, "Is there an auditorium?",
    ["auditorium", "seminar hall"],
    "Yes (sample data): the auditorium seats about 300 and is used for orientation, seminars and society events.")

# ---------------------------------------------------------------- IT / portal
C = "IT & Portal"
add(C, "How do I log in to the student portal?",
    ["student portal login", "LMS login", "portal password"],
    "Use your registration number and the password sent by the IT office at admission. If you cannot log in, visit the IT office with your ID card for a reset.")
add(C, "I forgot my portal password.",
    ["reset password", "forgot password"],
    "Use 'Forgot password' on the portal login page, or visit the IT office with your student ID card to reset it.")
add(C, "Do students get a university email?",
    ["student email", "official email"],
    "Sample policy: each student receives an official email (for example 2026-cs-01@student.uet.edu.pk). It is used for portal notices and can unlock education software discounts.")
add(C, "Where do I find course material?",
    ["lecture slides", "LMS", "google classroom"],
    "Instructors share material on the learning management system or Google Classroom. Your CR shares class codes in the first week.")
add(C, "Can I get free software like MATLAB or Microsoft Office?",
    ["software license", "MATLAB license", "office 365"],
    "Sample information: campus licences for MATLAB and Microsoft 365 may be available through your university email. Ask the IT office.")

# ---------------------------------------------------------------- Events & societies
C = "Events & Societies"
add(C, "What societies are there?",
    ["clubs list", "student societies list"],
    "Sample list: IEEE Student Branch, ACM / Computing Society, Robotics Club, Debating Society, Literary & Dramatics Society, Sports Society, Blood Donors Society and Community Service Society.")
add(C, "Are there any upcoming events?",
    ["events", "what is happening on campus", "upcoming activities"],
    "Sample events: Fresher Welcome (October), Tech Fest & Project Exhibition (spring), Sports Gala (February), Job Fair (May). Check the Events card on the Home screen for dates.")
add(C, "When is the fresher welcome party?",
    ["welcome party", "fresher party"],
    "Sample schedule: the fresher welcome is usually held in late October, organised by the senior batch with the Student Affairs office.")
add(C, "Is there a job fair?",
    ["career fair", "jobs", "recruitment drive"],
    "Yes (sample data): a job fair with local and Lahore-based companies is held every spring. The Career Development / Placement office announces it on the portal.")
add(C, "Are there hackathons or programming competitions?",
    ["coding competition", "hackathon", "speed programming"],
    "The Computing Society organises speed-programming contests and hackathons, and supports teams for national events like ICPC regionals and ACM / NUST / FAST competitions.")
add(C, "Is there a Tech Fest?",
    ["tech fest", "project exhibition", "open house"],
    "Yes (sample data): the annual Tech Fest in spring includes a final-year project exhibition, robotics competitions and gaming events.")
add(C, "How do I start a new society?",
    ["new club", "create society"],
    "Submit a proposal with a faculty patron, objectives and at least 20 members to the Student Affairs office for approval.")
add(C, "Is there a convocation?",
    ["convocation", "graduation ceremony", "degree ceremony"],
    "Graduates receive UET Lahore degrees. Convocations are held by UET Lahore; sample information: Narowal graduates may attend the main convocation in Lahore.")

# ---------------------------------------------------------------- Admin / contacts
C = "Admin & Contacts"
add(C, "Where is the admin block?",
    ["administration office", "admin building"],
    "Sample location: the Admin Block is right after the main gate. It houses the campus director's office, accounts, admissions and the Registrar's representative.")
add(C, "Who is the campus director?",
    ["director", "campus head", "principal"],
    "Sample information: the campus is headed by a Director / Campus Coordinator appointed by UET Lahore. The current name is on the official website; the app keeps it as a placeholder.")
add(C, "What is the university's phone number?",
    ["contact number", "phone", "helpline"],
    "Sample contact: (+92) 542-000000 (placeholder). Please use the number on the official UET Lahore Narowal campus website.")
add(C, "What is the official website?",
    ["website", "uet website", "url"],
    "The UET Lahore website is uet.edu.pk; campus news and notices for Narowal are published there and on the campus social media pages.")
add(C, "Where is UET Narowal located?",
    ["campus address", "location of campus", "how to reach campus"],
    "UET Lahore Narowal Campus is in Narowal, Punjab. Sample directions: on the main road out of Narowal city, a short drive from the city centre. Open the Campus Map tab for the map.")
add(C, "What are office timings?",
    ["admin office timing", "office hours"],
    "Sample timings: offices are open 8:30 am to 4:00 pm Monday to Thursday and 8:30 am to 12:30 pm on Friday.")
add(C, "How do I get a character certificate?",
    ["character certificate", "bonafide certificate", "student certificate"],
    "Apply at the Student Affairs office with your student ID and fee challan. Sample processing time: 3 working days.")
add(C, "How do I get my degree?",
    ["degree issuance", "degree apply"],
    "After clearing all courses and dues, apply for the degree on the UET Lahore examinations portal with the clearance form. Sample processing time: about 2–3 months, faster with urgent fee.")
add(C, "How do I get a clearance certificate?",
    ["clearance form", "no dues"],
    "Get the clearance form from the portal, collect signatures from the library, hostel, transport, accounts and your department, then submit it to the Admin office.")
add(C, "How do I report harassment?",
    ["harassment complaint", "anti harassment committee", "complaint"],
    "Contact the campus anti-harassment committee (a female faculty member is always a member) or the Student Affairs office. Complaints are confidential. You can also use the HEC complaint portal.")
add(C, "Where is lost and found?",
    ["lost and found", "lost item", "lost my ID"],
    "Check with the Security office at the main gate, where found items are kept for 30 days.")
add(C, "How do I contact the examinations office?",
    ["exam office contact", "controller of exams"],
    "The campus Examinations office is in the Admin Block (sample). For degrees and transcripts, the UET Lahore Controller of Examinations handles final processing.")

# ---------------------------------------------------------------- Narowal / life
C = "Campus Life"
add(C, "What is there to do in Narowal?",
    ["Narowal city", "places to visit Narowal"],
    "Narowal is a calm district city. Students visit the Kartarpur Corridor (Gurdwara Darbar Sahib, about 30 km away), local food streets in the city and the Ravi river area on weekends.")
add(C, "How far is Kartarpur from campus?",
    ["Kartarpur", "Gurdwara Darbar Sahib distance"],
    "Kartarpur (Gurdwara Darbar Sahib) is roughly 30–35 km from Narowal city, about 45 minutes by road.")
add(C, "Is the campus safe?",
    ["security on campus", "campus security"],
    "The campus has a boundary wall, security guards at the gates, ID checks and CCTV in key areas (sample data). Report any concern to the Security office.")
add(C, "Can I work part-time while studying?",
    ["part time job", "freelancing"],
    "Many students freelance or tutor. On-campus paid positions (lab assistant, library helper) are sometimes advertised by Student Affairs.")
add(C, "Is there a counselling service?",
    ["counselling", "mental health", "student counsellor"],
    "Sample information: a student counsellor / faculty advisor programme is available through Student Affairs. In crisis, contact Umang helpline 0311-7786264 (Pakistan).")
add(C, "Are there water coolers and washrooms in every block?",
    ["drinking water", "washroom"],
    "Yes, each academic block has filtered water coolers and separate washrooms for male and female students.")
add(C, "Is smoking allowed on campus?",
    ["smoking policy", "no smoking"],
    "No. The campus is a no-smoking zone.")
add(C, "Can I bring guests to campus?",
    ["guest entry", "visitor pass"],
    "Guests need a visitor pass from the Security office at the main gate and must show a CNIC.")

add(C, "Is there a bookshop near campus?",
    ["buy books", "textbooks shop"],
    "Sample information: a few bookshops in Narowal city sell engineering textbooks and past papers. Seniors also sell used books at the start of each semester.")
add(C, "Where can I eat outside campus?",
    ["restaurants near campus", "food outside"],
    "Narowal city has dhabas, fast-food outlets and bakeries within a short ride of campus. The cafeteria is the cheapest option during class hours.")

C = "Academics & Exams"
add(C, "Where can I find past papers?",
    ["past papers", "previous exams", "old papers"],
    "Seniors, society drives and the library usually keep past papers. Some instructors also share sample papers on the class LMS.")
add(C, "What is the semester system?",
    ["semester rules", "how many semesters"],
    "UET follows a semester system: a 4-year BSc has 8 regular semesters of about 16 teaching weeks each, plus exams.")
add(C, "Is there a project or thesis for CS students?",
    ["CS final project", "computer science FYP"],
    "Yes. BSc Computer Science students complete a two-semester final-year project in groups, usually building and documenting a software system.")
add(C, "Can I take extra courses in a semester?",
    ["overload", "extra credit hours", "maximum credit hours"],
    "Sample policy: the normal load is 15–18 credit hours; students with a CGPA above 3.0 may request up to 21 with the advisor's approval.")

C = "Hostels"
add(C, "Is there a laundry service in the hostel?",
    ["laundry", "washing clothes hostel"],
    "Sample information: a dhobi (laundry) service visits the hostels twice a week at fixed rates; students may also use the shared washing area.")
add(C, "Is electricity backup available in hostels?",
    ["load shedding hostel", "generator", "UPS hostel"],
    "Sample information: hostels have generator backup for lights and fans during load shedding. Personal UPS units are allowed.")

C = "Fees & Scholarships"
add(C, "Is there a laptop scheme for students?",
    ["free laptop", "PM laptop scheme"],
    "When the government announces the Prime Minister's / Chief Minister's laptop scheme, eligible students apply online and merit lists are shown by the university. There is no fixed yearly scheme.")
add(C, "Are there scholarships for girls?",
    ["female scholarship", "scholarship for women"],
    "Need-based schemes such as Ehsaas and PEEF are open to all students, and some calls (for example from USAID or provincial programmes) give special quotas to female students. Ask the Financial Aid office for current calls.")

C = "Transport"
add(C, "Do buses run on Saturdays?",
    ["weekend bus", "saturday transport"],
    "Sample information: no. Buses run Monday to Friday only, except for special arrangements during exams or events.")
add(C, "What if I miss the university bus?",
    ["missed bus", "missed point"],
    "Use public transport (rickshaw / wagon) from Narowal city. The university bus does not wait beyond the scheduled time.")

# ---------------------------------------------------------------- Bot meta
C = "About the assistant"
add(C, "What can you help me with?",
    ["help", "what can you do", "who are you"],
    "I am the UET Narowal Smart Assistant. Ask me about admissions, fees, scholarships, hostels, transport, departments, exams, campus facilities and events. Try the suggested questions below the chat.")
add(C, "Is this the official university app?",
    ["official app", "is this information correct"],
    "No. This is a student project. Answers come from a curated FAQ list, some of which is sample data. Always confirm important details with the university offices.")
add(C, "Hello",
    ["hi", "assalam o alaikum", "salam", "good morning", "hey"],
    "Wa alaikum assalam! Ask me anything about UET Narowal: admissions, fees, hostels, transport, departments or exams.")
add(C, "Thank you",
    ["thanks", "jazakallah", "shukriya", "thank u"],
    "You're welcome! Good luck with your studies.")


def main() -> None:
    out = {
        "_note": ("SAMPLE DATA. Campus-specific details (fees, dates, contacts, locations, "
                  "names) are realistic placeholders for a student demo, not official UET "
                  "Narowal information. Verify with the university before relying on them."),
        "version": 1,
        "items": [
            {"id": i + 1, "category": c, "question": q, "alternatives": alts,
             "answer": a, "verified": False}
            for i, (c, q, alts, a) in enumerate(FAQ)
        ],
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"wrote {len(FAQ)} FAQ entries to {OUT}")


if __name__ == "__main__":
    main()
