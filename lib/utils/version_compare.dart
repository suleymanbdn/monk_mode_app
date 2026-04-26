/// Compares dotted version strings (e.g. 1.2.10 vs 1.3.0). Returns negative if [a] < [b].
int compareVersionStrings(String a, String b) {
  final pa = _parse(a);
  final pb = _parse(b);
  final len = pa.length > pb.length ? pa.length : pb.length;
  for (var i = 0; i < len; i++) {
    final va = i < pa.length ? pa[i] : 0;
    final vb = i < pb.length ? pb[i] : 0;
    if (va != vb) return va.compareTo(vb);
  }
  return 0;
}

List<int> _parse(String raw) {
  final s = raw.trim().split('+').first.trim();
  if (s.isEmpty) return [0];
  return s
      .split('.')
      .map((e) => int.tryParse(e.replaceAll(RegExp(r'[^\d]'), '')) ?? 0)
      .toList();
}
