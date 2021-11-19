//
//  ViewController.swift
//  CarfaxInterview
//
//  Created by Dhrumil Desai on 2021-11-19.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listings: Array<Dictionary<String,Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
        
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
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        session.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = listings[indexPath.row]
        //print(row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
        if let make = row["make"] as? String {
            cell.makeOutlet.text = make
        }
        
        if let model = row["model"] as? String {
            cell.modelOutlet.text = model
        }
        if let year = row["year"] as? Int {
            cell.yearOutlet.text = String(year)
        }
       
        if let trim = row["trim"] as? String {
            cell.trimOutlet.text = trim
        }
        
        if let price = row["currentPrice"] as? Float {
            cell.priceOutlet.text = "$" + String(price)
        }
        
        if let mileage = row["mileage"] as? Float {
            cell.mileageOutlet.text = String(mileage) + " Mi"
        }

        if let dealer = row["dealer"] as? Dictionary<String,Any> {
            let phoneNumber = dealer["phone"] as? String
            cell.phoneOutlet.text = phoneNumber
            
            let stateLocation = dealer["state"] as? String
            let cityLocation = dealer["city"] as? String
            //print(cityLocation)
            cell.locationOutlet.text = (cityLocation ?? "") + ", " + (stateLocation ?? "")
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width
        let cellHeight = collectionView.frame.size.height
        return CGSize(width: cellWidth, height: cellHeight * 0.4)
    }
}

