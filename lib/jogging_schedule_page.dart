import 'package:flutter/material.dart';

class JoggingSchedulePage extends StatefulWidget {
  final List<JoggingSchedule> joggingSchedules;

  JoggingSchedulePage(this.joggingSchedules);

  @override
  _JoggingSchedulePageState createState() => _JoggingSchedulePageState();
}

class _JoggingSchedulePageState extends State<JoggingSchedulePage> {
  String joggingSchedule = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogging Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Set Your Jogging Schedule',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.0),
            ListTile(
              title: TextField(
                onChanged: (value) {
                  setState(() {
                    joggingSchedule = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter Your Jogging Schedule',
                  border: OutlineInputBorder(),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  await _selectDate();
                  await _selectTime();

                  // Create JoggingSchedule object
                  JoggingSchedule schedule = JoggingSchedule(
                    scheduleText: joggingSchedule,
                    date: selectedDate,
                    time: selectedTime,
                  );

                  // Add the schedule to the list and notify the previous screen
                  widget.joggingSchedules.add(schedule);
                  setState(() {
                    joggingSchedule = ''; // Clear the input field
                  });

                  // Schedule automatic removal of the added event
                  _scheduleAutoRemoval(schedule);
                },
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: widget.joggingSchedules.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key:
                        Key(widget.joggingSchedules[index].hashCode.toString()),
                    onDismissed: (direction) {
                      // Remove the item from the list
                      setState(() {
                        widget.joggingSchedules.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Card(
                      elevation: 4.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title:
                            Text(widget.joggingSchedules[index].scheduleText),
                        subtitle: Text(
                          'Date: ${widget.joggingSchedules[index].getFormattedDate()} | Time: ${widget.joggingSchedules[index].getFormattedTime()}',
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
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _scheduleAutoRemoval(JoggingSchedule schedule) {
    // Calculate the time until the scheduled event
    final now = DateTime.now();
    final scheduledDateTime = DateTime(
      schedule.date.year,
      schedule.date.month,
      schedule.date.day,
      schedule.time.hour,
      schedule.time.minute,
    );

    final timeUntilEvent = scheduledDateTime.difference(now);

    // Schedule the removal after the time has passed
    Future.delayed(timeUntilEvent, () {
      setState(() {
        widget.joggingSchedules.remove(schedule);
      });
    });
  }
}

class JoggingSchedule {
  String scheduleText;
  DateTime date;
  TimeOfDay time;

  JoggingSchedule({
    required this.scheduleText,
    required this.date,
    required this.time,
  });

  String getFormattedDate() {
    return "${date.day}/${date.month}/${date.year}";
  }

  String getFormattedTime() {
    return "${time.hour}:${time.minute}";
  }
}
