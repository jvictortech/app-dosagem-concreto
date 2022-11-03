import 'package:app_engenharia/utils/activator.dart';
import 'package:flutter/material.dart';

import '../utils/number_formatter.dart';

class InputNumbers extends StatelessWidget {
  final String title;
  final InputNumbersController? controller;
  InputNumbers({
    Key? key,
    this.title = '',
    this.controller,
  }) : super(key: key);

  final v1 = TextEditingController();
  final v2 = TextEditingController();
  final v3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller?._input = this;
    const sizedBox = SizedBox(height: 12);
    final formatter = NumberFormatter();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
            sizedBox,
            TextFormField(
              controller: v1,
              textAlign: TextAlign.center,
              inputFormatters: [
                formatter,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller?._check(),
            ),
            sizedBox,
            TextFormField(
              controller: v2,
              textAlign: TextAlign.center,
              inputFormatters: [
                formatter,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller?._check(),
            ),
            sizedBox,
            TextFormField(
              controller: v3,
              textAlign: TextAlign.center,
              inputFormatters: [
                formatter,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller?._check(),
            ),
          ],
        ),
      ),
    );
  }
}

class InputNumbersController extends ValueNotifier<bool> {
  InputNumbers? _input;

  InputNumbersController() : super(false);

  TextEditingController? get v1 => _input?.v1;
  TextEditingController? get v2 => _input?.v2;
  TextEditingController? get v3 => _input?.v3;
  List<num>? get listNumbers {
    if (value) {
      final v1 = convert(_input!.v1.text);
      final v2 = convert(_input!.v2.text);
      final v3 = convert(_input!.v3.text);
      return <num>[v1!, v2!, v3!];
    }
    return null;
  }

  void _check() {
    final v1 = _input?.v1.text.isNotEmpty ?? false;
    final v2 = _input?.v2.text.isNotEmpty ?? false;
    final v3 = _input?.v3.text.isNotEmpty ?? false;
    value = v1 && v2 && v3;
  }
}
