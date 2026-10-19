const kMorse = {'A':'.-','B':'-...','C':'-.-.','D':'-..','E':'.','F':'..-.','G':'--.','H':'....','I':'..','J':'.---','K':'-.-','L':'.-..','M':'--','N':'-.','O':'---','P':'.--.','Q':'--.-','R':'.-.','S':'...','T':'-','U':'..-','V':'...-','W':'.--','X':'-..-','Y':'-.--','Z':'--..','0':'-----','1':'.----','2':'..---','3':'...--','4':'....-','5':'.....','6':'-....','7':'--...','8':'---..','9':'----.','.':'.-.-.-',',':'--..--','?':'..--..','/':'-..-.','-':'-....-'};
final kRev = {for (final e in kMorse.entries) e.value: e.key};
const kL = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', kD = '0123456789';
final kAll = [...kL.split(''), ...kD.split('')];
const kWords = ['PRAMUKA', 'SOS', 'TUNAS', 'SIAGA', 'BAKTI', 'TENDA', 'API', 'PETA'];

String toMorse(String t) => t.toUpperCase().trim().split(RegExp(r'\s+')).map((w) => w.split('').where(kMorse.containsKey).map((c) => kMorse[c]!).join(' ')).where((w) => w.isNotEmpty).join(' / ');

({String text, List<String> bad}) fromMorse(String m) {
  final bad = <String>[];
  final sb = StringBuffer();
  for (final tk in m.trim().replaceAll('/', ' / ').split(RegExp(r'\s+')).where((x) => x.isNotEmpty)) {
    if (tk == '/') {
      sb.write(' ');
    } else if (kRev.containsKey(tk)) {
      sb.write(kRev[tk]);
    } else {
      bad.add(tk);
      sb.write('?');
    }
  }
  return (text: sb.toString(), bad: bad);
}
