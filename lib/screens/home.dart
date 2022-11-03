import 'package:flutter/material.dart';

import '../utils/activator.dart';
import '../utils/laws.dart';
import '../utils/number_formatter.dart';
import '../widgets/input_numbers.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final res = ValueNotifier<String>('');
    final textController1 = TextEditingController();
    final textController2 = TextEditingController();
    final controller1 = InputNumbersController();
    final controller2 = InputNumbersController();
    final controller3 = InputNumbersController();
    final controller4 = InputNumbersController();
    final ativar = Activator(list: [
      textController1,
      textController2,
      controller1,
      controller2,
      controller3,
      controller4,
    ]);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Leis de Dosagem'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                InputNumbers(
                  controller: controller1,
                  title: 'a/c',
                ),
                InputNumbers(
                  controller: controller2,
                  title: 'Fc (Mpa)',
                ),
                InputNumbers(
                  controller: controller3,
                  title: 'm (y)',
                ),
                InputNumbers(
                  controller: controller4,
                  title: 'g/cm³',
                ),
              ],
            ),
            SizedBox(
              width: 350,
              child: TextFormField(
                controller: textController1,
                inputFormatters: [
                  NumberFormatter(),
                ],
                decoration: const InputDecoration(
                  // prefixIcon: Icon(Icons.pin_rounded),
                  border: OutlineInputBorder(),
                  label: Text('Fc'),
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            SizedBox(
              width: 350,
              child: TextFormField(
                controller: textController2,
                inputFormatters: [
                  NumberFormatter(),
                ],
                decoration: const InputDecoration(
                  // prefixIcon: Icon(Icons.pin_rounded),
                  border: OutlineInputBorder(),
                  label: Text('Teor de Argamassa'),
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: ativar,
              child: const Text(
                'Calcular',
                style: TextStyle(
                  fontSize: 38,
                ),
              ),
              builder: (context, value, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 80),
                  ),
                  onPressed: value
                      ? () {
                          final listaAc = controller1.listNumbers;
                          final listaFc = controller2.listNumbers;
                          final listaMy = controller3.listNumbers;
                          final listaMe = controller4.listNumbers;
                          final fcValue = convert(textController1.text);

                          if (fcValue != null &&
                              listaAc != null &&
                              listaFc != null &&
                              listaMy != null) {
                            final abrams = Abrams(
                              ac: listaAc,
                              fc: listaFc,
                              lfc: fcValue,
                            ).calc;
                            final lyse = Lyse(
                              ac: listaAc,
                              my: listaMy,
                              lac: abrams.toDouble(),
                            ).calc;
                            final molinari = Molinari(
                                    massaEsp: listaMe!,
                                    teorArg: double.parse(textController2.text.replaceFirst(',', '.')),
                                    ac: listaAc,
                                    my: listaMy,
                                    m: lyse.toDouble())
                                .calc;
                            res.value =
                                'Abrams: ${roundX(abrams, 3)}\nLyse: ${roundX(lyse, 3)}\nMolinari: ${roundX(molinari, 3)}';
                          }
                        }
                      : null,
                  child: child,
                );
              },
            ),
            const SizedBox(
              height: 35,
            ),
            ValueListenableBuilder<String>(
              valueListenable: res,
              builder: (context, value, child) {
                return Text(
                  value,
                  style: const TextStyle(
                    fontSize: 58,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
