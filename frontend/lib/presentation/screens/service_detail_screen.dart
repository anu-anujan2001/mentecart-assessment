import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../../data/models/service_model.dart';
import '../../data/models/slot_model.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  String? _selectedDate;
  SlotModel? _selectedSlot;

  List<String> get _dates => widget.service.availableDates;
  List<SlotModel> get _slotsForDate =>
      _selectedDate != null
          ? widget.service.slotsForDate(_selectedDate!)
          : [];

  String _formatDate(String d) {
    final parts = d.split('-');
    if (parts.length != 3) return d;
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
    final month = int.tryParse(parts[1]) ?? 0;
    final day = parts[2].padLeft(2, '0');
    return '$day\n${months[month]}';
  }

  @override
  Widget build(BuildContext context) {
    final catColor = AppTheme.categoryColor(widget.service.category);

    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(state.message ?? 'Added to cart!'),
            ]),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ));
        }
        if (state is CartError) {
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ));
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.surface,
        body: CustomScrollView(
          slivers: [
            // Hero App Bar
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: AppTheme.textPrimary, size: 20),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.service.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: catColor.withOpacity(0.1),
                        child: Center(
                          child: Icon(
                              AppTheme.categoryIcon(widget.service.category),
                              color: catColor,
                              size: 72),
                        ),
                      ),
                    ),
                    // Bottom gradient
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service title & price
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: catColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                            AppTheme.categoryIcon(
                                                widget.service.category),
                                            size: 12,
                                            color: catColor),
                                        const SizedBox(width: 5),
                                        Text(widget.service.category,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: catColor)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(widget.service.title,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.textPrimary,
                                          letterSpacing: -0.5,
                                          height: 1.2)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Rs. ${widget.service.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.primary),
                                ),
                                const Text('per slot',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textLight)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Chips row
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.schedule_rounded,
                              label: '${widget.service.duration} min',
                            ),
                            const SizedBox(width: 8),
                            _InfoChip(
                              icon: Icons.group_rounded,
                              label:
                                  '${widget.service.capacityPerSlot} per slot',
                            ),
                            const SizedBox(width: 8),
                            _InfoChip(
                              icon: Icons.calendar_month_rounded,
                              label:
                                  '${widget.service.availableDates.length} dates',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Text(widget.service.description,
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                height: 1.65)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Date picker
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                            icon: Icons.calendar_today_rounded,
                            title: 'Select Date'),
                        const SizedBox(height: 14),
                        if (_dates.isEmpty)
                          _NoAvailability(
                              message: 'No available dates for this service')
                        else
                          SizedBox(
                            height: 72,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _dates.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (_, i) {
                                final date = _dates[i];
                                final selected = _selectedDate == date;
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    _selectedDate = date;
                                    _selectedSlot = null;
                                  }),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 180),
                                    width: 58,
                                    decoration: BoxDecoration(
                                      gradient: selected
                                          ? const LinearGradient(
                                              colors: [
                                                AppTheme.primary,
                                                Color(0xFF9F97FF)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )
                                          : null,
                                      color: selected ? null : Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      border: Border.all(
                                          color: selected
                                              ? AppTheme.primary
                                              : AppTheme.divider,
                                          width: 1.5),
                                      boxShadow: selected
                                          ? [
                                              BoxShadow(
                                                color: AppTheme.primary
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _formatDate(date),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: selected
                                              ? Colors.white
                                              : AppTheme.textPrimary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Time slot picker
                  if (_selectedDate != null)
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                              icon: Icons.access_time_rounded,
                              title: 'Select Time Slot'),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _slotsForDate.map((slot) {
                              final selected = _selectedSlot == slot;
                              final available = slot.isAvailable;
                              return GestureDetector(
                                onTap: available
                                    ? () =>
                                        setState(() => _selectedSlot = slot)
                                    : null,
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: selected
                                        ? const LinearGradient(
                                            colors: [
                                              AppTheme.primary,
                                              Color(0xFF9F97FF)
                                            ],
                                          )
                                        : null,
                                    color: !available
                                        ? AppTheme.surface
                                        : selected
                                            ? null
                                            : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    border: Border.all(
                                      color: !available
                                          ? AppTheme.divider
                                          : selected
                                              ? AppTheme.primary
                                              : AppTheme.divider,
                                      width: 1.5,
                                    ),
                                    boxShadow: selected
                                        ? [
                                            BoxShadow(
                                              color: AppTheme.primary
                                                  .withOpacity(0.25),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        slot.displayTime,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: !available
                                              ? AppTheme.textLight
                                              : selected
                                                  ? Colors.white
                                                  : AppTheme.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: !available
                                              ? AppTheme.errorLight
                                              : selected
                                                  ? Colors.white
                                                      .withOpacity(0.2)
                                                  : AppTheme.successLight,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          available
                                              ? '${slot.remainingCapacity} left'
                                              : 'Full',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: !available
                                                ? AppTheme.error
                                                : selected
                                                    ? Colors.white
                                                    : AppTheme.success,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),

        // Add to Cart bottom bar
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border:
                const Border(top: BorderSide(color: AppTheme.divider, width: 1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (ctx, cartState) {
              final loading = cartState is CartLoading;
              final canAdd = _selectedDate != null &&
                  _selectedSlot != null &&
                  !loading;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedSlot != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 13, color: AppTheme.textSecondary),
                          const SizedBox(width: 6),
                          Text(_selectedDate!,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 12),
                          const Icon(Icons.access_time_rounded,
                              size: 13, color: AppTheme.textSecondary),
                          const SizedBox(width: 6),
                          Text(_selectedSlot!.displayTime,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(
                            'Rs. ${widget.service.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: canAdd
                            ? const LinearGradient(
                                colors: [AppTheme.primary, Color(0xFF9F97FF)],
                              )
                            : null,
                        color: canAdd ? null : AppTheme.divider,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: canAdd
                            ? () {
                                ctx.read<CartBloc>().add(AddToCartEvent(
                                      serviceId: widget.service.id,
                                      date: _selectedDate!,
                                      startTime: _selectedSlot!.startTime,
                                      quantity: 1,
                                    ));
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.add_shopping_cart_rounded,
                                size: 20),
                        label: Text(
                          _selectedDate == null
                              ? 'Select a date first'
                              : _selectedSlot == null
                                  ? 'Select a time slot'
                                  : 'Add to Cart',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: canAdd
                                  ? Colors.white
                                  : AppTheme.textSecondary),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: AppTheme.primary),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary)),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.textSecondary),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _NoAvailability extends StatelessWidget {
  final String message;
  const _NoAvailability({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_busy_rounded,
              size: 18, color: AppTheme.textLight),
          const SizedBox(width: 10),
          Text(message,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
