//
//  KunCell.swift
//  Weather app
//
//  Created by Abdusamad Mamasoliyev on 11/10/23.
//

import UIKit

class KunCell: UICollectionViewCell {

    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLbl: UILabel!
    
    static var identifier: String = String(describing: KunCell.self)
    static var cellNib = UINib(nibName: identifier, bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(day: ForecastDay) {
        
        let epochTime = day.date_epoch
        let date = Date(timeIntervalSince1970: TimeInterval(epochTime))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date)
        
        dayLbl.text = weekDay
        tempLbl.text = "\(Int(day.day.mintemp_c)) / \(Int(day.day.maxtemp_c))"
        
        
        weatherImage.setImage(by: URL(string: "https:" + day.day.condition.icon))
    }
    
}
