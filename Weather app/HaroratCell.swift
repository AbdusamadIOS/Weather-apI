//
//  HaroratCell.swift
//  Weather app
//
//  Created by Abdusamad Mamasoliyev on 06/10/23.
//

import UIKit

class HaroratCell: UICollectionViewCell {

    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var saotlikKunImage: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var conteneirView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        conteneirView.layer.cornerRadius = 15
    }
    
    func updateCell(hour: Hour) {
        
        timeLbl.text = String(hour.time.suffix(5))
        tempLbl.text = "\(String(Int(hour.temp_c)))℃"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:00"
        let date = dateFormatter.string(from: Date())
        
        if date == hour.time.suffix(5) {
            self.conteneirView.layer.borderColor = UIColor.green.cgColor
            self.conteneirView.layer.borderWidth = 1
        }else {
            self.conteneirView.layer.borderWidth = 0
        }
        
        saotlikKunImage.setImage(by: URL(string: "https:" + hour.condition.icon))
    }
}
