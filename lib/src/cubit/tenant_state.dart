part of 'tenant_cubit.dart';

class TenantState {
  final bool? isLoading;
  final Tenant? tenant;
  final String? errorMsg;

  TenantState({
    this.isLoading = true,
    this.tenant,
    this.errorMsg,
  });

  factory TenantState.loading() => TenantState(isLoading: true);

  factory TenantState.loaded({
    required Tenant tenant,
  }) =>
      TenantState(
        isLoading: false,
        tenant: tenant,
      );

  factory TenantState.error({required String errorMsg}) => TenantState(
        isLoading: false,
        errorMsg: errorMsg,
      );
}

@immutable
sealed class TenantCubitState {}

final class TenantCubitLoading extends TenantCubitState {}

final class TenantCubitLoaded extends TenantCubitState {
  final Tenant tenant;

  TenantCubitLoaded({required this.tenant});
}
