import 'package:flutter/material.dart';

class GrafikBalita extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Grafik Pertumbuhan'), backgroundColor: Colors.green[700]),
      body: Center(
        child: Container(
          height: 250,
          width: double.infinity,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
                colors: [Colors.green[200]!, Colors.green[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            boxShadow: [
              BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 4))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, size: 60, color: Colors.white),
              SizedBox(height: 12),
              Text(
                'Grafik pertumbuhan balita\nsementara (dummy)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}