import 'package:_imagineeringwithus_pack/setup/app_base.dart';
import 'package:_imagineeringwithus_pack/setup/app_setup.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/constants/constants.dart';
import 'src/utils/utils.dart';

imagineeringwithusPackSetup() {
  AppSetup.initialized(
    value: AppSetup(
      env: AppEnv.preprod,
      appColors: AppColors.instance,
      appPrefs: AppPrefs.instance,
    ),
  );
}

const FirebaseOptions firebaseOptionsPREPROD = FirebaseOptions(
  apiKey: "AIzaSyAjBET22uyNs0rgO7eMePWUrVu-qsArkQI",
  authDomain: "imagineeringwithus-quizzes.firebaseapp.com",
  projectId: "imagineeringwithus-quizzes",
  storageBucket: "imagineeringwithus-quizzes.appspot.com",
  messagingSenderId: "558990405836",
  appId: "1:558990405836:web:b8b74f36e4e58ff1bf1269",
  measurementId: "G-D39QCYJ1E5",
);
