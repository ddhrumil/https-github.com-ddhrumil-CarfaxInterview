//
//  CollectionViewCell.swift
//  Carfax
//
//  Created by Dhrumil Desai on 2021-11-18.
//

import UIKit


class CollectionViewCell: UICollectionViewCell {
    
    //Outlets for respective data

    @IBOutlet weak var imageOutlet: UIImageView!
    
    @IBOutlet weak var carModelOutlet: UILabel!
    
    @IBOutlet weak var priceMiOutlet: UILabel!
    

    @IBOutlet weak var dealerNumber: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //Code for calling the dealer
    @IBAction func CallDealer(_ sender: Any) {
        if let number = dealerNumber.titleLabel?.text {
            if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

    }
}
    
