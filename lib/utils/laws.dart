import 'dart:math';

num logX(num value, num base) => log(value) / log(base);
num average(List<num> list) => list.reduce((a, b) => a + b) / list.length;
num sum(List<num> list) => list.reduce((a, b) => a + b);
String roundX(num value, int precision) => value.toStringAsFixed(precision);

abstract class Laws {
  late final List<num> xi, yi, xiXm, xiXm2, yiYm, end;
  late final double xm, ym, k1, k2;
  num get calc;
  Laws(this.xi, this.yi) {
    xm = average(xi).toDouble();
    ym = average(yi).toDouble();
    xiXm = xi.map((e) => e - xm).toList();
    xiXm2 = xiXm.map((e) => pow(e, 2)).toList();
    yiYm = yi.map((e) => e - ym).toList();
    end = <num>[];
    for (var i = 0; i < xiXm.length; i++) {
      end.add(xiXm[i] * yiYm[i]);
    }
    k2 = sum(end) / sum(xiXm2);
    k1 = ym - k2 * xm;
  }
}

class Abrams extends Laws {
  final double lfc;
  late final double lk1, lk2;
  @override
  num get calc => lfc <= 0 ? 0 : logX(lk1 / lfc, lk2);
  Abrams({
    required List<num> ac,
    required List<num> fc,
    required this.lfc,
  }) : super(ac, fc.map((e) => logX(e, 10)).toList()) {
    lk1 = pow(10, k1).toDouble();
    lk2 = pow(0.1, k2).toDouble();
  }
}

class Lyse extends Laws {
  final double lac;
  @override
  num get calc => lac <= 0 ? 0 : k2 * lac + k1;
  Lyse({
    required List<num> ac,
    required List<num> my,
    required this.lac,
  }) : super(ac, my);
}

class Molinari extends Laws {
  final double m;

  @override
  num get calc => m <= 0 ? 0 : 1000 / (k1 + k2 * m);

  Molinari._(super.xi, super.yi, this.m);

  factory Molinari({
    required List<num> massaEsp,
    required double teorArg,
    required List<num> ac,
    required List<num> my,
    required double m,
  }) {
    final a = <num>[];
    final p = <num>[];
    final cc = <num>[];
    a.addAll(my.map((value) => teorArg * (1 + value) - 1));
    for (var i = 0; i < my.length; i++) {
      p.add(my[i] - a[i]);
    }
    for (var i = 0; i < my.length; i++) {
      cc.add(1000 / (1 / massaEsp[0] + a[i] / massaEsp[1] + p[i] / massaEsp[2] + ac[i]));
    }
    return Molinari._(my, cc.map<num>((e) => 1000 / e).toList(), m);
  }


  
  // Molinari(
  //     {required List<num> massaEspec,
  //     required List<num> ac,
  //     required List<num> my,
  //     required List<num> cc,
  //     required num teorArg,
  //     required this.m})
  //     : super(my, cc) {
  //   for (var i = 0; i < 2; i++) {
  //     final a = teorArg * (1 + my[i]) - 1;
  //     final p = my[i] - a;

  // cc.add(1000 /
  //     ((1 / massaEspec[0]) +
  //         ((a / teorArg) / massaEspec[1]) +
  //         (p / massaEspec[2]) +
  //     //         ac[i]));
  //   }
  // }
}
