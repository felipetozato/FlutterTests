import 'package:avocado_test/bloc/simple_bloc_delegate.dart';
import 'package:avocado_test/repositoryList/dart_github_repository.dart';
import 'package:avocado_test/repositoryList/dart_github_list_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localization.dart';



void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale("es"),
        const Locale("pt")
      ],
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).title,
      theme: ThemeData(
        textTheme: TextTheme(
          title: _titleTextStyle(),
          body1: _bodyTextStyle(),
          caption: _captionTextStyle(),
          subtitle: _subtitleTextStyle(),
          body2: _body2TextStyle(),
          display1: _display1TextStyle()
        ),
        primarySwatch: Colors.blue,
      ),
      home: DartGithubListPage(repository: DartGithubRepository(client: http.Client())),
    );
  }
}

TextStyle _titleTextStyle() => TextStyle(
    fontSize: 22,
    color: Color.fromRGBO(85, 128,	165, 1.0),
    fontWeight: FontWeight.bold
  );


TextStyle _bodyTextStyle() => TextStyle(
  fontSize: 18,
  color: Colors.black,
);

TextStyle _captionTextStyle() => TextStyle(
  fontSize: 18,
  color: Colors.orange,
  fontWeight: FontWeight.bold
);

TextStyle _subtitleTextStyle() => TextStyle(
  fontSize: 15,
  color: Color.fromRGBO(113,	160,	198, 1),
  fontWeight: FontWeight.bold
);

TextStyle _body2TextStyle() => TextStyle(
  fontSize: 13,
  color: Colors.grey,
);

TextStyle _display1TextStyle() => TextStyle(
  fontSize: 17,
  color: Colors.black,
  fontWeight: FontWeight.bold
);