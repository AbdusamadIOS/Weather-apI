//
//  SearchCity.swift
//  Weather app
//
//  Created by Abdusamad Mamasoliyev on 20/10/23.
//

import UIKit

class SearchCity: UIViewController {

    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        saveBtn.layer.cornerRadius = 15
        saveBtn.layer.borderColor = UIColor.black.cgColor
        saveBtn.layer.borderWidth = 1
        
    }


    

}
