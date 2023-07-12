import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  bool _isLoading = false;

  Future<void> _retrieveCallLogEntries() async {
    setState(() {
      _isLoading = true;
    });

    final Iterable<CallLogEntry> result = await CallLog.query();

    setState(() {
      _callLogEntries = result;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _retrieveCallLogEntries();

  }

  @override
  Widget build(BuildContext context) {

    const TextStyle mono = TextStyle(fontFamily: 'monospace');
    final List<Widget> children = <Widget>[];
    for (CallLogEntry entry in _callLogEntries) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2,3)
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name.toString()),
                Text(entry.formattedNumber.toString()),
                Text(entry.callType.toString()),
                Text(DateTime.fromMillisecondsSinceEpoch(entry.timestamp!).toString()),
                Text(entry.simDisplayName.toString()),
              ],
            ),
          ),
        )

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: <Widget>[
        //     const Divider(),
        //     Text('F. NUMBER  : ${entry.formattedNumber}', style: mono),
        //     Text('C.M. NUMBER: ${entry.cachedMatchedNumber}', style: mono),
        //     Text('NUMBER     : ${entry.number}', style: mono),
        //     Text('NAME       : ${entry.name}', style: mono),
        //     Text('TYPE       : ${entry.callType}', style: mono),
        //     Text('DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}',
        //         style: mono),
        //     Text('DURATION   : ${entry.duration}', style: mono),
        //     Text('ACCOUNT ID : ${entry.phoneAccountId}', style: mono),
        //     Text('SIM NAME   : ${entry.simDisplayName}', style: mono),
        //   ],
        // ),
      );
    }


    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
          title: const Text('Call Log History')
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: children),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
