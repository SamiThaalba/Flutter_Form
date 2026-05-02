import 'package:flutter/material.dart';

class OutputScreen extends StatefulWidget {
  final String? username;
  final String? password;
  final String? email;
  final bool? rememberMe;
  final String? gender;
  final String? country;
  final double? age;
  final DateTime? selectedDate;

  const OutputScreen({
    super.key,
    this.username,
    this.password,
    this.email,
    this.rememberMe,
    this.gender,
    this.country,
    this.age,
    this.selectedDate,
  });

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen>
    with SingleTickerProviderStateMixin {
  bool _showPassword = false;
  late AnimationController _controller;
  late List<Animation<double>> _itemAnimations;

  final int _itemCount = 8;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200 + _itemCount * 80),
    );

    _itemAnimations = List.generate(_itemCount, (i) {
      final start = (i * 0.1).clamp(0.0, 0.7);
      final end = (start + 0.3).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
    Widget? trailing,
    int animIndex = 0,
  }) {
    return AnimatedBuilder(
      animation: _itemAnimations[animIndex],
      builder: (context, child) => Opacity(
        opacity: _itemAnimations[animIndex].value,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - _itemAnimations[animIndex].value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? const Color(0xFF6C63FF).withOpacity(0.15)
                    : const Color(0xFF2E2E45),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isHighlighted
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFF8888AA),
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF8888AA),
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: isHighlighted
                          ? const Color(0xFF6C63FF)
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: isHighlighted
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      const Divider(color: Color(0xFF2E2E45), height: 1, thickness: 1);

  @override
  Widget build(BuildContext context) {
    final formattedDate = widget.selectedDate == null
        ? 'Not selected'
        : '${widget.selectedDate!.day.toString().padLeft(2, '0')} / '
              '${widget.selectedDate!.month.toString().padLeft(2, '0')} / '
              '${widget.selectedDate!.year}';

    final genderFormatted = widget.gender != null
        ? '${widget.gender![0].toUpperCase()}${widget.gender!.substring(1)}'
        : 'Not specified';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: const Color(0xFF0F0F14),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    '@${widget.username ?? 'user'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A1040), Color(0xFF0F0F14)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      top: 30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF6C63FF).withOpacity(0.12),
                        ),
                        child: const Icon(
                          Icons.account_circle_rounded,
                          color: Color(0xFF6C63FF),
                          size: 48,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ─── Credentials Card ──────────────────────────────────
                _sectionCard(
                  label: 'CREDENTIALS',
                  children: [
                    _infoRow(
                      icon: Icons.person_outline,
                      label: 'USERNAME',
                      value: widget.username ?? '—',
                      isHighlighted: true,
                      animIndex: 0,
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.lock_outline,
                      label: 'PASSWORD',
                      value: _showPassword
                          ? (widget.password ?? '—')
                          : '••••••••',
                      animIndex: 1,
                      trailing: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF8888AA),
                          size: 18,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.mail_outline,
                      label: 'EMAIL',
                      value: widget.email ?? '—',
                      animIndex: 2,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ─── Personal Info Card ────────────────────────────────
                _sectionCard(
                  label: 'PERSONAL INFO',
                  children: [
                    _infoRow(
                      icon: Icons.wc_rounded,
                      label: 'GENDER',
                      value: genderFormatted,
                      animIndex: 3,
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.public,
                      label: 'COUNTRY',
                      value: widget.country ?? '—',
                      animIndex: 4,
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.cake_outlined,
                      label: 'AGE',
                      value: '${widget.age?.round() ?? '—'} years old',
                      animIndex: 5,
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'DATE OF BIRTH',
                      value: formattedDate,
                      animIndex: 6,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ─── Preferences Card ──────────────────────────────────
                AnimatedBuilder(
                  animation: _itemAnimations[7],
                  builder: (context, child) => Opacity(
                    opacity: _itemAnimations[7].value,
                    child: Transform.translate(
                      offset: Offset(0, 16 * (1 - _itemAnimations[7].value)),
                      child: child,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A24),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF2E2E45),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: widget.rememberMe == true
                                ? const Color(0xFF00D4AA).withOpacity(0.15)
                                : const Color(0xFF2E2E45),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            widget.rememberMe == true
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: widget.rememberMe == true
                                ? const Color(0xFF00D4AA)
                                : const Color(0xFF8888AA),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'REMEMBER ME',
                                style: TextStyle(
                                  color: Color(0xFF8888AA),
                                  fontSize: 11,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.rememberMe == true
                                    ? 'Enabled — Stay signed in'
                                    : 'Disabled',
                                style: TextStyle(
                                  color: widget.rememberMe == true
                                      ? const Color(0xFF00D4AA)
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: widget.rememberMe == true
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 24,
                          decoration: BoxDecoration(
                            color: widget.rememberMe == true
                                ? const Color(0xFF00D4AA)
                                : const Color(0xFF2E2E45),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: widget.rememberMe == true
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ─── Back Button ───────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF6C63FF),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      foregroundColor: const Color(0xFF6C63FF),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Back to Form',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String label, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E2E45), width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8888AA),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
