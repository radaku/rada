import 'package:flutter/material.dart';

class PaymentModel {
  String _icon;
  String _name, _date, _hour;
  Color _color;
  IconData _amount;
  int _paymentType;

  PaymentModel(this._icon, this._color, this._name, this._date, this._hour,
      this._amount, this._paymentType);

  String get name => _name;

  String get date => _date;

  String get hour => _hour;

  IconData get amount => _amount;

  int get type => _paymentType;

  String get icon => _icon;

  Color get color => _color;
}
