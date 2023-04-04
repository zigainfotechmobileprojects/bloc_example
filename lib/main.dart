import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
          create: (_) => PersonsBloc(),
          child: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
               if (await checkInternetConnection()) {
                context
                    .read<PersonsBloc>()
                    .add(LoadPersonAction(url: PersonUrl.person1));
              } else {
                context.read<PersonsBloc>().add(NetworkErrorAction());
              }
            },
            child: Text(
              "Load json #1",
            ),
          ),
          TextButton(
            onPressed: () async {
              if (await checkInternetConnection()) {
                context
                    .read<PersonsBloc>()
                    .add(LoadPersonAction(url: PersonUrl.person2));
              } else {
                context.read<PersonsBloc>().add(NetworkErrorAction());
              }
            },
            child: Text(
              "Load json #2",
            ),
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previousResult, currentResult) {
              return previousResult?.persons != currentResult?.persons;
            },
            builder: (context, fetchResult) {
              final persons = fetchResult?.persons;
              if (persons == null) {
                return SizedBox();
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${fetchResult!.isRetrievedFromCache}"),
                  fetchResult.isNetworkErr
                      ? Text("Network Error")
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: persons.length,
                          itemBuilder: (context, index) {
                            final person = persons[index]!;

                            return ListTile(title: Text(person.name));
                          },
                        ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}





enum PersonUrl { person1, person2 }

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return "http://127.0.0.1:5500/api/person1.json";
      case PersonUrl.person2:
        return "http://127.0.0.1:5500/api/person2.json";
    }
  }
}



extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}



Future<Iterable<Persons>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Persons.fromJson(e)));

void masin() {
  Stringss a = Stringss("a");
  print(a.add("a"));
}

abstract class AddFunction {
  add(var a) {}
}

class Stringss extends AddFunction {
  final String value;
  Stringss(this.value);

  @override
  add(var a) {
    return value + a;
  }
}

class Intss extends AddFunction {
  final int value;
  Intss(this.value);

  @override
  add(var a) {
    return value + a;
  }
}

class RunApp extends AddFunction {
  adds(var value) {}
}

Future<bool> checkInternetConnection() async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
    print('YAY! Free cute dog pics!');
  } else {
    print('No internet :( Reason:');
    print(InternetConnectionChecker().connectionStatus);
  }
  return result;
}
