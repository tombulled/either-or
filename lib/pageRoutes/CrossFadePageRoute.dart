import 'package:flutter/material.dart';

import 'dart:math' as math;

class CrossFadePageRoute extends PageRouteBuilder {
	CrossFadePageRoute ({
		exitPage,
		enterPage,
		fadeTransitionPercent,
		transitionDuration,
	}) : super (
		transitionDuration: transitionDuration ?? Duration(milliseconds: 800),
		pageBuilder: (
			BuildContext context,
			Animation<double> animation,
			Animation<double> secondaryAnimation,
		) => enterPage,
		transitionsBuilder: (
			BuildContext context,
			Animation<double> animation,
			Animation<double> secondaryAnimation,
			Widget child,
		) {
			double fadeAllotment = (fadeTransitionPercent ?? 40) / 100;

			return Stack (
				children: <Widget>[
					Container (
						decoration: BoxDecoration (
							color: Theme.of(context).scaffoldBackgroundColor,
						),
					),
					Opacity (
						opacity: 1.0 - math.min(animation.value * (1 / fadeAllotment), 1.0),
						child: exitPage,
					),
					Opacity (
						opacity: math.max((animation.value - 1 + fadeAllotment) * (1 / fadeAllotment), 0.0),
						child: enterPage,
					),
				],
			);
		}
	);
}