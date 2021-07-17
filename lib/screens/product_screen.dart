import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/datas/cart_product.dart';
import 'package:loja_virtual_flutter/datas/product_data.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:loja_virtual_flutter/screens/cart_screen.dart';
import 'package:loja_virtual_flutter/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);
  @override
  _ProductScreenState createState() => _ProductScreenState(this.product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String size;
  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(product.title),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 0.9,
              child: Carousel(
                images: product.images.map((url) => NetworkImage(url)).toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: true,
                autoplayDuration: Duration(milliseconds: 5000),
                animationCurve: Curves.fastOutSlowIn,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.title,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                    maxLines: 3,
                  ),
                  Text("R\$ ${product.price.toStringAsFixed(2)}.",
                      style: TextStyle(
                          fontSize: 22.0,
                          color: primaryColor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Tamanho',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 34.0,
                    child: GridView(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.5),
                        children: product.sizes
                            .map((s) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      size = s;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                        border: Border.all(
                                            color: s != size
                                                ? Colors.grey[500]
                                                : primaryColor,
                                            width: 3.0)),
                                    width: 50.0,
                                    alignment: Alignment.center,
                                    child: Text(s),
                                  ),
                                ))
                            .toList()),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      onPressed: size != null
                          ? () {
                              if (UserModel.of(context).isLoggedIn()) {
                                CartProduct cartProduct = CartProduct();
                                cartProduct.size = size;
                                cartProduct.quantity = 1;
                                cartProduct.pid = product.id;
                                cartProduct.category = product.category;
                                cartProduct.productData = product;
                                CartModel.of(context).addCartItem(cartProduct);
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: (Text(
                                      'Produto adicionado ao carrinho com sucesso')),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: primaryColor,
                                ));
                                Future.delayed(Duration(seconds: 2))
                                    .then((value) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CartScreen()));
                                });
                                return;
                              }
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: (Text(
                                    'Você será redirecionado para a tela de login :)')),
                                duration: Duration(seconds: 2),
                                backgroundColor: primaryColor,
                              ));
                              Future.delayed(Duration(seconds: 2))
                                  .then((value) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              });
                            }
                          : null,
                      child: Text(
                        UserModel.of(context).isLoggedIn()
                            ? 'Adicionar ao carrinho'
                            : 'Entre para comprar',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      color: primaryColor,
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text('Descrição',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
