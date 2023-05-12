import 'package:flutter/material.dart';

class NavegationBar extends StatelessWidget {
  const NavegationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Colors.transparent,
      child: Stack(
        children: [
          CustomPaint(
            size:
                Size(size.width, (size.width * 0.15217391304347824).toDouble()),
            painter: BNBCustomPainter(
                color: Theme.of(context).colorScheme.background),
          ),
          Center(
            heightFactor: 0.4,
            child: SizedBox(
              width: 70,
              height: 50,
              child: FloatingActionButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 0.1,
                foregroundColor: Theme.of(context).colorScheme.background,
                child: const Icon(Icons.add, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  const BNBCustomPainter({
    required this.color,
  });
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9901087, size.height * 0.09416667);
    path_0.cubicTo(
        size.width * 0.9795833,
        size.height * 0.02500000,
        size.width * 0.9665580,
        size.height * 0.02333333,
        size.width * 0.9640942,
        size.height * 0.02333333);
    path_0.cubicTo(
        size.width * 0.9199638,
        size.height * 0.08702381,
        size.width * 0.8625906,
        size.height * 0.1416667,
        size.width * 0.7955254,
        size.height * 0.1341667);
    path_0.cubicTo(
        size.width * 0.7379891,
        size.height * 0.1277381,
        size.width * 0.6882065,
        size.height * 0.07714286,
        size.width * 0.6484058,
        size.height * 0.01833333);
    path_0.cubicTo(
        size.width * 0.6426993,
        size.height * 0.008214286,
        size.width * 0.6348913,
        size.height * 0.001190476,
        size.width * 0.6300181,
        size.height * 0.02845238);
    path_0.cubicTo(
        size.width * 0.6246920,
        size.height * 0.05821429,
        size.width * 0.6257971,
        size.height * 0.1136905,
        size.width * 0.6269565,
        size.height * 0.2373810);
    path_0.cubicTo(
        size.width * 0.6274638,
        size.height * 0.2914286,
        size.width * 0.6281159,
        size.height * 0.3736905,
        size.width * 0.6284964,
        size.height * 0.4765476);
    path_0.cubicTo(
        size.width * 0.6286413,
        size.height * 0.4888095,
        size.width * 0.6294928,
        size.height * 0.5779762,
        size.width * 0.6188587,
        size.height * 0.6459524);
    path_0.cubicTo(
        size.width * 0.6088949,
        size.height * 0.7097619,
        size.width * 0.5993841,
        size.height * 0.7041667,
        size.width * 0.5934420,
        size.height * 0.7055952);
    path_0.cubicTo(
        size.width * 0.5621558,
        size.height * 0.7055952,
        size.width * 0.5318297,
        size.height * 0.7055952,
        size.width * 0.5005435,
        size.height * 0.7055952);
    path_0.cubicTo(
        size.width * 0.4692572,
        size.height * 0.7055952,
        size.width * 0.4389312,
        size.height * 0.7055952,
        size.width * 0.4076449,
        size.height * 0.7055952);
    path_0.cubicTo(
        size.width * 0.4017029,
        size.height * 0.7041667,
        size.width * 0.3921920,
        size.height * 0.7096429,
        size.width * 0.3822283,
        size.height * 0.6459524);
    path_0.cubicTo(
        size.width * 0.3715942,
        size.height * 0.5779762,
        size.width * 0.3724275,
        size.height * 0.4886905,
        size.width * 0.3725906,
        size.height * 0.4765476);
    path_0.cubicTo(
        size.width * 0.3729529,
        size.height * 0.3736905,
        size.width * 0.3736232,
        size.height * 0.2914286,
        size.width * 0.3741304,
        size.height * 0.2373810);
    path_0.cubicTo(
        size.width * 0.3752899,
        size.height * 0.1136905,
        size.width * 0.3763949,
        size.height * 0.05821429,
        size.width * 0.3710688,
        size.height * 0.02845238);
    path_0.cubicTo(
        size.width * 0.3661775,
        size.height * 0.001190476,
        size.width * 0.3583877,
        size.height * 0.008333333,
        size.width * 0.3526812,
        size.height * 0.01833333);
    path_0.cubicTo(
        size.width * 0.3128804,
        size.height * 0.07714286,
        size.width * 0.2630978,
        size.height * 0.1276190,
        size.width * 0.2055616,
        size.height * 0.1341667);
    path_0.cubicTo(
        size.width * 0.1384601,
        size.height * 0.1416667,
        size.width * 0.08108696,
        size.height * 0.08714286,
        size.width * 0.03695652,
        size.height * 0.02345238);
    path_0.cubicTo(
        size.width * 0.03451087,
        size.height * 0.02345238,
        size.width * 0.02148551,
        size.height * 0.02511905,
        size.width * 0.01094203,
        size.height * 0.09428571);
    path_0.cubicTo(
        size.width * 0.004293478,
        size.height * 0.1379762,
        size.width * 0.0001630435,
        size.height * 0.1984524,
        size.width * 0.0001630435,
        size.height * 0.2652381);
    path_0.lineTo(size.width * 0.0001630435, size.height * 1.010476);
    path_0.lineTo(size.width * 0.5005254, size.height * 1.010476);
    path_0.lineTo(size.width * 1.000888, size.height * 1.010476);
    path_0.lineTo(size.width * 1.000888, size.height * 0.2652381);
    path_0.cubicTo(
        size.width * 1.000888,
        size.height * 0.1983333,
        size.width * 0.9967754,
        size.height * 0.1379762,
        size.width * 0.9901087,
        size.height * 0.09416667);
    path_0.close();
    canvas.drawShadow(path_0, Colors.black, 10, true);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
