// Task 3: OOP + Higher-Order Functions
// Find the average age of people whose names start with 'A' or 'B'.

class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  @override
  String toString() => 'Person(name: $name, age: $age)';
}

void main() {
  final people = [
    Person('Alice', 25),
    Person('Bob', 30),
    Person('Charlie', 35),
    Person('Anna', 22),
    Person('Ben', 28),
  ];

  // Step 1: Filter people whose name starts with 'A' or 'B'
  final filtered = people
      .where((p) => p.name.startsWith('A') || p.name.startsWith('B'))
      .toList();

  // Step 2: Extract ages
  final ages = filtered.map((p) => p.age).toList();

  // Step 3: Calculate average
  final average = ages.reduce((a, b) => a + b) / ages.length;

  // Step 4: Format and print (rounded to 1 decimal place)
  print(
    'Average age of people whose names start with A or B: '
    '${average.toStringAsFixed(1)}',
  );
}

// Expected Output:
// Average age of people whose names start with A or B: 26.3
// (Alice=25, Bob=30, Anna=22, Ben=28 → sum=105, count=4 → avg=26.25 → 26.3)
