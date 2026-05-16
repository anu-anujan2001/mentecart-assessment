import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();
  @override
  List<Object?> get props => [];
}

class LoadServicesEvent extends ServiceEvent {
  final String? search;
  final String? category;
  final int page;
  const LoadServicesEvent({this.search, this.category, this.page = 1});
  @override
  List<Object?> get props => [search, category, page];
}

class LoadMoreServicesEvent extends ServiceEvent {}

class LoadServiceDetailEvent extends ServiceEvent {
  final String id;
  const LoadServiceDetailEvent(this.id);
  @override
  List<Object?> get props => [id];
}
