import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../page/second_page.dart';
import '../local_notications_helper.dart';
import '../providers/cancel.dart';
import '../providers/houses.dart';

class EditCancelScreen extends StatefulWidget {
  static const routeName = '/edit-cancel';

  @override
  _EditCancelScreenState createState() => _EditCancelScreenState();
}

class _EditCancelScreenState extends State<EditCancelScreen> {
  final notifications = FlutterLocalNotificationsPlugin();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedCancel = Cancel(
    id: null,
    name: '',
    houseno: '',
    status: '',
    reasons: '',
    date: '',
  );
  var _initValues = {
    'name': '',
    'houseno': '',
    'status': '',
    'reasons': '',
    'date': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
      final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final cancelId = ModalRoute.of(context).settings.arguments as String;
      if (cancelId != null) {
        _editedCancel =
            Provider.of<Houses>(context, listen: false).findByIdd(cancelId);
        _initValues = {
          'name': _editedCancel.name,
          'houseno': _editedCancel.houseno,
          'reasons': _editedCancel.reasons,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedCancel.id != null) {
      await Provider.of<Houses>(context, listen: false)
          .updateCancel(_editedCancel.id, _editedCancel);
    } else {
      try {
        await Provider.of<Houses>(context, listen: false)
            .addCancel(_editedCancel);
            showOngoingNotification(notifications,
                  title: 'Cancel Rent Agreement', body: 'Your request to cancel house rent agreement was sent successfuly. wait response from house owner');
          
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
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }
  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Request'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send_outlined),
            onPressed: (){
              _saveForm();
            }  
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['name'],
                      decoration: InputDecoration(labelText: 'Names'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide Your Names.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCancel = Cancel(
                            name: value,
                            houseno: _editedCancel.houseno,
                            status: _editedCancel.status,
                            reasons: _editedCancel.reasons,
                            date: _editedCancel.date,
                            id: _editedCancel.id,
                            isFavorite: _editedCancel.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['houseno'],
                      decoration: InputDecoration(labelText: 'House Id'),
                      textInputAction: TextInputAction.next,
                      // keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                     validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a House Id.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCancel = Cancel(
                            name: _editedCancel.name,
                            houseno: value,
                            status: _editedCancel.status,
                            reasons: _editedCancel.reasons,
                            date: _editedCancel.date,
                            id: _editedCancel.id,
                            isFavorite: _editedCancel.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['reasons'],
                      decoration: InputDecoration(labelText: 'Reasons'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a Reasons.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCancel = Cancel(
                            name: _editedCancel.name,
                            houseno: _editedCancel.houseno,
                            status: _editedCancel.status,
                            reasons: value,
                            date: _editedCancel.date,
                          id: _editedCancel.id,
                          isFavorite: _editedCancel.isFavorite,
                        );
                      },
                    ),
            //        RaisedButton(
            //   child: Text('Show notification'),
            //   onPressed: () {
            //     showOngoingNotification(notifications,
            //       title: 'Tite', body: 'nono');
            //       _saveForm();
            //   }
                  
            // ),
                  ],
                ),
              ),
            ),
    );
  }
}
