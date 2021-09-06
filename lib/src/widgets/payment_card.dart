import 'package:flutter/material.dart';
import 'package:radauon/src/models/payment_model.dart';

class PaymentCardWidget extends StatefulWidget {
  final PaymentModel payment;

  const PaymentCardWidget({Key key, this.payment}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentCardWidgetState();
}

class _PaymentCardWidgetState extends State<PaymentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        dense: true,
        /*trailing: Text(
          "${widget.payment.amount}",
          style: TextStyle(
              inherit: true,
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
              color: Colors.blue),
        ),*/
        trailing: Icon(
          widget.payment.amount,
          color: Colors.blue,
          size: 20,
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Material(
            elevation: 1,
            //shape: CircleBorder(),
            shadowColor: Colors.blue.withOpacity(0.4),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                //color: widget.payment.color,
                shape: BoxShape.rectangle,
              ),
              /*child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
              ),*/
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Image.asset(
                  //"assets/images/forum.png",
                  widget.payment.icon,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        ),
        /*leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Material(
            elevation: 10,
            shape: CircleBorder(),
            shadowColor: widget.payment.color.withOpacity(0.4),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: widget.payment.color,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),*/
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.payment.name,
              style: TextStyle(
                  inherit: true, fontWeight: FontWeight.w700, fontSize: 16.0),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.payment.date,
                  style: TextStyle(
                      inherit: true, fontSize: 12.0, color: Colors.black45)),
              SizedBox(
                width: 20,
              ),
              Text(widget.payment.hour,
                  style: TextStyle(
                      inherit: true,
                      fontSize: 12.0,
                      color: widget.payment.color)),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
