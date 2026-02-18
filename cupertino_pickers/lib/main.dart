import 'package:flutter/cupertino.dart';

void main() => runApp(const FocusSessionApp());

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

class FocusSessionPage extends StatefulWidget {
  const FocusSessionPage({super.key});

  @override
  State<FocusSessionPage> createState() => _FocusSessionPageState();
}

class _FocusSessionPageState extends State<FocusSessionPage> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  Duration _selectedDuration = const Duration(minutes: 25);
  String? _confirmationMessage;

  String get _formattedDate {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final w = weekdays[_selectedDate.weekday - 1];
    final m = months[_selectedDate.month - 1];
    return '$w, $m ${_selectedDate.day}';
  }

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

  Widget _pickerBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
          CupertinoButton(child: const Text('Done'), onPressed: () => Navigator.of(context).pop()),
        ],
      );

  void _showDatePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _pickerBar(),
              Expanded(
                child: CupertinoDatePicker(
                  // [ATTR 1] mode: default dateAndTime; we use date (date-only).
                  mode: CupertinoDatePickerMode.date,
                  // [ATTR 2] initialDateTime: default now; we use _selectedDate.
                  initialDateTime: _selectedDate,
                  minimumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                  onDateTimeChanged: (v) => setState(() => _selectedDate = v),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDurationPicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _pickerBar(),
              Expanded(
                child: CupertinoTimerPicker(
                  // [ATTR 3] minuteInterval: default 1; we use 5 for presets.
                  minuteInterval: 5,
                  initialTimerDuration: _selectedDuration,
                  onTimerDurationChanged: (v) => setState(() => _selectedDuration = v),
                ),
              ),
            ],
          ),
        ),
      ),
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
