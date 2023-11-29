import 'package:flutter/material.dart';
import 'package:flutter_payment_methods/stripe_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Stripe Checkout'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Center(
          child: TextButton(
              onPressed: () async{
                var items  = [
                  {
                    "productPrice":5,
                    "productName":"Apple",
                    "qty":5
                  },
                  {
                    "productPrice":5,
                    "productName":"Orange",
                    "qty":10
                  },
                ];
                
                await StripeService.stripePaymentCheckout(items, 500, context,
                  mounted,
                  onSuccess: (){
                    print('SUCCESS');
                  },
                  onCancel: (){
                    print('CANCEL');
                  },
                  onError: (e){
                    print('ERROR: '+e.toString());
                  }
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3))
                )
              ),
              child: const Text("Checkout")),
        )
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
