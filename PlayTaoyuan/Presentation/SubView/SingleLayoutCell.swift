//
//  SingleLayoutCell.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import UIKit

class SingleLayoutCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5
    }

    func setupData(data:String) {
        lblTitle.text = data
    }
}
