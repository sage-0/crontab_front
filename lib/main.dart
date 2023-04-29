import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool? _status;
  late String _apiUrl;

  @override
  void initState() {
    super.initState();
    _apiUrl = 'http://192.168.0.200:8000';
    _getStatus();
  }

  Future<void> _getStatus() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.get(Uri.parse(_apiUrl));
    final responseData = jsonDecode(response.body);
    if (responseData == "enable") {
      setState(() {
        _status = true;
        _isLoading = false;
      });
    } else if (responseData == "disable") {
      setState(() {
        _status = false;
        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: responseData.toString());
    }
  }

  Future<void> _switchStatus(bool status) async {
    setState(() {
      _isLoading = true;
    });
    final switchStr = status ? "on" : "off";
    final response =
    await http.post(Uri.parse(_apiUrl + '/switch/$switchStr'));
    final responseData = jsonDecode(response.body);
    if (responseData == "enable") {
      setState(() {
        _status = true;
        _isLoading = false;
      });
    } else if (responseData == "disable") {
      setState(() {
        _status = false;
        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: responseData.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crontab Switcher',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Crontab Switcher'),
        ),
        body: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Crontab Status: ${_status! ? 'on' : 'off'}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _switchStatus(true),
                child: const Text('Enable Crontab'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _switchStatus(false),
                child: const Text('Disable Crontab'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}