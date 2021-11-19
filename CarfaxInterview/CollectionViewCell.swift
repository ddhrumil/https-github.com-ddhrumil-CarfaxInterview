//
//  CollectionViewCell.swift
//  CarfaxInterview
//
//  Created by Dhrumil Desai on 2021-11-19.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var yearOutlet: UILabel!
    
    
    @IBOutlet weak var makeOutlet: UILabel!
    
    @IBOutlet weak var modelOutlet: UILabel!
    
    
    @IBOutlet weak var trimOutlet: UILabel!
    
    @IBOutlet weak var priceOutlet: UILabel!
    
    @IBOutlet weak var mileageOutlet: UILabel!
    
    @IBOutlet weak var locationOutlet: UILabel!
    
    @IBOutlet weak var phoneOutlet: UILabel!
    
    @IBOutlet weak var imageOutlet: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func CallDealer(_ sender: Any) {
    }
    
}
