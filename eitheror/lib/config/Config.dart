import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ConfigData {
	List<Color> colours;
	ThemeMode themeMode;
	String title;

	ConfigData ({
		this.colours,
		this.themeMode,
		this.title,
	});
}

ConfigData ConfigBlueRedDark = ConfigData (
	colours: [
		CupertinoColors.systemRed,
		CupertinoColors.systemTeal,
	],
	themeMode: ThemeMode.dark,
	title: 'EitherOr',
);

ConfigData ConfigOrangeGreenDark = ConfigData (
	colours: [
		Colors.orange,
		Colors.green,
	],
	themeMode: ThemeMode.dark,
	title: 'EitherOr',
);

ConfigData ConfigPinkBlueDark = ConfigData (
	colours: [
		Colors.pink,
		Colors.lightBlue,
	],
	themeMode: ThemeMode.dark,
	title: 'EitherOr',
);

ConfigData Config = ConfigBlueRedDark;