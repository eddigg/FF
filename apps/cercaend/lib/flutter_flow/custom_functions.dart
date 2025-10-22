import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';

double sumofBagitemsListRefvalues(List<double>? refvaluefromiteminlist) {
  // sum the refvalue fields of the bagitem list
  if (refvaluefromiteminlist == null || refvaluefromiteminlist.isEmpty) {
    return 0.0;
  }

  double sum = 0.0;
  for (double value in refvaluefromiteminlist) {
    sum += value;
  }

  return sum;
}

double? averageOrderValue(
  List<double>? totalrefvalue,
  DocumentReference? user,
) {
  // create a function to calculate de average total_ref_value of a user's orders
  if (totalrefvalue == null || user == null) {
    return null;
  }

  double total = 0;
  int count = 0;

  for (double value in totalrefvalue) {
    total += value;
    count++;
  }

  if (count == 0) {
    return null;
  }

  return total / count;
}

int? averageRating(List<int>? ratings) {
  if (ratings == null || ratings.isEmpty) {
    return null;
  }
  int sum = 0;
  for (int rating in ratings) {
    sum += rating;
  }
  return (sum / ratings.length).round();
}

double? generatedcredits(
  double? generation,
  double? participation,
  double? transition,
) {
// sum the arguments
  if (generation == null || participation == null || transition == null) {
    return null;
  }

  return generation + participation + transition;
}
