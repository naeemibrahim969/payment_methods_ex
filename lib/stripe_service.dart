import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService{

  static String secretKey = "sk_test_xxxx";
  static String publishableKey = "pk_test_xxxxx";


  static Future<dynamic> createCheckoutSession(List<dynamic> productItems,totalAmount) async{
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");

    String lineItems = "";
    int index = 0;
    for (var item in productItems) {
      var productPrice = (item["productPrice"] * 100).round().toString();
      lineItems += "&line_items[$index][price_data][product_data][name]=${item['productName']}";
      lineItems += "&line_items[$index][price_data][unit_amount]=$productPrice";
      lineItems += "&line_items[$index][price_data][currency]=USD";
      lineItems += "&line_items[$index][quantity]=${item['qty'].toString()}";

      index++;
    }

    final response = await http.post(
        url,
        body: 'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
        headers: { 'Authorization':'Bearer $secretKey','Content-Type':'application/x-www-form-urlencoded'}
    );

    return json.decode(response.body)['id'];
  }


  static Future<dynamic> stripePaymentCheckout(
      productItems,
      subTotal,
      context,
      mounted,{
        onSuccess,
        onCancel,
        onError
      }) async{

    final String sessionId = await createCheckoutSession(productItems, subTotal);

    final result = await redirectToCheckout(
        context: context,
        sessionId: sessionId,
        publishableKey: publishableKey,
        successUrl: "https://checkout.stripe.dev/success",
        canceledUrl: "https://checkout.stripe.dev/cancel"
    );

    if(mounted){
      final text = result.when(
          redirected: () => "Redirect Successfully",
          success: () => onSuccess(),
          canceled: () => onCancel(),
          error: (e) => onError()
      );

      return text;
    }

  }
}