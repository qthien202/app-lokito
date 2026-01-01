import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lokito/i18n/strings.g.dart';

class ResendTimerButton extends StatefulWidget {
  final FutureOr<void> Function() onResend;
  final int initialSeconds;

  const ResendTimerButton({
    super.key,
    required this.onResend,
    this.initialSeconds = 60,
  });

  @override
  State<ResendTimerButton> createState() => _ResendTimerButtonState();
}

class _ResendTimerButtonState extends State<ResendTimerButton> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = widget.initialSeconds;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _timer?.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: _canResend
          ? () async {
              await widget.onResend();
              _startTimer();
            }
          : null,
      child: Text(
        _canResend
            ? t.auth.resendCode
            : t.auth.resendIn(seconds: _secondsRemaining),
        style: TextStyle(
          color: _canResend
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.4),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
