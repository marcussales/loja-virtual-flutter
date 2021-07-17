import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:loja_virtual_flutter/screens/login_screen.dart';
import 'package:loja_virtual_flutter/screens/order_screen.dart';
import 'package:loja_virtual_flutter/tiles/cart_tile.dart';
import 'package:loja_virtual_flutter/widgets/cart_price.dart';
import 'package:loja_virtual_flutter/widgets/discount_card.dart';
import 'package:loja_virtual_flutter/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meu carrinho'),
          centerTitle: true,
          actions: [
            Container(
                padding: EdgeInsets.only(right: 10.0),
                alignment: Alignment.center,
                child: ScopedModelDescendant<CartModel>(
                  builder: (context, child, model) {
                    int totalProducts = model.products.length;
                    return Text(
                      '${totalProducts ?? 0} ${totalProducts == 1 ? 'ITEM' : 'ITENS'}',
                      style: TextStyle(fontSize: 17.0),
                    );
                  },
                ))
          ],
        ),
        body:
            ScopedModelDescendant<CartModel>(builder: (context, child, model) {
          if (model.loading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    color: Theme.of(context).primaryColor,
                    size: 80.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Faça o login para adicionar produtos ao carrinho',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  RaisedButton(
                    child: Text('Entrar', style: TextStyle(fontSize: 18.0)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                  )
                ],
              ),
            );
          } else if (model.products == null || model.products.length == 0) {
            return Center(
                child: Text('Ops... seu carrinho está vazio',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center));
          }
          return ListView(
            children: [
              Column(
                children: model.products.map((product) {
                  return CartTile(product);
                }).toList(),
              ),
              DiscountCard(),
              ShipCard(),
              CartPrice(() async {
                String orderId = await model.finishOrder();
                if (orderId != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => OrderScreen(orderId)));
                }
              })
            ],
          );
        }));
  }
}
