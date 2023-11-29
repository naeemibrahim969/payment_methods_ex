import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService{

  static Map<String,dynamic>? paymentIntent;
  static String secretKey = "sk_test_xxxxx";
  static String publishableKey = "pk_test_xxxxxx";


  static makePayment() async{
    try{
      paymentIntent = await createPaymentIntent();
      var googlePayment = PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: true,
        amount: "100",
      );

      print(paymentIntent!["client_secret"]);
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],

        style: ThemeMode.system,
        merchantDisplayName: "Naeem",

        googlePay: googlePayment
      ));

      displayPaymentSheet();

    }catch(e){
      print("MakePayment "+e.toString());
    }
  }

  static displayPaymentSheet() async{
    try{
      await Stripe.instance.presentPaymentSheet();
      print('DisplayPaymentSheet');
    }catch(e){
      print("DisplayPaymentSheet "+e.toString());
    }
  }

  static createPaymentIntent() async{
    try{
      Map<String,dynamic> body = {

        "amount" : (100*100).round().toString(),
        "currency": "USD"
      };

      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: { 'Authorization':'Bearer $secretKey','Content-Type':'application/x-www-form-urlencoded'}
      );
      return json.decode(response.body);
    }catch (e){
      throw Exception(e.toString());
    }
  }
}