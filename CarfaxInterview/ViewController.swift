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
                        }
                    }
                }
            }
        }
        session.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width
        return CGSize(width: cellWidth, height: cellWidth*0.8)
    }
}

