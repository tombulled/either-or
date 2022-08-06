import 'package:flutter/material.dart';

import './screens/HomeScreen.dart';

import './themes/LightTheme.dart';
import './themes/DarkTheme.dart';

import './config/Config.dart';

// Usage of setState. indentation. Upload to github + host

void main() => runApp (
	App (
		title: Config.title,
		themeMode: Config.themeMode,
	)
);

class App extends StatelessWidget {
	final String title;
	final ThemeMode themeMode;

	App ({
		this.title,
		this.themeMode,
	});

	@override
	Widget build(BuildContext context) {
		return MaterialApp (
			debugShowCheckedModeBanner: false,
			title: this.title ?? '',
			theme: LightTheme,
			darkTheme: DarkTheme,
			themeMode: this.themeMode ?? ThemeMode.system,
			home: HomeScreen(),
		);
	}
}