import 'dart:async';
import 'package:flutter/material.dart';

class TaskTimerPage extends StatefulWidget {
  final String taskTitle;
  final int durationMinutes;

  const TaskTimerPage({
    super.key,
    required this.taskTitle,
    required this.durationMinutes,
  });

  @override
  State<TaskTimerPage> createState() => _TaskTimerPageState();
}

class _TaskTimerPageState extends State<TaskTimerPage> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _isRunning = false;

  // For the floating change indicator
  String? _timeChangeIndicator;
  Timer? _indicatorTimer;
  int _indicatorKey = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.durationMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _indicatorTimer?.cancel();
    super.dispose();
  }

  void _startOrPauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
          });
        }
      });
    }
  }

  void _addTime(int minutes) {
    if (minutes == 0) return;
    setState(() {
      _secondsRemaining += minutes * 60;
      if (_secondsRemaining < 0) {
        _secondsRemaining = 0;
      }
      _timeChangeIndicator = minutes > 0 ? '+$minutes' : '$minutes';
      _indicatorKey++;
    });

    _indicatorTimer?.cancel();
    _indicatorTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _timeChangeIndicator = null;
        });
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = widget.durationMinutes * 60;
      _isRunning = false;
    });
  }

  void _finishTimer() {
    _timer?.cancel();
    // Logically finish the task, navigate back, etc.
    Navigator.pop(context);
  }

  String get _formattedTime {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.scaffoldBackgroundColor, colorScheme.primary.withValues(alpha: 0.1)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        children: [
                          // Top Header: Back Button
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: theme.textTheme.bodyLarge!.color!,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Titles
                          Text(
                            'Focusing on',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.textTheme.bodyMedium!.color!,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.taskTitle,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.bodyLarge!.color!,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 18),

                          // Timer Circle
                          Container(
                            width: 224,
                            height: 224,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.cardColor.withValues(alpha: 0.4),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 192,
                              height: 192,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.cardColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'POMODORO',
                                    style: TextStyle(
                                      color: theme.textTheme.bodyMedium!.color!,
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      Text(
                                        _formattedTime,
                                        style: TextStyle(
                                          color: theme.textTheme.bodyLarge!.color!,
                                          fontSize: 46,
                                          height: 1.1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (_timeChangeIndicator != null)
                                        Positioned(
                                          right: -30,
                                          top: -10,
                                          child: TweenAnimationBuilder<double>(
                                            key: ValueKey(_indicatorKey),
                                            duration: const Duration(
                                              milliseconds: 1000,
                                            ),
                                            tween: Tween(begin: 0.0, end: 1.0),
                                            builder: (context, value, child) {
                                              return Opacity(
                                                opacity:
                                                    (value < 0.5
                                                            ? value * 2
                                                            : (1.0 - value) * 2)
                                                        .clamp(0.0, 1.0),
                                                child: Transform.translate(
                                                  offset: Offset(
                                                    0,
                                                    -30 * value,
                                                  ),
                                                  child: child,
                                                ),
                                              );
                                            },
                                            child: Text(
                                              _timeChangeIndicator!,
                                              style: TextStyle(
                                                color:
                                                    _timeChangeIndicator!
                                                        .startsWith('+')
                                                    ? const Color(0xFF10B981)
                                                    : colorScheme.error,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Add Extra Time Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTimeButton(context, '- 5 min', -5),
                              const SizedBox(width: 10),
                              _buildTimeButton(context, '+ 5 min', 5),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Bottom Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildControlPill(
                                context,
                                Icons.replay,
                                'Reset',
                                _resetTimer,
                              ),
                              const SizedBox(width: 10),
                              // Play Button
                              InkWell(
                                onTap: _startOrPauseTimer,
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary, // Blue color
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.textTheme.bodyLarge!.color!, // Dark border
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _isRunning
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: colorScheme.onPrimary,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              _buildControlPill(
                                context,
                                Icons.check,
                                'Finish',
                                _finishTimer,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton(BuildContext context, String text, int minutesToAdd) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _addTime(minutesToAdd),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildControlPill(BuildContext context, IconData icon, String text, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 16),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


