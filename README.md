# Early Careers Mobile Engineering Program (iOS)  
### Just Eat Command-Line Assignment

**GitHub Repository**: [https://github.com/Ibrahim-20030/JustEatAssignment](https://github.com/Ibrahim-20030/JustEatAssignment)

---

##  Overview ##

This is a Swift-based **command-line application** that interacts with the **Just Eat UK API** to fetch and display restaurant information based on a user-input UK postcode. The program retrieves live data, filters out irrelevant entries, and presents a clean list of the **top 10 restaurants**, including their **name**, **cuisines**, **numeric rating**, and **address**.

This solution was built with a clear focus on meeting **all assignment criteria**, while also applying thoughtful logic to exclude non-restaurant businesses and marketing tags that may confuse users.

---

##  Assignment Criteria Checklist ##

-  **All four restaurant data points** are displayed (name, cuisines, rating as a number, and address).
-  Output is **cleanly formatted and limited to the first 10 results**.
-  Interface is a **command-line Swift app**, clearly displaying data.
-  This README includes:
  - How to build, compile, and run the app.
  - Key assumptions made (with justifications).
  - Improvements I would consider for the future.
-  Submitted via GitHub, with full git history.

---

##  How to Build, Compile & Run the Code ##

###  Prerequisites
- macOS
- Xcode installed (latest version recommended)
- Internet connection to fetch live API data

---

###  Build & Compile (via Xcode)
1. Open the project by double-clicking `JustEatAssignment.xcodeproj`.
2. Ensure the top bar shows **My Mac (command-line app)**.
3. Go to the menu: **Product > Build** or press `Cmd ⌘ + B`.
4. Xcode will automatically **build and compile** the project.

---

###  Run the Project

#### Option A – Using Xcode:
1. Click the **Run** button in the top-left or press `Cmd ⌘ + R`.
2. In the console that appears, **enter any valid UK postcode**, e.g. `EC4M 7RF`.
3. The app will:
   - Fetch data from the Just Eat API
   - Filter out non-restaurant and marketing entries
   - Display **top 10 restaurant results** (if available)

#### Option B – Using Terminal:
If compiling via Terminal, run:

```bash
swiftc JustEatAssignment/main.swift -o JustEatApp
./JustEatApp
```

This compiles the app and executes it in the command line.

---

###  Example Output

```
Restaurant #1
Name: Pizza Express
Cuisines: Italian, Pizza
Rating: 4.5
Address: 21 High Street, EC4M 7RF
──────────────────────────────
```

---

##  Assumptions Made ##

### 1. **Marketing Tags Are Not Cuisines**
The `cuisines` array includes entries like `Deals`, `Low Delivery Fee`, `Collect stamps`, etc.  
**Assumption**: These are **not actual cuisines**.  
**Action**: Used a **whitelist filter** to only display genuine cuisines like `Italian`, `Indian`, etc.

---

### 2. **Exclude Non-Restaurants (e.g., Groceries, Pharmacies)**
Some businesses in the API are supermarkets or health stores.  
**Assumption**: If the restaurant name includes `"grocery"`, or it lacks a valid cuisine, it should be ignored.  
**Action**: Automatically filtered based on name and cuisine checks.

---

### 3. **Unrated Restaurants Should Still Appear**
Some entries have no rating or `0.0`.  
**Assumption**: Show them, but clearly label them as `"Not yet rated"`.  
**Action**: Displayed conditional message instead of numeric rating.

---

### 4. **Show the First 10 Results**
**Assumption**: The “first” 10 means **first in the returned array**, not sorted by rating.  
**Action**: Used `.prefix(10)` to extract the top entries returned by the API.

---

### 5. **Missing Address Fields**
Some restaurants are missing a full address.  
**Assumption**: These fields are optional.  
**Action**: Used optional chaining and fallback values like `"N/A"`.

---

##  Improvements I'd Consider ##

###  1. **Smarter Cuisine Filtering**
Current solution uses a **manual whitelist**.  
**Improvement**: Pull cuisine categories dynamically from `metaData.cuisineDetails`, or apply NLP to distinguish food vs marketing tags.  
**Benefit**: Future-proof filtering without manual list maintenance.

---

###  2. **Add Schema Validation**
Right now, decoding assumes the API structure is stable.  
**Improvement**: Add JSON validation layer before decoding.  
**Benefit**: Prevents crashes if the API changes structure.

---

###  3. **Sort by Rating**
The API’s order may not reflect quality.  
**Improvement**: Add optional sorting by `rating` (descending).  
**Benefit**: Highlight better-rated restaurants while still showing only 10.

---

###  4. **UI Version (SwiftUI or UIKit)**
**Improvement**: Build a SwiftUI version with:
- Input field for postcode
- List of restaurants with better formatting
- Collapsible detail cards
- Visual star ratings  
**Benefit**: More engaging, user-friendly, and matches real-world app UX.

---

###  5. **More Robust Exclusion for Shops**
**Improvement**: Build an internal keyword list (`pharmacy`, `convenience`, `electronics`, etc.) to **automatically detect and skip shops** even if named obscurely.  
**Benefit**: Better precision and reduces false positives.

---

##  Submission Notes ##

GitHub Repository: [https://github.com/Ibrahim-20030/JustEatAssignment](https://github.com/Ibrahim-20030/JustEatAssignment)  
Submitted as part of the **Early Careers Mobile Engineering Program (iOS)** coding assignment.

