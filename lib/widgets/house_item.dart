import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/house_detail_screen.dart';
import '../providers/house.dart';
import '../providers/approom.dart';
import '../providers/auth.dart';

class HouseItem extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final house = Provider.of<House>(context, listen: false);
    final room = Provider.of<Room>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              HouseDetailScreen.routeName,
              arguments: house.id,
            );
          },
          child: Hero(
            tag: house.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(house.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<House>(
            builder: (ctx, product, _) => IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    product.toggleFavoriteStatus(
                      authData.token,
                      authData.userId,
                    );
                  },
                ),
          ),
          title: Text(
            house.villagename,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.house_siding,
            ),
            onPressed: () {
              room.addItem(house.id, house.price, house.houseno, house.villagename, house.houselocation, house.ehouseno, house.housedescription, house.houselocation, house.roomno, house.kitchenno, house.saloonno, house.imageUrl, house.tbno);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'House Added in application room',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      room.removeSingleItem(house.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
