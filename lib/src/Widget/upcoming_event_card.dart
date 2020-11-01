import 'package:flutter/material.dart';
import 'package:foodexpress/models/event_model.dart';
import 'package:foodexpress/src/Widget/ui_helper.dart';
import 'package:foodexpress/src/shared/colors.dart';
import 'package:foodexpress/src/shared/text_style.dart';
import 'package:foodexpress/src/utils/datetime_utils.dart';


class UpComingEventCard extends StatelessWidget {
  final Event event;
  final Function onTap;
  UpComingEventCard(this.event, {this.onTap});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final height = MediaQuery.of(context).size.height / 0.8;
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: <Widget>[
          Expanded(child: buildImage()),
          UIHelper.verticalSpace(10),
          buildEventInfo(context),
        ],
      ),
    );
  }

  Widget buildImage() {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: imgBG,
          width: double.infinity,
          height: 200,
          child: Hero(
            tag: event.image,
            child: Image.network(
              event.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEventInfo(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("${DateTimeUtils.getMonth(event.eventDate)}", style: monthStyle),
                Text("${DateTimeUtils.getDayOfMonth(event.eventDate)}", style: titleStyle),
              ],
            ),
          ),
          UIHelper.horizontalSpace(16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.name, style: titleStyle),
              UIHelper.verticalSpace(4),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, size: 16, color: Theme.of(context).primaryColor),
                  UIHelper.horizontalSpace(4),
                  Text(event.location.toUpperCase(), style: subtitleStyle),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
