import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/service_repository.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository repository;

  ServiceBloc(this.repository) : super(ServiceInitial()) {
    on<LoadServicesEvent>(_onLoad);
    on<LoadMoreServicesEvent>(_onLoadMore);
    on<LoadServiceDetailEvent>(_onDetail);
  }

  Future<void> _onLoad(
      LoadServicesEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    try {
      final result = await repository.getServices(
        search: event.search,
        category: event.category,
        page: event.page,
      );
      emit(ServiceLoaded(
        services: result.data,
        total: result.total,
        hasMore: result.hasMore,
        currentPage: event.page,
        activeCategory: event.category,
        activeSearch: event.search,
      ));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
      LoadMoreServicesEvent event, Emitter<ServiceState> emit) async {
    final current = state;
    if (current is! ServiceLoaded || !current.hasMore) return;

    emit(ServiceLoadingMore(
      services: current.services,
      total: current.total,
      hasMore: current.hasMore,
      currentPage: current.currentPage,
      activeCategory: current.activeCategory,
      activeSearch: current.activeSearch,
    ));

    try {
      final result = await repository.getServices(
        search: current.activeSearch,
        category: current.activeCategory,
        page: current.currentPage + 1,
      );
      emit(ServiceLoaded(
        services: [...current.services, ...result.data],
        total: result.total,
        hasMore: result.hasMore,
        currentPage: current.currentPage + 1,
        activeCategory: current.activeCategory,
        activeSearch: current.activeSearch,
      ));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> _onDetail(
      LoadServiceDetailEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    try {
      final service = await repository.getServiceById(event.id);
      emit(ServiceDetailLoaded(service));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }
}
