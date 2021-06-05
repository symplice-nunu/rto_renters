import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/houses.dart';

class UserCancelItem extends StatelessWidget {
  final String id;
  final String name;
  

  UserCancelItem(this.id, this.name);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(name),
      // leading: CircleAvatar(
      //   backgroundImage: NetworkImage(imageUrl),
      // ),
      trailing: Container(
        width: 49,
        child: Row(
          children: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.edit),
            //   onPressed: () {
            //     Navigator.of(context)
            //         .pushNamed(EditProductScreen.routeName, arguments: id);
            //   },
            //   color: Theme.of(context).primaryColor,
            // ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () async {
                try {
                  await Provider.of<Houses>(context, listen: false)
                      .deleteCancel(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Cancel failed!', textAlign: TextAlign.center,),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
