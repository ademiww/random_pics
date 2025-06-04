import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dog_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => DogCubit(),
        child: DogScreen(),
      ),
    );
  }
}

class DogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dogCubit = context.read<DogCubit>();

    return Scaffold(
      appBar: AppBar(title: Text('Случайная собачка 🐶')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<DogCubit, String?>(
              builder: (context, state) {
                if (state == null) {
                  return Text('Нажми на кнопку 👇');
                } else {
                  return Image.network(state, height: 250);
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                dogCubit.fetchRandomDog();
              },
              child: Text('Показать собачку'),
            ),
          ],
        ),
      ),
    );
  }
}
