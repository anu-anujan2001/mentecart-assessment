import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../../data/models/booking_model.dart';
import '../bloc/booking/booking_bloc.dart';
import '../bloc/booking/booking_event.dart';
import '../bloc/booking/booking_state.dart';
import 'booking_detail_screen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(LoadBookingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary));
        }
        if (state is BookingError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 48, color: AppTheme.textLight),
                const SizedBox(height: 12),
                Text(state.message,
                    style:
                        const TextStyle(color: AppTheme.textSecondary)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context
                      .read<BookingBloc>()
                      .add(LoadBookingsEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (state is BookingsLoaded) {
          if (state.bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_rounded,
                        size: 44, color: AppTheme.accent),
                  ),
                  const SizedBox(height: 20),
                  const Text('No bookings yet',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  const SizedBox(height: 8),
                  const Text('Your booked services will appear here',
                      style:
                          TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () async => context
                .read<BookingBloc>()
                .add(LoadBookingsEvent()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _BookingCard(
                booking: state.bookings[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<BookingBloc>(),
                      child: BookingDetailScreen(
                          bookingId: state.bookings[i].id),
                    ),
                  ),
                ).then((_) => context
                    .read<BookingBloc>()
                    .add(LoadBookingsEvent())),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;
  const _BookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo(booking.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.items.isNotEmpty
                        ? (booking.items.first.service?.title ??
                            'Booking')
                        : 'Booking',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusInfo.$2.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(statusInfo.$1,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusInfo.$2)),
                ),
              ],
            ),
            if (booking.items.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                    '+${booking.items.length - 1} more service(s)',
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary)),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MetaItem(
                    icon: Icons.calendar_today_rounded,
                    label: _fmtDate(booking.createdAt)),
                const SizedBox(width: 16),
                _MetaItem(
                    icon: Icons.payment_rounded,
                    label: booking.paymentMethod == 'cash'
                        ? 'Cash'
                        : 'Card'),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${booking.items.length} item(s)',
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.textSecondary)),
                Text(
                  'Rs. ${booking.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day} ${_months[d.month]} ${d.year}';

  static const _months = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  (String, Color) _statusInfo(String status) => switch (status) {
        'confirmed' => ('Confirmed', AppTheme.success),
        'pending' => ('Pending', AppTheme.warning),
        'completed' => ('Completed', AppTheme.accent),
        'cancelled' => ('Cancelled', AppTheme.error),
        'failed' => ('Failed', AppTheme.error),
        _ => (status, AppTheme.textSecondary),
      };
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppTheme.textLight),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}
