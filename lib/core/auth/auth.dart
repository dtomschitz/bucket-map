library core.auth;

import 'dart:ui';
import 'dart:async';

import 'package:bucket_map/core/core.dart';
import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/shared/shared.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';

part 'auth_repository.dart';
part 'login.dart';
part 'register.dart';
