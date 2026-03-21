// Task 2: Higher-Order Functions with Maps
// Build a map of words to their lengths, then print entries where length > 4.

void main() {
  final words = ['apple', 'cat', 'banana', 'dog', 'elephant'];

  // associateWith equivalent: create a map where each word maps to its length
  final wordLengths = {for (final word in words) word: word.length};

  // Filter entries with length > 4 and print each one
  wordLengths.entries
      .where((entry) => entry.value > 4)
      .forEach((entry) => print('${entry.key} has length ${entry.value}'));
}

// Expected Output:
// apple has length 5
// banana has length 6
// elephant has length 8
