import 'package:flutter/material.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for the toggle switches
  bool _addItemsToBottom = true;
  bool _moveTickedItems = true;
  bool _displayRichPreviews = true;
  bool _createTextNotes = false;
  bool _enableSharing = true;

  // 1. State variables for Reminder Defaults times (THE NEW STATE)
  String _morningTime = '8:00 am';
  String _afternoonTime = '1:00 pm';
  String _eveningTime = '6:00 pm';

  // --- Core Functionality: Time Picker and State Update ---

  // Helper to convert '8:00 am' string to TimeOfDay for initial value
  TimeOfDay _stringToTimeOfDay(String time) {
    // Example: '8:00 am' -> ['8', '00 am']
    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1].split(' ')[0]);
    final amPm = parts[1].split(' ')[1].toLowerCase();

    // Convert 12-hour format to 24-hour format
    if (amPm == 'pm' && hour != 12) {
      hour += 12;
    } else if (amPm == 'am' && hour == 12) {
      hour = 0; // Midnight (12:xx am)
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  void _showTimePickerDialog(String timeKey, String currentTime) async {

  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: _stringToTimeOfDay(currentTime),
    // Ensure the dialog uses 12-hour format if set by the system
    builder: (context, child) {
      // 1. Apply the desired canvasColor (background color) to the dialog
      return Theme(
        data: Theme.of(context).copyWith(
          // Set the background color of the time picker dialog to white
          canvasColor: Colors.white, 
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        ),
      );
    },
  );


  // If the user selected a time (not cancelled)
  if (picked != null) {
    // Use setState to rebuild the widget tree with the new time
    setState(() {
      // picked.format(context) converts TimeOfDay to a localized string (e.g., '1:30 PM')
      final newTime = picked.format(context).toLowerCase().replaceAll(' ', '');

      if (timeKey == 'Morning') {
        _morningTime = newTime;
      } else if (timeKey == 'Afternoon') {
        _afternoonTime = newTime;
      } else if (timeKey == 'Evening') {
        _eveningTime = newTime;
      }
    });
  }
}

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(title, style: const TextStyle(fontSize: 16.0)),
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue.shade700,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
            ),
          ),
      ],
    );
  }

  Widget _buildValueSetting({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16.0)),
      trailing: Text(
        value,
        style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );
  }

  // 3. Updated Time Picker Item
  Widget _buildTimeSetting({
    required String title,
    required String time,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16.0)),
      trailing: Text(
        time,
        style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600),
      ),
      // Crucial: Tapping calls the new state-updating function
      onTap: () => _showTimePickerDialog(title, time),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: ListView(
        children: <Widget>[
          // --- 1. Display options ---
          _buildSectionTitle('Display options'),
          _buildSwitchSetting(
            title: 'Add new items to bottom',
            value: _addItemsToBottom,
            onChanged: (bool newValue) { setState(() { _addItemsToBottom = newValue; }); },
          ),
          _buildSwitchSetting(
            title: 'Move ticked items to bottom',
            value: _moveTickedItems,
            onChanged: (bool newValue) { setState(() { _moveTickedItems = newValue; }); },
          ),
          _buildSwitchSetting(
            title: 'Display rich link previews',
            value: _displayRichPreviews,
            onChanged: (bool newValue) { setState(() { _displayRichPreviews = newValue; }); },
          ),
          _buildValueSetting(title: 'Theme', value: 'System default'),
          const Divider(height: 1.0, thickness: 1.0),

          // --- 2. Note creation ---
          _buildSectionTitle('Note creation'),
          _buildSwitchSetting(
            title: 'Create text notes by default',
            subtitle: 'You can always long press to create other note types.',
            value: _createTextNotes,
            onChanged: (bool newValue) { setState(() { _createTextNotes = newValue; }); },
          ),
          const Divider(height: 1.0, thickness: 1.0),

          // --- 3. Reminder defaults (Uses state variables) ---
          _buildSectionTitle('Reminder defaults'),
          // Now passing the state variable (_morningTime) to the widget
          _buildTimeSetting(title: 'Morning', time: _morningTime),
          _buildTimeSetting(title: 'Afternoon', time: _afternoonTime),
          _buildTimeSetting(title: 'Evening', time: _eveningTime),
          const Divider(height: 1.0, thickness: 1.0),

          // --- 4. Sharing ---
          _buildSectionTitle('Sharing'),
          _buildSwitchSetting(
            title: 'Enable sharing',
            value: _enableSharing,
            onChanged: (bool newValue) { setState(() { _enableSharing = newValue; }); },
          ),
          const SizedBox(height: 48.0),
        ],
      ),
    );
  }
}