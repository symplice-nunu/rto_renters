import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/houses.dart';
import '../widgets/user_cancel_item.dart';
import '../widgets/app_drawer.dart';
import 'edit_cancel_screen.dart';

class UserCancelsScreen extends StatelessWidget {
  static const routeName = '/user-cancels';

  Future<void> _refreshCancels(BuildContext context) async {
    await Provider.of<Houses>(context, listen: false)
        .fetchAndSetCancels(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Request'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(EditCancelScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshCancels(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshCancels(context),
                    child: Consumer<Houses>(
                      builder: (ctx, cancelsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: cancelsData.itemss.length,
                              itemBuilder: (_, i) => Column(
                                    children: [
                                      UserCancelItem(
                                        cancelsData.itemss[i].id,
                                        cancelsData.itemss[i].name,
                                      ),
                                      Divider(),
                                    ],
                                  ),
                            ),
                          ),
                    ),
                  ),
      ),
    );
  }
}
