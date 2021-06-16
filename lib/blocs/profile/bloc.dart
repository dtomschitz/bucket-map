library blocs.profile;

import 'dart:async';

import 'package:bucket_map/core/auth/repositories/repositories.dart';
import 'package:bucket_map/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_bloc.dart';
part 'profile_events.dart';
part 'profile_repository.dart';
part 'profile_state.dart';
