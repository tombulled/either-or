import 'package:flutter/material.dart';

class SwitchPageRoute extends PageRouteBuilder {
	SwitchPageRoute({page}) : super (
		transitionDuration: Duration(milliseconds: 0),
		pageBuilder: (
			BuildContext context,
			Animation<double> animation,
			Animation<double> secondaryAnimation,
		) => page,
		transitionsBuilder: (
			BuildContext context,
			Animation<double> animation,
			Animation<double> secondaryAnimation,
			Widget child,
		) => child,
	);
}