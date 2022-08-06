import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../pageRoutes/CrossFadePageRoute.dart';
import './ParticlesScreen.dart';
import '../config/Config.dart';

class HomeScreen extends StatelessWidget {
	final List<Color> colours;
	final String headlineText;
	final String straplineText;
	final TextStyle headlineTextStyle;
	final TextStyle straplineTextStyle;

	HomeScreen ({
		this.colours,
		this.headlineText,
		this.straplineText,
		this.headlineTextStyle,
		this.straplineTextStyle,
	});

	@override
	Widget build(BuildContext context) {
		List<Color> colours = this.colours ?? Config.colours;
		String headlineText = this.headlineText ?? 'TAP TO';
		String straplineText = this.straplineText ?? 'START';
		TextStyle headlineTextStyle = this.headlineTextStyle ?? Theme.of(context).textTheme.headline4;
		TextStyle straplineTextStyle = this.straplineTextStyle ?? Theme.of(context).textTheme.headline4;

		return Scaffold (
			body: GestureDetector (
				behavior: HitTestBehavior.opaque,
				onTap: () {
					Navigator.of(context).pushReplacement (
						CrossFadePageRoute (
							exitPage: this,
							enterPage: ParticlesScreen(),
						)
					);
				},
				child: CustomPaint (
					foregroundPainter: HomePainter (
						colours: colours,
					),
					child: Center (
						child: Column (
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Text (
									headlineText,
									style: headlineTextStyle,
								),
								Text (
									straplineText,
									style: straplineTextStyle,
								),
							],
						),
					),
				),
			),
		);
	}
}

class HomePainter extends CustomPainter {
	List<Color> colours;

    HomePainter({List<Color> colours}) {
		this.colours = colours ?? Config.colours;
	}

    @override
    void paint(Canvas canvas, Size canvasSize) {
		Paint paint = new Paint();

        paint.strokeCap = StrokeCap.round;
        paint.style = PaintingStyle.fill;

		paint.color = this.colours[0];

        canvas.drawCircle (
			Offset (
				0,
				canvasSize.height / 2,
			),
			canvasSize.height / 6,
			paint,
		);

		paint.color = this.colours[1];

		canvas.drawCircle (
			Offset (
				canvasSize.width,
				canvasSize.height / 2,
			),
			canvasSize.height / 6,
			paint,
		);
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) => true;
}