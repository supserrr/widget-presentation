import 'package:flutter/cupertino.dart';

void main() {
  runApp(const FocusSessionApp());
}

/// Root Cupertino-style app for the focus session demo.
class FocusSessionApp extends StatelessWidget {
  const FocusSessionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Focus Session',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: FocusSessionPage(),
    );
  }
}

/// Main page: schedule a focus session by picking a date and duration.
class FocusSessionPage extends StatefulWidget {
  const FocusSessionPage({super.key});

  @override
  State<FocusSessionPage> createState() => _FocusSessionPageState();
}

class _FocusSessionPageState extends State<FocusSessionPage> {
  // State: selected date for the session and duration in minutes/seconds.
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  Duration _selectedDuration = const Duration(minutes: 25);
  String? _confirmationMessage;

  /// Format the selected date for display (e.g., "Tue, Feb 17").
  String get _formattedDate {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final w = weekdays[_selectedDate.weekday - 1];
    final m = months[_selectedDate.month - 1];
    return '$w, $m ${_selectedDate.day}';
  }

  /// Format the selected duration for display (e.g., "25 min" or "1 h 30 min").
  String get _formattedDuration {
    final minutes = _selectedDuration.inMinutes;
    final seconds = _selectedDuration.inSeconds % 60;
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      if (m > 0) return '$h h $m min';
      return '$h h';
    }
    if (seconds > 0) return '$minutes min $seconds s';
    return '$minutes min';
  }

  /// Show a bottom sheet with CupertinoDatePicker.
  /// Highlighted attribute: mode (date vs dateAndTime) and initialDateTime.
  void _showDatePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    // Attribute 1: mode - default is dateAndTime; we use date for session day only.
                    mode: CupertinoDatePickerMode.date,
                    // Attribute 2: initialDateTime - default is now; we use selected date.
                    initialDateTime: _selectedDate,
                    minimumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime value) {
                      setState(() => _selectedDate = value);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show a bottom sheet with CupertinoTimerPicker.
  /// Highlighted attribute: minuteInterval.
  void _showDurationPicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoTimerPicker(
                    // Attribute 3: minuteInterval - default is 1; we use 5 for focus session presets.
                    minuteInterval: 5,
                    initialTimerDuration: _selectedDuration,
                    onTimerDurationChanged: (Duration value) {
                      setState(() => _selectedDuration = value);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSchedulePressed() {
    setState(() {
      _confirmationMessage = 'Scheduled: $_formattedDate for $_formattedDuration';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Focus Session'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              CupertinoListSection.insetGrouped(
                header: const Text('Session details'),
                children: [
                  CupertinoListTile(
                    title: const Text('Session date'),
                    trailing: Text(_formattedDate),
                    onTap: _showDatePicker,
                  ),
                  CupertinoListTile(
                    title: const Text('Session length'),
                    trailing: Text(_formattedDuration),
                    onTap: _showDurationPicker,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Focus on $_formattedDate for $_formattedDuration',
                textAlign: TextAlign.center,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              const Spacer(),
              if (_confirmationMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _confirmationMessage!,
                    textAlign: TextAlign.center,
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              CupertinoButton.filled(
                onPressed: _onSchedulePressed,
                child: const Text('Schedule Focus Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
