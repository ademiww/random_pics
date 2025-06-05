import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dog_cubit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class DogCubit extends Cubit<String?> {
  DogCubit() : super(null);

  Future<void> fetchRandomDog() async {
    final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      emit(data['message']);
    } else {
      emit(null);
    }
  }
}


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

// ЭКРАН
class DogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dogCubit = context.read<DogCubit>();

    return BlocBuilder<DogCubit, String?>(
      builder: (context, currentImageUrl) {
        return Scaffold(
          backgroundColor: Color(0xFFFFF0F5), // светло-розовый фон
          appBar: AppBar(
            title: Text('Случайная собачка 🐶'),
            centerTitle: true,
            backgroundColor: Colors.pinkAccent,
            actions: [
              IconButton(
                icon: Icon(Icons.help_outline),
                tooltip: 'Угадай породу',
                onPressed: () {
                  if (currentImageUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Сначала покажи собаку! 🐶')),
                    );
                    return;
                  }

                  final controller = TextEditingController();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Как ты думаешь, что это за порода?'),
                        content: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Напиши породу',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              final guess = controller.text.trim().toLowerCase();
                              final isCorrect = currentImageUrl.toLowerCase().contains(guess);

                              Navigator.pop(context); // Закрыть окно ввода

                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(isCorrect ? 'Угадал 🎉' : 'Ошибся 😅'),
                                  content: Text(isCorrect
                                      ? 'Красава, это действительно "$guess"!'
                                      : 'Нет, это не "$guess"... Попробуй ещё!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Ок'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text('Проверить'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentImageUrl == null)
                  Text('Нажми на кнопку 👇', style: TextStyle(fontSize: 18))
                else
                  Image.network(currentImageUrl, height: 250),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    dogCubit.fetchRandomDog();
                  },
                  child: Text('Показать собачку'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
