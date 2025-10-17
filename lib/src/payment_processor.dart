// CANDIDATE TASK: Refactor this class to follow OOP principles, SOLID principles, and apply appropriate design patterns

import 'dart:convert';
import 'dart:io';

class PaymentProcessor {
  String apiKey = "sk_test_12345"; // API key for payment gateway
  String logFilePath = "payment_logs.txt";
  List<String> processedTransactions = [];
  
  // Process a payment based on payment type
  void processPayment(String paymentType, double amount, String currency, 
                      String customerEmail, Map<String, dynamic> paymentDetails) {
    
    // Validate amount
    if (amount <= 0) {
      print("Error: Invalid amount");
      writeLog("ERROR: Invalid amount $amount for $customerEmail");
      return;
    }
    
    // Validate email
    if (!customerEmail.contains("@")) {
      print("Error: Invalid email");
      writeLog("ERROR: Invalid email $customerEmail");
      return;
    }
    
    // Process based on payment type
    if (paymentType == "credit_card") {
      // Validate card details
      if (!paymentDetails.containsKey("card_number") || 
          !paymentDetails.containsKey("cvv") ||
          !paymentDetails.containsKey("expiry")) {
        print("Error: Missing card details");
        return;
      }
      
      // Make API call to credit card processor
      print("Processing credit card payment...");
      var response = makeHttpRequest(
        "https://api.cardprocessor.com/charge",
        {
          "amount": amount,
          "currency": currency,
          "card_number": paymentDetails["card_number"],
          "cvv": paymentDetails["cvv"],
          "expiry": paymentDetails["expiry"],
          "api_key": apiKey,
        }
      );
      
      if (response["status"] == "success") {
        print("Credit card payment successful!");
        processedTransactions.add("CC-${DateTime.now().millisecondsSinceEpoch}");
        writeLog("SUCCESS: Credit card payment of $amount $currency for $customerEmail");
        sendEmail(customerEmail, "Payment Successful", "Your payment of $amount $currency was processed.");
      } else {
        print("Credit card payment failed!");
        writeLog("FAILED: Credit card payment of $amount $currency for $customerEmail");
        sendEmail(customerEmail, "Payment Failed", "Your payment could not be processed.");
      }
      
    } else if (paymentType == "paypal") {
      // Validate PayPal details
      if (!paymentDetails.containsKey("paypal_email")) {
        print("Error: Missing PayPal email");
        return;
      }
      
      // Make API call to PayPal
      print("Processing PayPal payment...");
      var response = makeHttpRequest(
        "https://api.paypal.com/payment",
        {
          "amount": amount,
          "currency": currency,
          "paypal_email": paymentDetails["paypal_email"],
          "api_key": apiKey,
        }
      );
      
      if (response["status"] == "success") {
        print("PayPal payment successful!");
        processedTransactions.add("PP-${DateTime.now().millisecondsSinceEpoch}");
        writeLog("SUCCESS: PayPal payment of $amount $currency for $customerEmail");
        sendEmail(customerEmail, "Payment Successful", "Your PayPal payment of $amount $currency was processed.");
      } else {
        print("PayPal payment failed!");
        writeLog("FAILED: PayPal payment of $amount $currency for $customerEmail");
        sendEmail(customerEmail, "Payment Failed", "Your PayPal payment could not be processed.");
      }
      
    } else if (paymentType == "bank_transfer") {
      // Validate bank details
      if (!paymentDetails.containsKey("account_number") || 
          !paymentDetails.containsKey("routing_number")) {
        print("Error: Missing bank details");
        return;
      }
      
      // Make API call to bank
      print("Processing bank transfer...");
      var response = makeHttpRequest(
        "https://api.bank.com/transfer",
        {
          "amount": amount,
          "currency": currency,
          "account_number": paymentDetails["account_number"],
          "routing_number": paymentDetails["routing_number"],
          "api_key": apiKey,
        }
      );
      
      if (response["status"] == "success") {
        print("Bank transfer successful!");
        processedTransactions.add("BT-${DateTime.now().millisecondsSinceEpoch}");
        writeLog("SUCCESS: Bank transfer of $amount $currency for $customerEmail");
        sendEmail(customerEmail, "Payment Successful", "Your bank transfer of $amount $currency was processed.");
      } else {
        print("Bank transfer failed!");
        writeLog("FAILED: Bank transfer of $amount $currency for $customerEmail");
        sendEmail(customerEmail, "Payment Failed", "Your bank transfer could not be processed.");
      }
      
    } else {
      print("Error: Unsupported payment type");
      writeLog("ERROR: Unsupported payment type $paymentType");
    }
  }
  
  // Make HTTP request
  Map<String, dynamic> makeHttpRequest(String url, Map<String, dynamic> data) {
    // Simulate HTTP request
    print("Making request to $url");
    print("Data: ${jsonEncode(data)}");
    
    // Simulate response (in real scenario, this would be actual HTTP call)
    return {"status": "success", "transaction_id": "txn_${DateTime.now().millisecondsSinceEpoch}"};
  }
  
  // Write to log file
  void writeLog(String message) {
    var file = File(logFilePath);
    var timestamp = DateTime.now().toIso8601String();
    file.writeAsStringSync("[$timestamp] $message\n", mode: FileMode.append);
    print("Log written: $message");
  }
  
  // Send email notification
  void sendEmail(String to, String subject, String body) {
    print("Sending email to $to");
    print("Subject: $subject");
    print("Body: $body");
    // Simulate email sending
    writeLog("Email sent to $to: $subject");
  }
  
  // Get all processed transactions
  List<String> getProcessedTransactions() {
    return processedTransactions;
  }
  
  // Calculate total fees (2.9% + $0.30 per transaction)
  double calculateFees(double amount) {
    return (amount * 0.029) + 0.30;
  }
  
  // Apply discount based on customer tier
  double applyDiscount(double amount, String customerTier) {
    if (customerTier == "gold") {
      return amount * 0.95; // 5% discount
    } else if (customerTier == "silver") {
      return amount * 0.97; // 3% discount
    } else if (customerTier == "bronze") {
      return amount * 0.99; // 1% discount
    }
    return amount;
  }
}

// Example usage
void main() {
  var processor = PaymentProcessor();
  
  // Process a credit card payment
  processor.processPayment(
    "credit_card",
    100.00,
    "USD",
    "customer@example.com",
    {
      "card_number": "4242424242424242",
      "cvv": "123",
      "expiry": "12/25",
    }
  );
  
  // Process a PayPal payment
  processor.processPayment(
    "paypal",
    50.00,
    "USD",
    "customer@example.com",
    {
      "paypal_email": "customer@paypal.com",
    }
  );
}
