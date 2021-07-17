import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _pswdController = TextEditingController();
    final TextEditingController _addressController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    void _onSuccess() {
      print('batatinha');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Usuário criado com sucesso!'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ));

      Future.delayed(Duration(seconds: 2)).then((value) {
        Navigator.of(context).pop();
      });
    }

    void _onFailed() {
      print('abobora');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Falha ao criar o usuário'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Criar conta'),
          centerTitle: true,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.loading)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Nome completo'),
                    validator: (text) {
                      if (text.isEmpty) {
                        return "Preencha o nome!";
                      }
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@")) {
                        return "Email inválido!";
                      }
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _pswdController,
                    decoration: InputDecoration(hintText: 'Senha'),
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6) {
                        return "Senha inválida!";
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(hintText: 'Endereço'),
                    validator: (text) {
                      if (text.isEmpty) {
                        return "Preencha o endereço!";
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      onPressed: () {
                        Map<String, dynamic> userData = {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'address': _addressController.text
                        };
                        if (_formKey.currentState.validate()) {
                          model.signUp(
                              userData: userData,
                              pswd: _pswdController.text,
                              onSuccess: _onSuccess,
                              onFailed: _onFailed);
                        }
                      },
                      child: Text(
                        'Criar conta',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ));
        }));
  }
}
