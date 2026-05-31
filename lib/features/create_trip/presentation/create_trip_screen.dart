import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../trips/domain/models/trip.dart';
import '../../trips/presentation/providers/trip_providers.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key, this.trip});

  final Trip? trip;

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _destinationController;
  late final TextEditingController _budgetController;
  late final TextEditingController _durationController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _coverImageController;

  String _transport = 'flight';
  String _budgetTier = 'comfort';
  String _privacy = 'public';
  bool _aiShown = false;
  bool _isSaving = false;
  final List<String> _selectedVibes = <String>[];

  bool get _isEditing => widget.trip != null;
  bool get _canCreate => _destinationController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final trip = widget.trip;
    _titleController = TextEditingController(text: trip?.title ?? '');
    _destinationController =
        TextEditingController(text: trip?.destination ?? '');
    _budgetController = TextEditingController(
      text: trip == null ? '1500' : trip.budget.round().toString(),
    );
    _durationController = TextEditingController(
      text: trip == null ? '7' : trip.duration.toString(),
    );
    _descriptionController = TextEditingController(
      text: trip?.description ?? '',
    );
    _coverImageController = TextEditingController(
      text: trip?.coverImage ?? AppConstants.defaultCoverImage,
    );
    _destinationController.addListener(_syncGeneratedFields);
  }

  @override
  void dispose() {
    _destinationController.removeListener(_syncGeneratedFields);
    _titleController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _coverImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.createBg,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final framed = constraints.maxWidth > 430;
            return Container(
              width: constraints.maxWidth < 430 ? constraints.maxWidth : 430,
              height:
                  framed && constraints.maxHeight > 932 ? 932 : constraints.maxHeight,
              color: AppColors.createBg,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _CreateHeader(
                      isEditing: _isEditing,
                      canCreate: _canCreate && !_isSaving,
                      onClose: () => context.pop(),
                      onCreate: _submit,
                    ),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                        children: [
                          const _CoverPicker(),
                          const _SectionLabel('Where to?'),
                          _DestinationCard(
                            controller: _destinationController,
                            onPresetSelected: _setDestination,
                          ),
                          const _SectionLabel('When?'),
                          _DateCard(durationController: _durationController),
                          const _SectionLabel("What's the vibe?"),
                          _VibeCard(
                            selected: _selectedVibes,
                            onToggle: _toggleVibe,
                          ),
                          const _SectionLabel('Getting there'),
                          _TransportCard(
                            active: _transport,
                            onSelected: (value) =>
                                setState(() => _transport = value),
                          ),
                          const _SectionLabel('Budget'),
                          _BudgetCard(
                            active: _budgetTier,
                            controller: _budgetController,
                            onSelected: _setBudgetTier,
                          ),
                          const _SectionLabel('Who can see this?'),
                          _PrivacyCard(
                            active: _privacy,
                            onSelected: (value) =>
                                setState(() => _privacy = value),
                          ),
                          const _SectionLabel('AI Trip Planner ✨'),
                          _AiPlannerCard(
                            destination: _destinationController.text.trim(),
                            shown: _aiShown,
                            onGenerate: () => setState(() => _aiShown = true),
                          ),
                          const SizedBox(height: 18),
                          _CreateButton(
                            enabled: _canCreate && !_isSaving,
                            saving: _isSaving,
                            isEditing: _isEditing,
                            onTap: _submit,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _syncGeneratedFields() {
    final destination = _destinationController.text.trim();
    if (!_isEditing) {
      _titleController.text = destination.isEmpty ? '' : '$destination Trip';
      _descriptionController.text = destination.isEmpty
          ? ''
          : 'A personalized Pluno plan for $destination with saved places, budget notes, and flexible daily ideas.';
    }
    setState(() {});
  }

  void _setDestination(String destination) {
    _destinationController.text = destination;
  }

  void _toggleVibe(String vibe) {
    setState(() {
      if (_selectedVibes.contains(vibe)) {
        _selectedVibes.remove(vibe);
      } else {
        _selectedVibes.add(vibe);
      }
    });
  }

  void _setBudgetTier(String tier, String amount) {
    setState(() {
      _budgetTier = tier;
      _budgetController.text = amount;
    });
  }

  Future<void> _submit() async {
    if (!_canCreate || _isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final actions = ref.read(tripActionsProvider);
    final existing = widget.trip;
    final now = DateTime.now();

    try {
      final trip = existing == null
          ? await actions.createTrip(
              title: _titleController.text.trim(),
              destination: _destinationController.text.trim(),
              coverImage: _coverImageController.text.trim(),
              budget: double.parse(_budgetController.text.trim()),
              duration: int.parse(_durationController.text.trim()),
              description: _descriptionController.text.trim(),
            )
          : existing.copyWith(
              title: _titleController.text.trim(),
              destination: _destinationController.text.trim(),
              coverImage: _coverImageController.text.trim(),
              budget: double.parse(_budgetController.text.trim()),
              duration: int.parse(_durationController.text.trim()),
              description: _descriptionController.text.trim(),
              updatedAt: now,
              isSaved: true,
            );

      if (existing != null) {
        await actions.saveTrip(trip);
      }

      if (!mounted) return;
      context.goNamed(AppRoute.tripDetail.name, params: {'tripId': trip.id});
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _CreateHeader extends StatelessWidget {
  const _CreateHeader({
    required this.isEditing,
    required this.canCreate,
    required this.onClose,
    required this.onCreate,
  });

  final bool isEditing;
  final bool canCreate;
  final VoidCallback onClose;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 54, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleButton(
            icon: Icons.close,
            onTap: onClose,
            background: AppColors.primary.withOpacity(0.10),
            color: AppColors.primary,
          ),
          Column(
            children: [
              Text(
                isEditing ? 'Edit Trip' : 'New Trip',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Plan your adventure',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: canCreate ? onCreate : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: canCreate ? AppColors.primary : Colors.black12,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                children: [
                  Icon(
                    isEditing ? Icons.check : Icons.add,
                    size: 15,
                    color: canCreate ? Colors.white : Colors.black38,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isEditing ? 'Save' : 'Create',
                    style: TextStyle(
                      color: canCreate ? Colors.white : Colors.black38,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 22, 0, 9),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.foreground,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8F5EF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CoverPicker extends StatelessWidget {
  const _CoverPicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2E1A), AppColors.primary, AppColors.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -30,
            child: _GlowCircle(size: 110, opacity: 0.18),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_photo_alternate_outlined,
                    color: Colors.white, size: 34),
                SizedBox(height: 8),
                Text(
                  'Choose a cover',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'We will start with a Pluno default',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.controller,
    required this.onPresetSelected,
  });

  final TextEditingController controller;
  final ValueChanged<String> onPresetSelected;

  static const _presets = [
    ['🏝️', 'Maldives'],
    ['🏔️', 'Swiss Alps'],
    ['⛩️', 'Kyoto'],
    ['🏛️', 'Santorini'],
    ['🌺', 'Bali'],
    ['🗼', 'Paris'],
    ['🗽', 'New York'],
    ['🍋', 'Amalfi'],
  ];

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _IconBubble(icon: Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search destination...',
                    ),
                    style: const TextStyle(
                      color: AppColors.foreground,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Destination is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8F5EF)),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets.map((item) {
                final emoji = item[0];
                final label = item[1];
                final active = controller.text.trim() == label;
                return _ChoicePill(
                  label: '$emoji $label',
                  active: active,
                  color: AppColors.primary,
                  onTap: () => onPresetSelected(label),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({required this.durationController});

  final TextEditingController durationController;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _DateBox(label: 'From', value: 'Jun 8')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                  ),
                  child: const Icon(Icons.chevron_right,
                      color: Colors.white, size: 18),
                ),
              ),
              const Expanded(child: _DateBox(label: 'To', value: 'Jun 15')),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.nights_stay,
                    size: 13, color: AppColors.primary),
                const SizedBox(width: 6),
                SizedBox(
                  width: 28,
                  child: TextFormField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return '';
                      }
                      return null;
                    },
                  ),
                ),
                const Text(
                  ' nights',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAF7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.foreground,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _VibeCard extends StatelessWidget {
  const _VibeCard({required this.selected, required this.onToggle});

  final List<String> selected;
  final ValueChanged<String> onToggle;

  static const _vibes = [
    ['Beach', '🏖️', Color(0xFF0288D1)],
    ['Hiking', '🥾', AppColors.primary],
    ['Food Tour', '🍜', Color(0xFFD32F2F)],
    ['Culture', '🏛️', Color(0xFFF57C00)],
    ['Shopping', '🛍️', Color(0xFF9B59B6)],
    ['Nightlife', '🌙', Color(0xFF455A64)],
    ['Arts', '🎨', Color(0xFFE89A5F)],
    ['Adventure', '🧭', AppColors.accent],
  ];

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _vibes.map((item) {
          final label = item[0] as String;
          final emoji = item[1] as String;
          final color = item[2] as Color;
          final active = selected.contains(label);
          return _ChoicePill(
            label: '$emoji $label',
            active: active,
            color: color,
            onTap: () => onToggle(label),
          );
        }).toList(),
      ),
    );
  }
}

class _TransportCard extends StatelessWidget {
  const _TransportCard({required this.active, required this.onSelected});

  final String active;
  final ValueChanged<String> onSelected;

  static const _items = [
    ['flight', Icons.flight_takeoff, 'Flight', Color(0xFF2A9E64)],
    ['train', Icons.train, 'Train', Color(0xFF5B8DD9)],
    ['drive', Icons.directions_car, 'Drive', Color(0xFFE89A5F)],
    ['boat', Icons.directions_boat, 'Boat', Color(0xFF0288D1)],
  ];

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: _items.map((item) {
          final key = item[0] as String;
          final icon = item[1] as IconData;
          final label = item[2] as String;
          final color = item[3] as Color;
          final selected = active == key;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _IconChoice(
                icon: icon,
                label: label,
                color: color,
                selected: selected,
                onTap: () => onSelected(key),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.active,
    required this.controller,
    required this.onSelected,
  });

  final String active;
  final TextEditingController controller;
  final void Function(String tier, String amount) onSelected;

  static const _items = [
    ['economy', '🎒', 'Economy', 'Under \$1k', '900', Color(0xFF00796B)],
    ['comfort', '🏨', 'Comfort', '\$1k-\$3k', '1500', AppColors.primary],
    ['premium', '✈️', 'Premium', '\$3k-\$8k', '4500', Color(0xFF5B8DD9)],
    ['luxury', '💎', 'Luxury', '\$8k+', '9000', Color(0xFF9B59B6)],
  ];

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.35,
              children: _items.map((item) {
                final key = item[0] as String;
                final emoji = item[1] as String;
                final label = item[2] as String;
                final sub = item[3] as String;
                final amount = item[4] as String;
                final color = item[5] as Color;
                final selected = active == key;
                return GestureDetector(
                  onTap: () => onSelected(key, amount),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected ? color : color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: selected ? color : color.withOpacity(0.16),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                label,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.foreground,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                sub,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white70
                                      : AppColors.muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5FAF7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primary.withOpacity(0.12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_money,
                    size: 16, color: AppColors.primary),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Custom amount',
                    ),
                    style: const TextStyle(
                      color: AppColors.foreground,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return 'Budget must be numeric';
                      }
                      return null;
                    },
                  ),
                ),
                const Text(
                  'USD',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({required this.active, required this.onSelected});

  final String active;
  final ValueChanged<String> onSelected;

  static const _items = [
    ['public', Icons.public, 'Public', 'Everyone', AppColors.primary],
    ['friends', Icons.group, 'Friends', 'Circle', Color(0xFF5B8DD9)],
    ['private', Icons.lock, 'Private', 'Only me', Color(0xFF455A64)],
  ];

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: _items.map((item) {
          final key = item[0] as String;
          final icon = item[1] as IconData;
          final label = item[2] as String;
          final sub = item[3] as String;
          final color = item[4] as Color;
          final selected = active == key;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () => onSelected(key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: selected ? color : color.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected ? color : color.withOpacity(0.14),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(icon, color: selected ? Colors.white : color),
                      const SizedBox(height: 5),
                      Text(
                        label,
                        style: TextStyle(
                          color:
                              selected ? Colors.white : AppColors.foreground,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sub,
                        style: TextStyle(
                          color: selected ? Colors.white70 : AppColors.muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AiPlannerCard extends StatelessWidget {
  const _AiPlannerCard({
    required this.destination,
    required this.shown,
    required this.onGenerate,
  });

  final String destination;
  final bool shown;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final tips = destination.isEmpty
        ? const <String>[]
        : <String>[
            '🧭 Build a relaxed first-day arrival plan',
            '🍜 Save one local food stop near your hotel',
            '🌅 Reserve sunset time for your best photo spot',
          ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A2E1A),
            Color(0xFF1A5C38),
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A2E1A).withOpacity(0.35),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.auto_awesome,
                                color: Color(0xFFFFD700), size: 15),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'AI Suggestions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        destination.isEmpty
                            ? 'Add a destination to get personalized ideas'
                            : 'Generate smart tips for $destination',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                    gradient: RadialGradient(
                      center: const Alignment(-0.4, -0.4),
                      colors: [
                        Colors.white.withOpacity(0.25),
                        AppColors.primary.withOpacity(0.10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: GestureDetector(
              onTap: destination.isEmpty ? null : onGenerate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bolt,
                        color: Color(0xFFFFD700), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      shown ? 'Regenerate Ideas' : 'Generate AI Ideas',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (shown && tips.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.10)),
                ),
              ),
              child: Column(
                children: tips.map((tip) {
                  final parts = tip.split(' ');
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(parts.first,
                            style: const TextStyle(fontSize: 16, height: 1.3)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            parts.skip(1).join(' '),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.88),
                              fontSize: 13,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({
    required this.enabled,
    required this.saving,
    required this.isEditing,
    required this.onTap,
  });

  final bool enabled;
  final bool saving;
  final bool isEditing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: enabled
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                )
              : null,
          color: enabled ? null : Colors.black.withOpacity(0.08),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.40),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (saving)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              Icon(
                isEditing ? Icons.check : Icons.auto_awesome,
                color: enabled ? const Color(0xFFFFD700) : Colors.black26,
                size: 18,
              ),
            const SizedBox(width: 10),
            Text(
              isEditing ? 'Save Trip' : 'Create Trip',
              style: TextStyle(
                color: enabled ? Colors.white : const Color(0xFFB0B0C0),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color : color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: active ? color : color.withOpacity(0.18),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.icon,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? color : color.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : color, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.background,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
