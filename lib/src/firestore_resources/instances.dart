import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'constants.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

CollectionReference get colLangs => _firestore.collection(kdb_languages);
CollectionReference get colSubjects => _firestore.collection(kdb_subjects);
CollectionReference get colQuizs => _firestore.collection(kdb_quizs);
CollectionReference get colGallery => _firestore.collection(kdb_gallery);

final _storage = FirebaseStorage.instance;
Reference refByUrl(String url) => _storage.refFromURL(url);
Reference get refGalleryImages => _storage.ref().child('gallery/images/');
