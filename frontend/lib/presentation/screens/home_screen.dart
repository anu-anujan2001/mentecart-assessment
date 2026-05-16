import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../../data/datasource/booking_remote_datasource.dart';
import '../../data/datasource/cart_remote_datasource.dart';
import '../../data/datasource/service_remote_datasource.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../bloc/booking/booking_bloc.dart';
import '../bloc/booking/booking_event.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../bloc/service/service_bloc.dart';
import '../bloc/service/service_event.dart';
import 'bookings_screen.dart';
import 'cart_screen.dart';
import 'services_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _serviceBloc = ServiceBloc(
    ServiceRepository(ServiceRemoteDatasource()),
  );
  final _cartBloc = CartBloc(
    CartRepository(CartRemoteDatasource()),
  );
  final _bookingBloc = BookingBloc(
    BookingRepository(BookingRemoteDatasource()),
  );

  static const _titles = ['Services', 'My Cart', 'Bookings'];

  @override
  void initState() {
    super.initState();
    _serviceBloc.add(const LoadServicesEvent());
    _cartBloc.add(LoadCartEvent());
  }

  @override
  void dispose() {
    _serviceBloc.close();
    _cartBloc.close();
    _bookingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _serviceBloc),
        BlocProvider.value(value: _cartBloc),
        BlocProvider.value(value: _bookingBloc),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.surface,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: _AppBar(
            currentIndex: _currentIndex,
            titles: _titles,
            onCartTap: () => setState(() => _currentIndex = 1),
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            ServicesScreen(),
            CartScreen(),
            BookingsScreen(),
          ],
        ),
        bottomNavigationBar: _BottomNav(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() => _currentIndex = i);
            if (i == 1) _cartBloc.add(LoadCartEvent());
            if (i == 2) _bookingBloc.add(LoadBookingsEvent());
          },
        ),
      ),
    );
  }
}

// ── App Bar ──────────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final int currentIndex;
  final List<String> titles;
  final VoidCallback onCartTap;
  const _AppBar(
      {required this.currentIndex,
      required this.titles,
      required this.onCartTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // Logo
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF9F97FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.shopping_cart_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                titles[currentIndex],
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5),
              ),
              const Spacer(),
              // Cart badge (only on non-cart tabs)
              if (currentIndex != 1)
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    int count = 0;
                    if (state is CartLoaded) count = state.cart.itemCount;
                    if (state is CartOperationSuccess) {
                      count = state.cart.itemCount;
                    }
                    return GestureDetector(
                      onTap: onCartTap,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(Icons.shopping_cart_outlined,
                                  color: AppTheme.primary, size: 20),
                            ),
                            if (count > 0)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      count > 9 ? '9+' : '$count',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom Nav ───────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.divider, width: 1)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Bookings',
          ),
        ],
      ),
    );
  }
}
