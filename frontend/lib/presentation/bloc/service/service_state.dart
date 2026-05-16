import 'package:equatable/equatable.dart';
import '../../../data/models/service_model.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();
  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<ServiceModel> services;
  final int total;
  final bool hasMore;
  final int currentPage;
  final String? activeCategory;
  final String? activeSearch;

  const ServiceLoaded({
    required this.services,
    required this.total,
    required this.hasMore,
    required this.currentPage,
    this.activeCategory,
    this.activeSearch,
  });

  @override
  List<Object?> get props =>
      [services, total, hasMore, currentPage, activeCategory, activeSearch];
}

class ServiceLoadingMore extends ServiceLoaded {
  const ServiceLoadingMore({
    required super.services,
    required super.total,
    required super.hasMore,
    required super.currentPage,
    super.activeCategory,
    super.activeSearch,
  });
}

class ServiceDetailLoaded extends ServiceState {
  final ServiceModel service;
  const ServiceDetailLoaded(this.service);
  @override
  List<Object?> get props => [service];
}

class ServiceError extends ServiceState {
  final String message;
  const ServiceError(this.message);
  @override
  List<Object?> get props => [message];
}
