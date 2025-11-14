import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PasienKontenRemoteDataSource {
  // Define methods related to pasien konten remote data source here
}

class PasienKontenRemoteDataSourceImpl implements PasienKontenRemoteDataSource {
  // Implement methods related to pasien konten remote data source here
  final FirebaseFirestore firestore;

  PasienKontenRemoteDataSourceImpl({required this.firestore});
}
