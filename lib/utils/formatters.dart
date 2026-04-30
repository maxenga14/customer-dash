/// Formats a double as a Tanzanian Shilling string.
/// Examples: 8500.0 → "Tsh 8,500"   45490.0 → "Tsh 45,490"
String formatTsh(double amount) {
  final intVal = amount.round();
  final s = intVal.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return 'Tsh $buf';
}
