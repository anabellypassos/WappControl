import 'package:cloud_firestore/cloud_firestore.dart';

class CONFIMODEL {
  final int users;
  final int comod;
 CONFIMODEL({
    required this.users,
    required this.comod,
    
  });

  // Construtor Factory para converter JSON em objeto Dart
  factory CONFIMODEL.fromJson(Map<String, dynamic> json) {
    return CONFIMODEL(
     users: json['users'],
      comod: json['comod'],
     
    );
  }

  // Método para converter objeto Dart em um Map
  Map<String, dynamic> toMap() {
    return {
      'comod': comod,
      'users': users,
   
    };
  }

  // Método para criar uma cópia do objeto com alterações opcionais
 CONFIMODEL copyWith({
   
    int? users,
    int? comod,
  }) {
    return CONFIMODEL(
      users: users ?? this.users,
     comod: comod ?? this.comod,
      
    );
  }
}
