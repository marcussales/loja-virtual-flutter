import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;
  OrderTile(this.orderId);
  int status = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('orders')
              .document(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              this.status = snapshot.data['status'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Código do pedido: ${snapshot.data.documentID}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(_buildProductsText(snapshot.data)),
                  SizedBox(height: 10),
                  Text(
                    "Status do pedido",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildCircle('1', 'Preparação', 1),
                      _buildLine(),
                      _buildCircle('2', 'Em Transporte', 2),
                      _buildLine(),
                      _buildCircle('3', 'Saiu para Entrega', 3),
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Descrição:\n";
    for (LinkedHashMap p in snapshot.data['products']) {
      text +=
          "${p['quantity']}x ${p['product']['title']} (R\$ ${p['product']['price'].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data['totalPrice'].toStringAsFixed(2)}";
    return text;
  }

  _buildCircle(String title, String subTitle, int currentStatus) {
    Color backgroundColor;
    Widget child;

    if (status < currentStatus) {
      backgroundColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == currentStatus) {
      backgroundColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(title),
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white))
        ],
      );
    } else {
      backgroundColor = Colors.green;
      child = Icon(Icons.done);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backgroundColor,
          child: child,
        ),
        SizedBox(height: 10),
        Text(subTitle)
      ],
    );
  }

  _buildLine() {
    return Container(
      height: 1,
      width: 30,
      color: Colors.grey[500],
    );
  }
}
