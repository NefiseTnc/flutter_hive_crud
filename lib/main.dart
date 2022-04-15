import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<String>('friends');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Box<String> friendsBox;
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void initState() {
    friendsBox = Hive.box('friends');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive Crud')),
      body: Column(
        children: [
          Expanded(
              child: Center(
                  child: ValueListenableBuilder(
            valueListenable: friendsBox.listenable(),
            builder: (context, Box<String> friends, _) {
              return ListView.separated(
                itemCount: friends.keys.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  final key = friends.keys.toList()[index];
                  final value = friends.get(key);

                  return ListTile(
                    title: Text(value.toString()),
                    subtitle: Text(key),
                  );
                },
              );
            },
          ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: const Text('Create'),
                onPressed: () {
                  _buildShowDiologCreate();
                },
              ),
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () {
                  _buildShowDiologCreate();
                },
              ),
              ElevatedButton(
                child: const Text('Delete'),
                onPressed: () {
                  _buildShowDiologDelete();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> _buildShowDiologCreate() async {
    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    TextField(
                      controller: _keyController,
                      decoration: const InputDecoration(
                        label: Text('Key'),
                      ),
                    ),
                    TextField(
                      controller: _valueController,
                      decoration: const InputDecoration(
                        label: Text('Value'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        final key = _keyController.text;
                        final value = _valueController.text;

                        friendsBox.put(key, value);

                        _keyController.clear();
                        _valueController.clear();

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> _buildShowDiologDelete() async {
    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    TextField(
                      controller: _keyController,
                      decoration: const InputDecoration(
                        label: Text('Key'),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        final key = _keyController.text;
                        friendsBox.delete(key);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
