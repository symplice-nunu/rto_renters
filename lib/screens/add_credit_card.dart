import 'package:flutter/material.dart';
import 'package:credit_card/credit_card_form.dart';
import 'package:credit_card/credit_card_model.dart';
import 'package:credit_card/flutter_credit_card.dart';


class MySampleAddCreditCard extends StatefulWidget {
  static const routeName = '/add_credit_card';
  MySampleAddCreditCard({Key key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return MySampleAddCreditCardState();
  }
  //  @override
  // MySampleAddCreditCardState createState() => MySampleAddCreditCardState();
}

class MySampleAddCreditCardState extends State<MySampleAddCreditCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {

    
      return Scaffold(
        // backgroundColor: Colors.lightGreenAccent,
       appBar: AppBar(
         
        title: Text('Add New Credit Card'),
        actions: <Widget>[
          IconButton(
            // color: Colors.yellow,
            icon: Icon(Icons.save), 
            onPressed: () { 
              // onPressed: _saveForm,
             },
            

            
          ),
        ],
      ),

    
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CreditCardForm(
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ),
              )
            ],
          ),
        ),
      );
   
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}