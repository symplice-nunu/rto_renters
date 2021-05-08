import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rto_renters/screens/homee.dart';
import './screens/splash_screen.dart';
import './screens/cart_screen.dart';
import 'screens/houses_overview_screen.dart';
import 'screens/house_detail_screen.dart';
import 'providers/houses.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import 'screens/user_houses_screen.dart';
import 'screens/home.dart';
import 'screens/add_credit_card.dart';
import 'screens/existing_card.dart';
import 'screens/edit_house_screen.dart';
import './screens/auth_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Houses>(
          // ignore: deprecated_member_use
          builder: (ctx, auth, previousProducts) => Houses(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
          // ignore: deprecated_member_use
          builder: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Rent To Own Android System',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? HousesOverviewScreen()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? SplashScreen()
                : AuthScreen(),
          ),
          routes: {
            HouseDetailScreen.routeName: (ctx) => HouseDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserHousesScreen.routeName: (ctx) => UserHousesScreen(),
            ExistingCardPage.routeName: (ctx) => ExistingCardPage(),
            MySampleAddCreditCard.routeName: (ctx) => MySampleAddCreditCard(),
            HomePage.routeName: (ctx) => HomePage(),
            
            HomeePage.routeName: (ctx) => HomeePage(),
            EditHouseScreen.routeName: (ctx) => EditHouseScreen(),
          },
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:rto_renters/screens/add_credit_card.dart';
// import 'package:rto_renters/screens/existing_card.dart';
// import 'package:rto_renters/screens/home.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.teal
//       ),
//       initialRoute: '/home',
//       routes: {
//         '/home': (context) => HomePage(),
//         '/existing_card': (context) => ExistingCardPage(),
//         '/add_credit_card': (context) => MySampleAddCreditCard(),
//       },
//     );
//   }
// }

