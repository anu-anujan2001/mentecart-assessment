import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../../data/models/booking_model.dart';
import '../bloc/booking/booking_bloc.dart';
import '../bloc/booking/booking_event.dart';
import '../bloc/booking/booking_state.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;
  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(LoadBookingDetailEvent(widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Booking Detail'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ));
          }
        },
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.primary));
          }

          BookingModel? booking;
          if (state is BookingDetailLoaded) booking = state.booking;

          if (booking == null) {
            return const Center(
              child: Text('Booking not found',
                  style: TextStyle(color: AppTheme.textSecondary)),
            );
          }

          return _BookingDetailView(booking: booking);
        },
      ),
    );
  }
}

class _BookingDetailView extends StatelessWidget {
  final BookingModel booking;
  const _BookingDetailView({required this.booking});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo(booking.status);
    final isPaid = booking.paymentMethod != 'cash';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusInfo.$2.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusInfo.$2.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusInfo.$2.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(statusInfo.$3, color: statusInfo.$2, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(statusInfo.$1,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: statusInfo.$2)),
                      Text(statusInfo.$4,
                          style: const TextStyle(
                              fontSize: 13, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Booking ID + date
          _SectionCard(
            children: [
              _DetailRow(
                label: 'Booking ID',
                value:
                    '#${booking.id.substring(booking.id.length > 8 ? booking.id.length - 8 : 0)}',
                mono: true,
              ),
              _DetailRow(
                label: 'Booked on',
                value: _fmtDate(booking.createdAt),
              ),
              _DetailRow(
                label: 'Payment',
                value: isPaid ? 'Card (Online)' : 'Cash on Arrival',
              ),
              _DetailRow(
                label: 'Payment Status',
                value: booking.paymentStatus.toUpperCase(),
                valueColor: booking.paymentStatus == 'paid'
                    ? AppTheme.success
                    : AppTheme.warning,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Services
          const Text('Services Booked',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          ...booking.items.map((item) => _ServiceItem(item: item)),
          const SizedBox(height: 16),

          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
                Text(
                  'Rs. ${booking.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary),
                ),
              ],
            ),
          ),

          // Cancel button
          if (booking.canCancel) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  final loading = state is BookingLoading;
                  return OutlinedButton.icon(
                    onPressed: loading
                        ? null
                        : () => _confirmCancel(context, booking.id),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.error),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.cancel_outlined,
                        color: AppTheme.error, size: 20),
                    label: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: AppTheme.error, strokeWidth: 2))
                        : const Text('Cancel Booking',
                            style: TextStyle(color: AppTheme.error)),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Booking',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Are you sure you want to cancel this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookingBloc>().add(CancelBookingEvent(id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  (String, Color, IconData, String) _statusInfo(String status) =>
      switch (status) {
        'confirmed' => (
            'Confirmed',
            AppTheme.success,
            Icons.check_circle_rounded,
            'Your booking is confirmed.'
          ),
        'pending' => (
            'Pending',
            AppTheme.warning,
            Icons.hourglass_top_rounded,
            'Awaiting confirmation.'
          ),
        'completed' => (
            'Completed',
            AppTheme.accent,
            Icons.task_alt_rounded,
            'Service has been completed.'
          ),
        'cancelled' => (
            'Cancelled',
            AppTheme.error,
            Icons.cancel_rounded,
            'This booking was cancelled.'
          ),
        'failed' => (
            'Failed',
            AppTheme.error,
            Icons.error_rounded,
            'Payment or booking failed.'
          ),
        _ => (
            status,
            AppTheme.textSecondary,
            Icons.info_outline_rounded,
            ''
          ),
      };
}

class _ServiceItem extends StatelessWidget {
  final BookingItemModel item;
  const _ServiceItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final catColor = item.service != null
        ? AppTheme.categoryColor(item.service!.category)
        : AppTheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.service != null
                  ? AppTheme.categoryIcon(item.service!.category)
                  : Icons.miscellaneous_services_rounded,
              color: catColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.service?.title ?? 'Service',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 11, color: AppTheme.textLight),
                    const SizedBox(width: 4),
                    Text(item.date,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary)),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time_rounded,
                        size: 11, color: AppTheme.textLight),
                    const SizedBox(width: 4),
                    Text(item.startTime,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          Text(
            'Rs. ${(item.price * item.quantity).toStringAsFixed(0)}',
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: children
            .expand((w) => [w, if (w != children.last) const Divider(height: 16)])
            .toList(),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;
  final Color? valueColor;
  const _DetailRow({
    required this.label,
    required this.value,
    this.mono = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppTheme.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppTheme.textPrimary,
            fontFamily: mono ? 'monospace' : null,
          ),
        ),
      ],
    );
  }
}
