import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: FAQPage(),
  ));
}

class FAQPage extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'What is ToDo?',
      answer:
          'ToDo is a personalized task manager where you can keep track of your day-to-day tasks.',
    ),
    FAQItem(
      question: 'How many tasks can I add?',
      answer:
          'You can add as much as you want. There is no limitation for that.',
    ),
    FAQItem(
      question: 'Can I categorize my tasks?',
      answer:
          'Yes, you can organize your tasks in a more meaningful manner by categorizing them.',
    ),
    FAQItem(
      question: 'How can I know about DDLs?',
      answer:
          'You will be getting a notification from the application when the due date is approaching.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              // Implement your logic to handle user's help request, e.g., show a dialog or navigate to a help screen.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Need Help?'),
                    content: Text('Feel free to ask any question!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqItems[index].question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  faqItems[index].answer,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
