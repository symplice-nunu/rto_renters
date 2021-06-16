import 'package:flutter/material.dart';
import '../screens/home.dart';

class PaymentNotification extends StatelessWidget {
  final String payload;

  const PaymentNotification({
    @required this.payload,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
                
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                'House Payment',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 25,
                   ),
                   textAlign: TextAlign.center,
                   softWrap: true,
              ),
              ),
              const SizedBox(height: 24),
              
              Divider(),
              const SizedBox(height: 24),
             
               Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: Text(
                
                    'Your monthly house Payment of 350 USD to House Owner has been completed successfuly. Thank you for using Credit Card',
                    
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  
                ),
                const SizedBox(height: 10),
                
              
              const SizedBox(height: 24),
              Divider(),
              const SizedBox(height: 24),
             
              Text(
                payload,
                style: Theme.of(context).textTheme.subtitle,
              ),
              const SizedBox(height: 8),
              RaisedButton(
                child: Text('Close',
                style: TextStyle(color: Colors.blueAccent),
                
                ),
                onPressed: () {
                  Navigator.pushNamed(context, HomePage.routeName);
                }
                
              ),
            ],
          ),
        ),
      );
}
