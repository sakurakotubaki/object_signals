import 'package:flutter/material.dart';
import 'package:object_signals/object_box.dart';
import 'package:object_signals/objectbox.g.dart';
import 'package:object_signals/user.dart';
import 'package:signals/signals_flutter.dart';

late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usersSignal = StreamSignal<List<User>>(() {
      final builder = objectbox.store.box<User>().query()
        ..order(User_.id, flags: Order.descending);
      return builder
          .watch(triggerImmediately: true)
          .map((query) => query.find());
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Signals Objectbox'),
      ),
      body: Watch((context) {
        final state = usersSignal.value;

        // エラー処理
        if (state.hasError) {
          return const Text('Something went wrong');
        }

        // ローディング処理
        if (state.isLoading) {
          return const Text('Loading');
        }

        // データ取得成功時の処理
        final snapshot = state.value;
        if (snapshot == null) {
          return const Text('No data');
        }

        return ListView(
          children: snapshot.map((document) {
            final data = document;
            return ListTile(
              trailing: IconButton(
                  onPressed: () async {
                    final userBox = objectbox.store.box<User>();
                    userBox.remove(data.id);
                  },
                  icon: const Icon(Icons.delete)),
              title: Text(data.name ?? ''),
            );
          }).toList(),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final userBox = objectbox.store.box<User>();
          final user = User(name: 'Jim');
          userBox.put(user);
          print(userBox.getAll());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
