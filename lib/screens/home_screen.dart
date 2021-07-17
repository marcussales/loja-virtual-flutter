import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/tabs/home_tab.dart';
import 'package:loja_virtual_flutter/tabs/orders_tab.dart';
import 'package:loja_virtual_flutter/tabs/products_tab.dart';
import 'package:loja_virtual_flutter/tabs/shops_tab.dart';
import 'package:loja_virtual_flutter/widgets/cart_button.dart';
import 'package:loja_virtual_flutter/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Produtos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Lojas parceiras'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ShopsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("Meus pedidos"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: OrdersTab())
      ],
    );
  }
}
