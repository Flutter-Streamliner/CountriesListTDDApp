import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Country extends Equatable {

  final String name;
  final String capital;
  final String code;

  Country({
    @required this.name,
    @required this.capital,
    @required this.code
  });

  @override
  List<Object> get props => [name, capital, code];

}