#!/bin/bash

# === Usage: ./createProject.sh my_project ===

set -euo pipefail

PROJECT_NAME=${1:-}

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Error: Please provide a project name."
  echo "✅ Usage: ./createProject.sh my_project"
  exit 1
fi

# Check if folder exists
if [ -d "$PROJECT_NAME" ]; then
	read -p "Folder '$PROJECT_NAME' already exists, enter 'y' to override: " overrideFolder
	if [[ "$overrideFolder" == "y" || "$overrideFolder" == "Y" ]]; then
  	echo "📂 '$PROJECT_NAME' will be overridden."
		rm -rf "$PROJECT_NAME"
	else
		echo "❌ Denied."
		exit 1
	fi
fi

# Create the base project folder
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit

# Create common folders for most types of projects (can be expanded later)
mkdir -p "src" "tests" "docs"

# Create the DRAP planning file
cat <<'EOF' > project.plan.md
# 🧠 DRAP Project Planning Template

> DRAP = Define – Represent – Analyze – Plan
> Use this before you write a single line of code.
> This template supports all workflows: functional, OOP, TDD, BDD, scripting, etc.

---

## ✅ 1. DEFINE – What are you building?

- **Goal / Problem Statement:**
  *(What is the purpose of this project? What problem does it solve?)*
  ➤ ....

- **Target user / audience:**
  *(Who will use it? Developer? End-user? System?)*
  ➤ ....

- **Inputs:**
  *(What data, files, or arguments are expected?)*
  ➤ ....

- **Outputs:**
  *(What results are returned, displayed, saved?)*
  ➤ ....

- **Constraints & Requirements:**
  *(Language, runtime, environment, architecture, testing requirements, etc.)*
  ➤ ....

---

## 🎯 2. REPRESENT – Internal mechanics

- **Core Concepts & Data Structures:**
  *(Variables, state machines, classes, DBs, etc.)*
  ➤ ....

- **Architecture / Layers (if any):**
  *(App Layer → Logic Layer → Data Layer)*
  *(MVC / Clean Architecture / Microservice / etc.)*
  ➤ ....

- **Program Flow / Pseudo-code:**
  \`\`\`
  Step 1: ...
  Step 2: ...
  Step 3: ...
  \`\`\`

- **Testing Strategy:**
  *(TDD? Unit tests? Integration? Tools used?)*
  ➤ ....

- **Optional diagrams (draw separately if needed):**
  - Flowcharts
  - Input/output examples
  - State transitions

---

## 🔍 3. ANALYZE – Risks, exceptions, assumptions

- **Edge Cases & Errors:**
  ➤ ....

- **What could break or go wrong:**
  ➤ ....

- **Assumptions made (about environment, inputs, timing):**
  ➤ ....

- **Future improvements / stretch goals:**
  ➤ ....

---

## 🧠 4. PLAN – Step-by-step actions

\`\`\`text
[ ] Task 1 – Set up folder structure
[ ] Task 2 – Write tests (TDD) or main logic scaffold
[ ] Task 3 – Build core logic / functionality
[ ] Task 4 – Implement I/O or interface
[ ] Task 5 – Add error handling
[ ] Task 6 – Write tests if not already
[ ] Task 7 – Document key parts
\`\`\`

---

## 📝 Notes

- You can split this file into `/docs` or copy parts into README.md later.
- Keep this updated as the project evolves.
- Optional: create README.md, LICENSE, .gitignore, etc.

EOF

# Create the general testing checklist
cat <<'EOF' > tests/testing_chicklist.md
✅ General Testing Checklist

1. Understand the Requirements

[ ] Do you fully understand what the code is supposed to do (specification)?

[ ] Are the expected inputs and outputs clearly defined?

[ ] Have you identified all constraints and limits?



---

2. Design Test Cases

[ ] Normal cases: Typical, valid inputs.

[ ] Boundary cases:

Minimum and maximum allowed values.

Full capacity and empty states.


[ ] Invalid/Error cases: Missing, malformed, or out-of-range inputs.

[ ] Random cases: Unexpected but valid variations.

[ ] Stress/Performance cases: Extremely large data sets or long-running operations.



---

3. Testing Methodology

[ ] Follow the Arrange → Act → Assert pattern.

[ ] Ensure each test is independent from others.

[ ] Ensure tests are repeatable (same input always yields the same result).



---

4. Assertions & Validation

[ ] Validate output correctness.

[ ] Check internal state consistency.

[ ] Ensure invariants remain unchanged.

[ ] Verify expected errors or exceptions are thrown when needed.



---

5. Coverage

[ ] Test all branches (if / else / switch).

[ ] Test all loops, including zero-iteration cases.

[ ] Test all exception and error paths.

[ ] Ensure coverage is meaningful, not just high percentage.



---

6. Performance & Reliability

[ ] Test performance under heavy load.

[ ] Monitor memory consumption.

[ ] Check for memory leaks or resource leaks.

[ ] Test stability during prolonged execution.



---

7. Environment Testing

[ ] Run tests in different environments (OS, browsers, platforms).

[ ] Verify dependency and library compatibility.

[ ] Test for localization and timezone variations.



---

8. Maintainability

[ ] Is the test code clear and readable?

[ ] Do test names describe their purpose?

[ ] Can repetitive code be simplified (fixtures, helpers)?

[ ] Can parts of the test be reused for other cases?



---

💡 Golden Rule:

> If you’re unsure whether a scenario needs testing, test it anyway.
Worst case: the test passes quickly.
Best case: you catch a bug early.

EOF

echo "✅ Project '$PROJECT_NAME' created with DRAP template and basic folders (src/, tests/, docs/)."
