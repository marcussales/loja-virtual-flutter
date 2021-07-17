import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:loja_virtual_flutter/screens/sign_up_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    void _onSuccess() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            'Olá ${UserModel.of(context).userData['name']}, seja bem vindo!'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ));

      Future.delayed(Duration(seconds: 2)).then((value) {
        Navigator.of(context).pop();
      });
    }

    void _onFailed() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Erro ao fazer o login'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Entrar'),
          centerTitle: true,
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Text(
                  'Criar conta',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ))
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          if (_emailController.text.isEmpty) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  'Para recuperar a senha, insira seu e-mail'),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            model.recoverPass(_emailController.text);
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  'Você acaba de receber um e-mail com link para recuperar a senha'),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 2),
                            ));
                          }
                        },
                        child: Text('Esqueci minha senha'),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            model.signIn(
                                email: _emailController.text,
                                pswd: _pswdController.text,
                                onSuccess: _onSuccess,
                                onFailed: _onFailed);
                          }
                        },
                        child: Text(
                          'Entrar',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ));
          },
        ));
  }
}
