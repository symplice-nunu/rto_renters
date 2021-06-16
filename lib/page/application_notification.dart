import 'package:flutter/material.dart';
import '../screens/application_screen.dart';

class ApplicationNotification extends StatelessWidget {
  final String payload;

  const ApplicationNotification({
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
                'House Application',
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
                
                    'Your application to rent house  was sent successfuly. wait response from house owner to confirm your application.',
                    
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: Text(
                
                    'If house owner accepted your application, you will receive notification that your confirmed confirmed.',
                    
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  
                ),
              
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
                  Navigator.pushNamed(context, ApplicationScreen.routeName);
                }
                
              ),
            ],
          ),
        ),
      );
}
