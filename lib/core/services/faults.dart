import '../extensions/string_extensions.dart';

/// Body and status code of an HTTP response that failed.
typedef HttpFailure = ({
  Map<String, dynamic>? data,
  int? status,
  String? message,
});

/// [Fault] is a sealed class that represents a failure in the system,
/// normalizing exceptions, errors, and custom failures into one type with a
/// user-presentable [message].
///
/// Add a factory per backend SDK when one is integrated.
sealed class Fault<T> {
  const Fault._internal(this.stackTrace);
  final StackTrace stackTrace;

  factory Fault.fromObjectAndStackTrace(Object object, StackTrace stackTrace) =>
      switch (object) {
        final Exception ex => ExceptionFault(ex, stackTrace),
        final Error err => ErrorFault(err, stackTrace),
        _ => UnknownFault(object.toString(), stackTrace),
      };

  @override
  String toString() => message;
}

/// Fault produced by an HTTP call.
final class HttpFault<T> extends Fault<T> {
  final HttpFailure body;
  const HttpFault(this.body, StackTrace stackTrace)
      : super._internal(stackTrace);
}

/// Fault caused by a thrown [Exception].
final class ExceptionFault<T> extends Fault<T> {
  final Exception exception;
  const ExceptionFault(this.exception, StackTrace stackTrace)
      : super._internal(stackTrace);
}

/// Fault caused by a thrown [Error].
final class ErrorFault<T> extends Fault<T> {
  final Object error;
  const ErrorFault(this.error, StackTrace stackTrace)
      : super._internal(stackTrace);
}

/// Fault with an unknown cause.
final class UnknownFault<T> extends Fault<T> {
  final String text;
  const UnknownFault(this.text, StackTrace stackTrace)
      : super._internal(stackTrace);
}

/// Fault caused by network connectivity.
final class NetworkFault<T> extends Fault<T> {
  final String text;
  const NetworkFault(this.text, StackTrace stackTrace)
      : super._internal(stackTrace);
}

/// Fault carrying custom information of type [T].
final class CustomFault<T> extends Fault<T> {
  final T faultInfo;
  const CustomFault(this.faultInfo, StackTrace stackTrace)
      : super._internal(stackTrace);
}

/// User-presentable message for any fault.
extension FaultMessage on Fault {
  String get message => switch (this) {
        final ExceptionFault ex => ex.exception.toString().splitError,
        final ErrorFault err => err.error.toString(),
        final UnknownFault fault => fault.text,
        final CustomFault fault => fault.faultInfo.toString(),
        final NetworkFault fault => fault.text.splitError,
        final HttpFault fault => fault.body.message ?? 'Request failed',
      };
}
