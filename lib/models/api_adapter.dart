import 'dart:convert';

import 'package:wup/models/mbti_question_model.dart';

List<MbtiQuestion> parseMbtiQuestions(String reseponseBody) {
  final parsed = json.decode(reseponseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<MbtiQuestion>((json) => MbtiQuestion.fromJson(json))
      .toList();
}
