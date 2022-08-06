import 'package:flutter/material.dart';
import 'dart:async' as async;

import '../pageRoutes/CrossFadePageRoute.dart';
import './HomeScreen.dart';

class ResultScreen extends StatefulWidget {
	final Color colour;
	final String message;

	ResultScreen ({
		Key key,
		this.colour,
		this.message,
	}) : super(key: key);

	@override
    ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
    Color colour;
	String message;

	double labelOpacity = 0.0;

    @override
    void initState() {
        super.initState();

		this.colour = widget.colour ?? Colors.grey;
		this.message = widget.message ?? 'AGAIN';

		async.Timer(Duration(milliseconds: 100), () {
			setState(() {
				this.labelOpacity = 1.0;
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold (
			body: GestureDetector (
				behavior: HitTestBehavior.opaque,
				onTap: () {
					Navigator.of(context).pushReplacement (
						CrossFadePageRoute (
							exitPage: widget,
							enterPage: HomeScreen(),
						)
					);
				},
				child: Container (
					decoration: BoxDecoration (
						color: this.colour,
					),
					child: Center (
						child: AnimatedOpacity (
							opacity: this.labelOpacity,
							duration: Duration(milliseconds: 300),
							child: Text (
								this.message,
								style: Theme.of(context).textTheme.headline4.copyWith (
									color: Colors.white,
								),
							),
						),
					)
				),
			),
		);
	}
}