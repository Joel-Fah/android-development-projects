# 🤖 Agent Instructions — Student Grade Calculator

> These instructions tell you exactly what to build, how to build it, and how to push it to GitHub when done.
> Follow each task in order. Do not skip steps.

---

## 🧠 Context

You are building a **Student Grade Calculator** — a console application in both **Dart** and **Kotlin**.

- It reads student scores from an Excel (`.xlsx`) file
- Computes each student's average, letter grade, and GPA
- Writes a new `.xlsx` output file with the results

The full project spec is in `README.md`. Read it before writing any code.

---

## 🏆 Grading Scale (implement this exactly)

| Grade | GPA | Min Score | Max Score |
|-------|-----|-----------|-----------|
| A     | 4.0 | 80        | 100       |
| B+    | 3.5 | 70        | 79        |
| B     | 3.0 | 60        | 69        |
| C+    | 2.5 | 55        | 59        |
| C     | 2.0 | 50        | 54        |
| D+    | 1.5 | 45        | 49        |
| D     | 1.0 | 40        | 44        |
| F     | 0.0 | 0         | 39        |

> Pass threshold: average **≥ 40** (grade D or above). Below 40 = FAIL.

---

## 📁 Expected Repository Structure

```
student-grade-calculator/
├── dart/
│   ├── bin/main.dart
│   ├── lib/
│   │   ├── models/student.dart
│   │   ├── services/grade_calculator.dart
│   │   └── io/
│   │       ├── excel_reader.dart
│   │       └── excel_writer.dart
│   ├── test/grade_calculator_test.dart
│   └── pubspec.yaml
├── kotlin/
│   ├── src/main/kotlin/
│   │   ├── Main.kt
│   │   ├── models/Student.kt
│   │   ├── services/GradeCalculator.kt
│   │   └── io/
│   │       ├── ExcelReader.kt
│   │       └── ExcelWriter.kt
│   ├── src/test/kotlin/GradeCalculatorTest.kt
│   └── build.gradle.kts
├── docs/
│   └── uml_class_diagram.puml
├── sample_input.xlsx
└── README.md
```

---

## ✅ Task List

Work through these tasks in order. Check each off as you go.

---

### TASK 1 — Set up the Dart project

1. Initialize the Dart project: `dart create --template=console dart` (inside the root folder)
2. Clean up the default files, keep only `bin/main.dart`
3. Create the folder structure: `lib/models/`, `lib/services/`, `lib/io/`, `test/`
4. Edit `pubspec.yaml` — add the `excel` dependency:

```yaml
name: student_grade_calculator
description: Reads student scores from Excel and computes grades.
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  excel: ^4.0.0
  args: ^2.4.0
dev_dependencies:
  test: ^1.24.0
  lints: ^3.0.0
```

---

### TASK 2 — Write the Dart models

**File:** `dart/lib/models/student.dart`

Write a `Student` class with these fields:
- `studentId` (String)
- `name` (String)
- `scores` (List\<double\>)
- `average` (double) — set after calculation
- `grade` (String) — e.g. "A", "B+", "F"
- `gpa` (double)
- `status` (String) — "PASS" or "FAIL"

Add a `toString()` method that prints a readable summary.
Add a DartDoc comment (`///`) on the class and each field explaining what it represents.

> 💡 Keep it simple. Use a plain class with named parameters and default values where needed.

---

### TASK 3 — Write the Dart GradeCalculator service

**File:** `dart/lib/services/grade_calculator.dart`

Write a `GradeCalculator` class with these methods:

- `double computeAverage(List<double> scores)` — returns the arithmetic mean; returns 0.0 if the list is empty
- `String assignGrade(double average)` — returns the letter grade using the grading scale above
- `double assignGpa(double average)` — returns the GPA value
- `String determineStatus(String grade)` — returns "PASS" if grade != "F", else "FAIL"
- `Student calculate(Student student)` — fills in average, grade, gpa, status on a student and returns it
- `List<Student> calculateAll(List<Student> students)` — applies `calculate()` to each student

Add a DartDoc comment on the class and each method.

> 💡 `assignGrade` should use a simple series of `if/else if` checks, not a complex map. Keep it readable.

---

### TASK 4 — Write the Dart ExcelReader

**File:** `dart/lib/io/excel_reader.dart`

Write an `ExcelReader` class that:
- Takes a `filePath` in its constructor
- Has a `List<Student> read()` method that:
  1. Opens the `.xlsx` file using the `excel` package
  2. Reads the first sheet
  3. Skips the header row (row 0)
  4. For each subsequent row: extracts `studentId` (col 0), `name` (col 1), and all remaining cells as scores
  5. Returns a `List<Student>` (with empty average/grade — those come from GradeCalculator)

Add clear inline comments explaining each step for learning purposes.

---

### TASK 5 — Write the Dart ExcelWriter

**File:** `dart/lib/io/excel_writer.dart`

Write an `ExcelWriter` class that:
- Takes an `outputPath` in its constructor
- Has a `void write(List<Student> students, List<String> subjectHeaders)` method that:
  1. Creates a new Excel workbook
  2. Writes a header row: `StudentID | Name | <subjects...> | Average | Grade | GPA | Status`
  3. Writes one row per student with all their data
  4. Saves the file to `outputPath`

Add clear inline comments explaining each step.

---

### TASK 6 — Write the Dart main entry point

**File:** `dart/bin/main.dart`

Write the `main(List<String> args)` function that:
1. Uses the `args` package to parse `--input` and `--output` flags
2. If `--help` is passed, prints usage and exits
3. Calls `ExcelReader.read()` to get the student list
4. Calls `GradeCalculator.calculateAll()` to enrich the list
5. Calls `ExcelWriter.write()` to produce the output file
6. Prints a short summary to the console: total students, pass count, fail count

---

### TASK 7 — Write the Dart tests

**File:** `dart/test/grade_calculator_test.dart`

Write unit tests for `GradeCalculator` using the `test` package:

Test `computeAverage`:
- Empty list → 0.0
- Single score → that score
- Multiple scores → correct mean

Test `assignGrade` for every boundary:
- 100 → "A", 80 → "A", 79 → "B+", 70 → "B+", 69 → "B", 60 → "B"
- 59 → "C+", 55 → "C+", 54 → "C", 50 → "C"
- 49 → "D+", 45 → "D+", 44 → "D", 40 → "D"
- 39 → "F", 0 → "F"

Test `determineStatus`:
- "F" → "FAIL"
- Everything else → "PASS"

---

### TASK 8 — Set up the Kotlin project

1. Create the Kotlin folder structure manually (do not use Spring Initializr)
2. Create `build.gradle.kts` with:

```kotlin
plugins {
    kotlin("jvm") version "1.9.22"
    application
    id("com.github.johnrengelman.shadow") version "8.1.1"
}

group = "com.gradecalculator"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.apache.poi:poi-ooxml:5.2.5")
    implementation("org.slf4j:slf4j-simple:2.0.9")
}

application {
    mainClass.set("MainKt")
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(17)
}
```

Add a `settings.gradle.kts`:
```kotlin
rootProject.name = "student-grade-calculator"
```

---

### TASK 9 — Write the Kotlin models

**File:** `kotlin/src/main/kotlin/models/Student.kt`

Write a Kotlin **data class** `Student`:

```kotlin
data class Student(
    val studentId: String,
    val name: String,
    val scores: List<Double>,
    val average: Double = 0.0,
    val grade: String = "",
    val gpa: Double = 0.0,
    val status: String = ""
)
```

Add KDoc comments (`/** */`) on the class and each field.

> 💡 Use a `data class` — it gives you `toString()`, `copy()`, and equality for free. Explain this in a comment.

---

### TASK 10 — Write the Kotlin GradeCalculator

**File:** `kotlin/src/main/kotlin/services/GradeCalculator.kt`

Mirror the Dart version exactly. Write a `GradeCalculator` class with:
- `fun computeAverage(scores: List<Double>): Double`
- `fun assignGrade(average: Double): String`
- `fun assignGpa(average: Double): Double`
- `fun determineStatus(grade: String): String`
- `fun calculate(student: Student): Student` — use `student.copy(...)` to return an enriched copy
- `fun calculateAll(students: List<Student>): List<Student>`

Add KDoc comments on the class and each method.

> 💡 Use `when` expression in `assignGrade` — it's Kotlin's cleaner version of `switch`. Show this in a comment.

---

### TASK 11 — Write the Kotlin ExcelReader

**File:** `kotlin/src/main/kotlin/io/ExcelReader.kt`

Write an `ExcelReader` class using Apache POI:
- Constructor takes `filePath: String`
- `fun read(): List<Student>` — opens the file, reads the first sheet, skips the header, maps each row to a `Student`

Add inline comments explaining the Apache POI API calls for learners.

---

### TASK 12 — Write the Kotlin ExcelWriter

**File:** `kotlin/src/main/kotlin/io/ExcelWriter.kt`

Write an `ExcelWriter` class using Apache POI:
- Constructor takes `outputPath: String`
- `fun write(students: List<Student>, subjectHeaders: List<String>)` — creates a workbook, writes the header row, writes one row per student, saves the file

Add inline comments explaining each Apache POI step.

---

### TASK 13 — Write the Kotlin main entry point

**File:** `kotlin/src/main/kotlin/Main.kt`

Mirror the Dart main exactly:
1. Parse `--input` and `--output` from `args`
2. If `--help` or args are missing, print usage and exit
3. Run the full pipeline: read → calculate → write
4. Print a summary to the console

---

### TASK 14 — Write the Kotlin tests

**File:** `kotlin/src/test/kotlin/GradeCalculatorTest.kt`

Mirror the Dart tests exactly using JUnit 5. Use `@Test` annotations. Test the same boundary values.

Add the JUnit 5 dependency to `build.gradle.kts`:
```kotlin
testImplementation("org.junit.jupiter:junit-jupiter:5.10.1")
```

---

### TASK 15 — Create a sample input file

Create a file called `sample_input.xlsx` at the root of the project.

It must have this structure (use any Excel/spreadsheet library available):

| StudentID | Name         | Math | Science | English | History |
|-----------|--------------|------|---------|---------|---------|
| S001      | Alice Martin | 85   | 90      | 78      | 88      |
| S002      | Bob Johnson  | 55   | 48      | 62      | 51      |
| S003      | Carol Dupont | 72   | 68      | 75      | 70      |
| S004      | David Lee    | 38   | 42      | 35      | 30      |
| S005      | Eva Nguyen   | 95   | 97      | 91      | 93      |

This file is used for manual testing and as a demo.

---

### TASK 16 — Final checks before pushing

Before pushing to GitHub, verify the following:

**Dart:**
```bash
cd dart
dart pub get
dart analyze           # should show no errors
dart test              # all tests must pass
dart run bin/main.dart --input ../sample_input.xlsx --output ../output_dart.xlsx
```

**Kotlin:**
```bash
cd kotlin
./gradlew build        # should compile without errors
./gradlew test         # all tests must pass
./gradlew run --args="--input ../sample_input.xlsx --output ../output_kotlin.xlsx"
```

Check that both output files exist and contain correct grades.

---

### TASK 17 — Push to GitHub

The remote repository is already created at:
**`https://github.com/Joel-Fah/Student-Grade-Calculator.git`**

Run the following from the **root of the project folder**:

```bash
# Step 1 — Initialize git if not already done
git init

# Step 2 — Add all files
git add .

# Step 3 — First commit
git commit -m "feat: initial project — Dart and Kotlin Student Grade Calculator

- Dart implementation with ExcelReader, GradeCalculator, ExcelWriter
- Kotlin implementation mirroring the Dart version
- Unit tests for GradeCalculator in both languages
- Sample input Excel file
- PlantUML class diagram
- README with grading scale, usage, and project structure"

# Step 4 — Connect to remote
git remote add origin https://github.com/Joel-Fah/Student-Grade-Calculator.git

# Step 5 — Push
git branch -M main
git push -u origin main
```

> ⚠️ If you get an authentication error, use a GitHub Personal Access Token (PAT) instead of a password.
> Generate one at: https://github.com/settings/tokens (scope: `repo`)
> Then run: `git remote set-url origin https://<YOUR_TOKEN>@github.com/Joel-Fah/Student-Grade-Calculator.git`

---

## 📌 Code Style Rules

Follow these in **both** implementations:

- **Keep functions short** — each function does one thing only
- **Comment every non-obvious line** — this is a learning project
- **Use descriptive names** — `computeAverage` not `calc`, `assignGrade` not `grade`
- **No magic numbers** — define the grading scale as a constant or enum, not inline numbers
- **Dart:** follow `dart analyze` with no warnings; use `///` for DartDoc
- **Kotlin:** use `data class` for models, `when` for grade assignment; use `/** */` for KDoc

---

## 🏁 Done!

When all 17 tasks are complete and the code is on GitHub, the project is finished.
Both implementations should produce identical output for the same input file.
