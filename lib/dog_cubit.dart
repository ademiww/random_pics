import 'package:flutter_bloc/flutter_bloc.dart';
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