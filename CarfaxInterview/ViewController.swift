//
//  ViewController.swift
//  CarfaxInterview
//
//  Created by Dhrumil Desai on 2021-11-19.
//

import UIKit

class ViewController: UIViewController {

    var listings: Array<Dictionary<String,Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonString = "https://carfax-for-consumers.firebaseio.com/assignment.json"
        guard let url = URL(string: jsonString) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode != 200) {
                    print("error")
                }
            }
            
            if let myData = data {
                if let json = try? (JSONSerialization.jsonObject(with: myData, options: []) as! Dictionary<String,Any>) {
                    if let myListings = json["listings"] as? Array<Dictionary<String,Any>> {
                        self.listings = myListings
                        DispatchQueue.main.sync {
                            print(self.listings)
                        }
                    }
                }
            }
        }
        session.resume()
    }
}

