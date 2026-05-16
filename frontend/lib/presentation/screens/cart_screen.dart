import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../../data/models/cart_model.dart';
import '../bloc/booking/booking_bloc.dart';
import '../bloc/booking/booking_event.dart';
import '../bloc/booking/booking_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import 'booking_confirmation_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          context.read<CartBloc>().add(LoadCartEvent());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingConfirmationScreen(
                  booking: state.booking),
            ),
          );
        }
        if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(children: [
              const Icon(Icons.error_outline_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(state.message)),
            ]),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ));
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.primary, strokeWidth: 2.5));
          }

          CartModel? cart;
          if (state is CartLoaded) cart = state.cart;
          if (state is CartOperationSuccess) cart = state.cart;
          if (state is CartError) {
            return _ErrorView(
              onRetry: () =>
                  context.read<CartBloc>().add(LoadCartEvent()),
            );
          }

          if (cart == null || cart.items.isEmpty) {
            return const _EmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppTheme.primary,
                  onRefresh: () async =>
                      context.read<CartBloc>().add(LoadCartEvent()),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    itemCount: cart!.items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (_, i) =>
                        _CartItemCard(item: cart!.items[i]),
                  ),
                ),
              ),
              _OrderSummary(cart: cart),
            ],
          );
        },
      ),
    );
  }
}

// ── Order Summary / Checkout ─────────────────────────────────────────────────
class _OrderSummary extends StatelessWidget {
  final CartModel cart;
  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppTheme.divider, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Summary rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${cart.itemCount} service(s)',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13)),
              Text('Rs. ${cart.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppTheme.divider),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary)),
              Text(
                'Rs. ${cart.total.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<BookingBloc, BookingState>(
            builder: (ctx, bookingState) {
              final loading = bookingState is BookingLoading;
              return Row(
                children: [
                  // Pay on Arrival
                  Expanded(
                    child: _CheckoutButton(
                      label: 'Pay on Arrival',
                      icon: Icons.payments_outlined,
                      outlined: true,
                      loading: loading,
                      onPressed: () =>
                          ctx.read<BookingBloc>().add(CheckoutEvent('cash')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Pay Now
                  Expanded(
                    child: _CheckoutButton(
                      label: 'Pay Now',
                      icon: Icons.credit_card_rounded,
                      loading: loading,
                      onPressed: () =>
                          ctx.read<BookingBloc>().add(CheckoutEvent('card')),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool outlined;
  final bool loading;
  final VoidCallback onPressed;

  const _CheckoutButton({
    required this.label,
    required this.icon,
    this.outlined = false,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        height: 50,
        child: OutlinedButton.icon(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.primary, width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13)),
            padding: EdgeInsets.zero,
          ),
          icon: Icon(icon, size: 16, color: AppTheme.primary),
          label: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary)),
        ),
      );
    }
    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: loading
              ? null
              : const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF9F97FF)]),
          color: loading ? AppTheme.primary.withOpacity(0.5) : null,
          borderRadius: BorderRadius.circular(13),
        ),
        child: ElevatedButton.icon(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13)),
            padding: EdgeInsets.zero,
          ),
          icon: loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Icon(icon, size: 16, color: Colors.white),
          label: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ),
      ),
    );
  }
}

// ── Cart Item Card ───────────────────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final service = item.service;
    final catColor = service != null
        ? AppTheme.categoryColor(service.category)
        : AppTheme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  catColor.withOpacity(0.15),
                  catColor.withOpacity(0.05)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: service != null
                ? Icon(AppTheme.categoryIcon(service.category),
                    color: catColor, size: 24)
                : const Icon(Icons.miscellaneous_services_rounded,
                    color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service?.title ?? 'Service',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 11, color: AppTheme.textLight),
                    const SizedBox(width: 4),
                    Text(item.date,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time_rounded,
                        size: 11, color: AppTheme.textLight),
                    const SizedBox(width: 4),
                    Text(item.startTime,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Rs. ${item.subtotal.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Controls
          Column(
            children: [
              GestureDetector(
                onTap: () =>
                    context.read<CartBloc>().add(RemoveCartItemEvent(item.id)),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      color: AppTheme.error, size: 16),
                ),
              ),
              const SizedBox(height: 8),
              // Qty stepper
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.divider, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepBtn(
                      icon: Icons.remove_rounded,
                      enabled: item.quantity > 1,
                      onTap: item.quantity > 1
                          ? () => context.read<CartBloc>().add(
                              UpdateCartItemEvent(
                                  itemId: item.id,
                                  quantity: item.quantity - 1))
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${item.quantity}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary)),
                    ),
                    _StepBtn(
                      icon: Icons.add_rounded,
                      enabled: true,
                      onTap: () => context.read<CartBloc>().add(
                          UpdateCartItemEvent(
                              itemId: item.id,
                              quantity: item.quantity + 1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;
  const _StepBtn(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(icon,
            size: 14,
            color:
                enabled ? AppTheme.textPrimary : AppTheme.textLight),
      ),
    );
  }
}

// ── Empty & Error States ─────────────────────────────────────────────────────
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.1),
                    AppTheme.primary.withOpacity(0.05)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_cart_outlined,
                  size: 44, color: AppTheme.primary),
            ),
            const SizedBox(height: 24),
            const Text('Your cart is empty',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5)),
            const SizedBox(height: 8),
            const Text('Browse our services and add them here',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 48, color: AppTheme.textLight),
          const SizedBox(height: 12),
          const Text('Failed to load cart',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
