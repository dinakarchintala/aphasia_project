import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aphasia_bot/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Callschedule extends StatefulWidget {
  const Callschedule({super.key});

  @override
  _CallscheduleState createState() => _CallscheduleState();
}

class _CallscheduleState extends State<Callschedule> {
  late CollectionReference callSchedulesCollection;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<Auth>(context, listen: false);
    callSchedulesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(authService.currentUser?.uid)
        .collection('callSchedules');
  }

  Future<void> _callingUsingTwilio(String number) async {
    const accountSid = 'AC333f057fec403d73ff0438d6c6e0f7da';
    const authToken = 'd55b29422b71f535214b7be434f709a2';
    const fromPhone = '+17755429270';
    final uri = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Calls.json');
    final formattedNumber = number.startsWith('+91') ? number : '+91$number';

    final response = await http.post(
      uri,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
      },
      body: {
        'From': fromPhone,
        'To': formattedNumber,
        'Url': 'http://demo.twilio.com/docs/voice.xml',
      },
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Call initiated successfully!')),
      );
    } else {
      print("Error: ${response.statusCode} ${response.body}"); // Add this
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initiate call: ${response.body}')),
      );
    }
  }

  Future<void> _deleteSchedule(String scheduleId) async {
    await callSchedulesCollection.doc(scheduleId).delete();
  }

  Future<void> _createSchedule(BuildContext context) async {
    final _nameController = TextEditingController();
    final _reasonController = TextEditingController();
    final _phoneController = TextEditingController();

    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Create Schedule"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: "Reason"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    selectedDate == null
                        ? "Select Date"
                        : DateFormat('EEEE, MMM d').format(selectedDate!),
                  ),
                  const Spacer(),
                  TextButton(
                    child: const Text("Choose Date"),
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
                  const Spacer(),
                  TextButton(
                    child: const Text("Choose Time"),
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
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text("Add"),
            onPressed: () async {
              if (_nameController.text.isNotEmpty &&
                  _reasonController.text.isNotEmpty &&
                  _phoneController.text.isNotEmpty &&
                  selectedDate != null &&
                  selectedTime != null) {
                final datetime = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );
                final schedule = {
                  "name": _nameController.text,
                  "reason": _reasonController.text,
                  "phone": _phoneController.text,
                  "datetime": datetime.toIso8601String(),
                };

                await callSchedulesCollection.add(schedule);

                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Call Scheduler"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE3F2FD),
      body: StreamBuilder<QuerySnapshot>(
        stream: callSchedulesCollection
            .orderBy('datetime', descending: false)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          final groupedSchedules = <String, List<DocumentSnapshot>>{};

          for (final doc in docs) {
            final datetime = DateTime.parse(doc['datetime']);
            final dateKey = DateFormat('EEEE, MMM d').format(datetime);
            groupedSchedules.putIfAbsent(dateKey, () => []).add(doc);
          }

          return ListView(
            children: groupedSchedules.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...entry.value.map((doc) {
                    final schedule = doc.data() as Map<String, dynamic>;
                    final scheduleId = doc.id;
                    final datetime = DateTime.parse(schedule['datetime']);
                    final timeStr = DateFormat('h:mm a').format(datetime);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.call, color: Colors.green),
                              onPressed: () =>
                                  _callingUsingTwilio(schedule['phone']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSchedule(scheduleId),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _createSchedule(context),
      ),
    );
  }
}
