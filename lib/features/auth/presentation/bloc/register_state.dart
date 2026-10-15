import 'package:equatable/equatable.dart';

import '../../../../core/utils/submit_status.dart';

class RegisterState extends Equatable {
  final SubmitStatus status;
  final String? failureMessage;

  const RegisterState({this.status = SubmitStatus.idle, this.failureMessage});

  bool get isSubmitting => status == SubmitStatus.submitting;

  @override
  List<Object?> get props => [status, failureMessage];
}