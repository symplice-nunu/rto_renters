
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:rto_renters/services/payment_service.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'add_credit_card.dart';
import '../providers/houses.dart';
import '../providers/payments.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../local_notications_helper.dart';
import '../page/payment_notification.dart';

class ExistingCardPage extends StatefulWidget {
  static const routeName = '/existing_card';
  ExistingCardPage({Key key}) : super(key: key);

  @override
  ExistingCardPageState createState() => ExistingCardPageState();
}

class ExistingCardPageState extends State<ExistingCardPage> {
  final notifications = FlutterLocalNotificationsPlugin();
  // final _priceFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  // final _imageUrlController = TextEditingController();
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedPayments = Payments(
    id: null,
    cardNumber: '',
    cardHolderName: '',
    expiryDate: '',
    cvvCode: '',
    amount: '',
    date: '',
  );
  // ignore: unused_field
  var _initValues = {
    'cardNumber': '',
    'cardHolderName': '',
    'expiryDate': '',
    'cvvCode': '',
    'amount': '',
    'date': '',
  };
  
  var _isInit = true;
  // ignore: unused_field
  var _isLoading = false;

  
  @override
  void initState() {
    super.initState();
    StripeService.init();
      final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentNotification(payload: payload)),
      );
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final paymentsId = ModalRoute.of(context).settings.arguments as String;
      if (paymentsId != null) {
        _editedPayments =
            Provider.of<Houses>(context, listen: false).findByIda(paymentsId);
        _initValues = {
          'cardNumber': '',
          'cardHolderName': '',
          'expiryDate': '',
          'cvvCode': '',
          'amount': '',
          'date': '',
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // @override
  // void dispose() {
  //   _imageUrlFocusNode.removeListener(_updateImageUrl);
  //   _priceFocusNode.dispose();
  //   _descriptionFocusNode.dispose();
  //   _imageUrlController.dispose();
  //   _imageUrlFocusNode.dispose();
  //   super.dispose();
  // }

  // void _updateImageUrl() {
  //   if (!_imageUrlFocusNode.hasFocus) {
  //     if ((!_imageUrlController.text.startsWith('http') &&
  //             !_imageUrlController.text.startsWith('https')) ||
  //         (!_imageUrlController.text.endsWith('.png') &&
  //             !_imageUrlController.text.endsWith('.jpg') &&
  //             !_imageUrlController.text.endsWith('.jpeg'))) {
  //       return;
  //     }
  //     setState(() {});
  //   }
  // }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedPayments.id != null) {
      // await Provider.of<Houses>(context, listen: false)
      //     .updateCancel(_editedPayments.id, _editedPayments);
    } else {
      try {
        await Provider.of<Houses>(context, listen: false)
            .payMoney(_editedPayments);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred!'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'INTWARI Symplice',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555555555554444',
      'expiryDate': '04/23',
      'cardHolderName': 'INTWARI Symplice',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];
   payViaExistingCard(BuildContext context, card) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
      message: 'Please wait...'
    );
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
      amount: '350',
      currency: 'USD',
      card: stripeCard
    );
    await dialog.hide();
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        )
      ).closed.then((_) {
        Navigator.pop(context);
      });
      showOngoingNotification(notifications,
                  title: 'Monthly Payment', body: 'Your monthly house Payment of 350 USD to House Owner has been completed successfuly.');

                  _saveForm();
                 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose existing card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            var card = cards[index];
            return InkWell(
              onTap: () {
                payViaExistingCard(context, card);
                
              },
              child: CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'], 
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: false,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, MySampleAddCreditCard.routeName);

        },
        // tooltip: 'Submit',
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
