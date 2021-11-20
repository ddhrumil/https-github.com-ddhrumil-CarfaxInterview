//
//  ViewController.swift
//  CarfaxInterview
//
//  Created by Dhrumil Desai on 2021-11-19.
//

import UIKit


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //Collection view outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Varible for Api data
    var listings: Array<Dictionary<String,Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
        
        //Api url
        let jsonString = "https://carfax-for-consumers.firebaseio.com/assignment.json"
        guard let url = URL(string: jsonString) else { return }
        
        //Getting data from api
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode != 200) {
                    print("error")
                }
            }
            
            //Serializing data from api through JSONSerialization
            if let myData = data {
                if let json = try? (JSONSerialization.jsonObject(with: myData, options: []) as! Dictionary<String,Any>) {
                    if let myListings = json["listings"] as? Array<Dictionary<String,Any>> {
                        self.listings = myListings
                        DispatchQueue.main.async {
                            //print(self.listings)
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        session.resume()
    }
    
    //Mandatory Collection View functions to display data
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = listings[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
        
        //Displaying data in respective labels
        if let year = row["year"] as? Int {
            if let make = row["make"] as? String {
                if let model = row["model"] as? String {
                    if let trim = row["trim"] as? String {
                        cell.carModelOutlet.text = ((String(year)) + "  " + make + "  " + model + "  |  " + trim)
                    }
                }
            }
        }

        
        if let price = row["currentPrice"] as? Float {
            if let mileage = row["mileage"] as? Float {
                if let dealer = row["dealer"] as? Dictionary<String,Any> {
                    let phoneNumber = dealer["phone"] as? String
                    //print(phoneNumber)
                    cell.dealerNumber.setTitle("+1" + (phoneNumber)!, for: .normal)
                    
                    let stateLocation = dealer["state"] as? String
                    let cityLocation = dealer["city"] as? String
                    
                    cell.priceMiOutlet.text = ("$" + (String(price)) + "  |  " + (String(mileage) + " Mi") + "  |  " + (cityLocation ?? "") + ", " + (stateLocation ?? ""))
                }
            }
        }
        
        //Fetching image urls and displaying to image view
        if let images = row["images"] as? Dictionary<String,Any> {
            print(images)

            if let firstPhoto = images["firstPhoto"] as? Dictionary<String,Any> {
                let finalImgUrl = firstPhoto["medium"] as? String
                cell.imageOutlet.downloaded(from: finalImgUrl ?? "")
                cell.imageOutlet.contentMode = .scaleAspectFill
            }
        }
        return cell
    }
    
    
    //function for resizing cell width and cell height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 400)
    }
     
}

