import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Callschedule extends StatefulWidget {
  const Callschedule({super.key});

  @override
  _CallscheduleState createState() => _CallscheduleState();
}

class _CallscheduleState extends State<Callschedule> {
  List<Map<String, dynamic>> callSchedules = [];

  void _createSchedule(BuildContext context) {
    final _nameController = TextEditingController();
    final _reasonController = TextEditingController();
    final _phoneController = TextEditingController();

    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Create Schedule"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Phone Number"),
              ),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: "Reason"),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    selectedDate == null
                        ? "Select Date"
                        : DateFormat('EEEE, MMM d').format(selectedDate!),
                  ),
                  Spacer(),
                  TextButton(
                    child: Text("Choose Date"),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    selectedTime == null
                        ? "Select Time"
                        : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                  ),
                  Spacer(),
                  TextButton(
                    child: Text("Choose Time"),
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text("Add"),
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _reasonController.text.isNotEmpty &&
                  _phoneController.text.isNotEmpty &&
                  selectedDate != null &&
                  selectedTime != null) {
                final schedule = {
                  "name": _nameController.text,
                  "reason": _reasonController.text,
                  "phone": _phoneController.text,
                  "datetime": DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  ),
                };
                setState(() {
                  callSchedules.add(schedule);
                  callSchedules.sort((a, b) =>
                      a['datetime'].compareTo(b['datetime'])); // Sort by date
                });
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _deleteSchedule(int index) {
    setState(() {
      callSchedules.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Call Scheduler"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFFE3F2FD),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Welcome to Call Scheduling",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: callSchedules.length,
              itemBuilder: (ctx, index) {
                final schedule = callSchedules[index];
                final dateStr =
                    DateFormat('EEEE, MMM d').format(schedule['datetime']);
                final timeStr =
                    DateFormat('h:mm a').format(schedule['datetime']);

                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("${schedule['name']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Reason: ${schedule['reason']}"),
                        Text("Phone: ${schedule['phone']}"),
                        Text("Time: $timeStr"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.call, color: Colors.green),
                      onPressed: () {
                        // Logic for initiating a call can go here
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createSchedule(context),
      ),
    );
  }
}
