import 'package:adhd_helper/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageWidget extends StatefulWidget {
  final String senderName;
  final String topic;
  final String messageContent;
  final DateTime timestamp;

  const MessageWidget({super.key, 
    required this.senderName,
    required this.topic,
    required this.messageContent,
    required this.timestamp,
  });

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool showFullMessage = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF6CA8F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)!.topic} : ${widget.topic}',
            style: smallTextstyle,
          ),
          const SizedBox(height: 5),
          Text(
            '${AppLocalizations.of(context)!.from} : ${widget.senderName}',
            style: smallTextstyle,
          ),
          const SizedBox(height: 5),
          LimitedBox(
            maxHeight: showFullMessage ? double.infinity : 50,
            child: Text(
              widget.messageContent,
              style: messagTextstyle,
            ),
          ),
          if (widget.messageContent.length > 130)
            TextButton(
              onPressed: () {
                setState(() {
                  showFullMessage = !showFullMessage;
                });
              },
              child: Text(
                showFullMessage
                    ? AppLocalizations.of(context)!.showLess
                    : AppLocalizations.of(context)!.showMore,
                style: const TextStyle(color: Color.fromARGB(255, 73, 114, 164)),
              ),
            ),
          const SizedBox(height: 5),
          Text(
            '${AppLocalizations.of(context)!.sentAt} : ${_formatTimestamp()}',
            style: const TextStyle(color: Color.fromARGB(255, 205, 225, 239)),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp() {
    return '${_twoDigits(widget.timestamp.day)}-${_twoDigits(widget.timestamp.month)}-${widget.timestamp.year} '
        '${_twoDigits(widget.timestamp.hour)}:${_twoDigits(widget.timestamp.minute)}';
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}
