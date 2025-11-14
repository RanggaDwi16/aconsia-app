import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PasienHomeRemoteDataSource {
  // Define methods related to pasien home data source here
}

class PasienHomeRemoteDataSourceImpl implements PasienHomeRemoteDataSource {
  // Implement methods related to pasien home data source here
  final FirebaseFirestore firestore;

  PasienHomeRemoteDataSourceImpl({required this.firestore});
  
}