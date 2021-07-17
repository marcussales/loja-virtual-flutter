import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/datas/product_data.dart';
import 'package:loja_virtual_flutter/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData data;
  ProductTile(this.type, this.data);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProductScreen(data)));
        },
        child: Card(
          child: type == 'grid'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: Image.network(
                        data.images[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(data.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                )),
                            Text(
                              "R\$ ${data.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Image.network(
                          data.images[0],
                          fit: BoxFit.cover,
                          height: 250.0,
                        )),
                    Flexible(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  )),
                              Text(
                                "R\$ ${data.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
        ));
  }
}
