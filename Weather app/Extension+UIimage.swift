//
//  Extension+UIimage.swift
//  Weather app
//
//  Created by Abdusamad Mamasoliyev on 19/10/23.
//

import UIKit

extension UIImageView {
    
    func setImage(by url: URL?) {
        
        guard let url else { return }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { date, response, error in
            
            guard let date, error == nil else {
                return
            }
            
            let image = UIImage(data: date)
            DispatchQueue.main.async {
                self.image = image
            }
            
        }.resume()
    }
}
