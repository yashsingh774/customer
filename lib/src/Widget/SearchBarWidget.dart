import 'package:flutter/material.dart';
import 'package:foodexpress/src/Widget/SearchWidget.dart';

class SearchBarPage extends StatelessWidget {
  const SearchBarPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SearchModal());
      },
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            color: Colors.white70,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Theme.of(context).accentColor),
            ),
            Expanded(
              child: Text(
                'Search for markets or Products',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .merge(TextStyle(fontSize: 12)),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
