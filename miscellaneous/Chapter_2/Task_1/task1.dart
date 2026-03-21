// Task 1: Higher-Order Functions & Lambda Functions
// processList filters a list of integers using a lambda predicate.

List<int> processList(List<int> numbers, bool Function(int) predicate) {
  return numbers.where(predicate).toList();
}

void main() {
  final nums = [1, 2, 3, 4, 5, 6];

  // Lambda: keep only even numbers
  final even = processList(nums, (it) => it % 2 == 0);
  print(even); // [2, 4, 6]

  // Lambda: keep only odd numbers
  final odd = processList(nums, (it) => it % 2 != 0);
  print(odd); // [1, 3, 5]

  // Lambda: keep numbers greater than 3
  final greaterThanThree = processList(nums, (it) => it > 3);
  print(greaterThanThree); // [4, 5, 6]
}
