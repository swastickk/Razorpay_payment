import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Razorpaypayment extends StatefulWidget {
  const Razorpaypayment({super.key});

  @override
  State<Razorpaypayment> createState() => _RazorpaypaymentState();
}

class _RazorpaypaymentState extends State<Razorpaypayment> {

  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount)async{
    amount = amount*100;
    var options = {
      'key': 'rzp_test_oc0acCsubXjfUf',
      'amount': amount,
      'name': 'Swastick',
      'Prefill': {'contact' : '7703998297', 'email': 'swastickkashyap@gmail.com'},
      'external':{
        'wallets': ['paytm']
      }
    };
    try{
      _razorpay.open(options);
    }catch(ex){
      debugPrint("erro : e");
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response){
    showToast("Payment failed" + response.paymentId!);
  }
  void handlePaymentError(PaymentFailureResponse response){
    showToast("Payment failed" + response.message!);
  }
  void handleExternalWallet(ExternalWalletResponse response){
    showToast("Payment failed" + response.walletName!);
  }

  @override
  void dispose() {

    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,handleExternalWallet);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar:AppBar(
        title: Text("RazorpayPayment Gateway"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: amtController,

                  autofocus: false,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(

                    hintText: "Enter the amount to be paid",
                    suffixIcon: Icon(Icons.money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,

                      )
                    ),


                  ),

                ),
              ),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                if(amtController.text.toString().isNotEmpty){
                  setState(() {
                    int amount = int.parse(amtController.text.toString());
                    openCheckout(amount);
                  });
                }

              }, child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Make Payment"),
              )),

            ],
          ),
        ),
      ),
    );


  }
}
