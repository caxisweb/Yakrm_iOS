import UIKit

//TODO: This class uses our test integration server; please adapt it to use your own backend API.
class Request: NSObject {

    // Test merchant server domain
    static let serverDomain = "http://52.59.56.185:80"//"http://test.yakrm.com/api/checkout"//

    static func requestCheckoutID(amount: Double, currency: String, completion: @escaping (String?) -> Void) {
        let parameters: [String: String] = [
                "amount": String(format: "%.2f", amount),
                "currency": currency,
                "shopperResultUrl": Config.schemeURL + "://payment",
                // Store notificationUrl on your server to change it any time without updating the app.
                "notificationUrl": serverDomain + "/notification",
                "paymentType": "PA",
                "testMode": "INTERNAL"
        ]
        var parametersString = ""
        for (key, value) in parameters {
            parametersString += key + "=" + value + "&"
        }
        parametersString.remove(at: parametersString.index(before: parametersString.endIndex))

        let url = serverDomain + "/token?" + parametersString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //https://YOUR_URL/?amount=100&currency=EUR&paymentType=DB
//        let url = "http://test.yakrm.com/api/checkout" //+ parametersString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let request = NSURLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String: Any]??) {
                let checkoutID = json!["checkoutId"] as? String//checkoutId
                completion(checkoutID)
            } else {
                completion(nil)
            }
        }.resume()
    }

    static func requestPaymentStatus(resourcePath: String, completion: @escaping (Bool, String) -> Void) {
//        let url = serverDomain + "/status?resourcePath=" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = serverDomain + "/status?resourcePath=" + resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let request = NSURLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String: Any]??) {
                print(json)
                let transactionStatus = json!["paymentResult"] as? String
                let transactionID: String = (json!["id"] as? String)!
                completion(transactionStatus == "OK", transactionID)
            } else {
                completion(false, "")
            }
        }.resume()
    }

}
