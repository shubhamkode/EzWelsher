import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AsyncState<T> extends Equatable {
  final bool? isLoading;
  final T? data;
  final String? errMsg;

  const AsyncState({
    this.isLoading,
    this.data,
    this.errMsg,
  });

  Widget when({
    required Widget Function() onLoading,
    required Widget Function(String errMsg) onErr,
    required Widget Function(T data) onData,
  });
}

class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading({
    super.isLoading = true,
  });

  @override
  Widget when({
    required Widget Function() onLoading,
    Widget Function(String errMsg)? onErr,
    Widget Function(T data)? onData,
  }) {
    return onLoading();
  }

  @override
  List<Object?> get props => [isLoading!];
}

class AsyncValue<T> extends AsyncState<T> {
  const AsyncValue({
    required super.data,
    super.isLoading = false,
  });

  @override
  List<Object?> get props => [data!];

  @override
  Widget when({
    Widget Function()? onLoading,
    Widget Function(String errMsg)? onErr,
    required Widget Function(T data) onData,
  }) {
    if (data == null) {
      return onLoading!();
    }
    return onData(data!);
  }
}

class AsyncError<T> extends AsyncState<T> {
  const AsyncError({
    required super.errMsg,
    super.isLoading = false,
  });

  @override
  List<Object?> get props => [data!];

  @override
  Widget when({
    Widget Function()? onLoading,
    required Widget Function(String errMsg) onErr,
    Widget Function(T data)? onData,
  }) {
    return onErr(
      errMsg!,
    );
  }
}
