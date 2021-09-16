//
//  ThreeRowsLayoutCell.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import UIKit

class ThreeRowsLayoutCell: UICollectionViewCell,HomeCellable {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(data:Info) {
        if let first = data.images.image.first{
            img.kf.setImage(with: URL(string: first.src))
        }else{
            img.image = nil
        }
        
        lblTitle.text = data.name
        lblDesc.text = data.infoDescription
    }
}
