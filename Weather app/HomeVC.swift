//
//  HomeVC.swift
//  Weather app
//
//  Created by Abdusamad Mamasoliyev on 06/10/23.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tembLbl: UILabel!
    @IBOutlet weak var describtionLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet weak var nextDayCollectionView: UICollectionView!
    
    let editCity = ["Andijon", "Buxoro", "Farg'ona", "Jizzax",  "Namangan", "Nukus", "Samarqand", "Sirdaryo", "Surxondaryo", "Toshkent", "Urganch", "Xorazm"]
    let pickerView = UIPickerView()
    var city = "Andijon"
    var hours: [Hour] = []
    var days: [ForecastDay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentweather(for: city)
        getForecast(for: city, days: 3)
        setupDayCollectionView()
        setupNextDayCollectionView()
        setupNav()
        
    }
    
    func setupNav() {
        
        let location = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .done, target: self, action: #selector(location))

        navigationItem.leftBarButtonItem = location
        location.tintColor = UIColor.white
        navigationItem.hidesBackButton = true
        
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchBtn))
        let menu = UIBarButtonItem(image: UIImage(systemName: "filemenu.and.selection"), style: .done, target: self, action: #selector(menuBtn))
        
        
        search.tintColor = .white
        menu.tintColor = .white
        
        navigationItem.rightBarButtonItems = [ menu, search]
    }
   
    
    @objc func location() {
  
    }
    @objc func searchBtn() {
       
     let search = SearchCity(nibName: "SearchCity", bundle: nil)
        
        self.navigationController?.pushViewController(search, animated: true)
    }
    @objc func menuBtn() {
        addCity()
    }
    
    func addCity() {

        let alert = UIAlertController(title: "Viloyatlardan birini tanlang", message: "", preferredStyle: .alert)

          
          let pickerView = UIPickerView()
          pickerView.dataSource = self
          pickerView.delegate = self

         
          alert.addTextField { textField in
              textField.inputView = pickerView
              textField.placeholder = "Viloyat nomi"
          }
      
          
          let action = UIAlertAction(title: "OK", style: .default) { action in
              
              if let textField = alert.textFields?.first, let text = textField.text {
                  
                  print("Selected Item: \(text)")
              }
          }

          alert.addAction(action)

          present(alert, animated: true, completion: nil)
      }
 
    func setupDayCollectionView() {
        
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
        dayCollectionView.backgroundColor = UIColor(named: "col")
        dayCollectionView.layer.cornerRadius = 15
        dayCollectionView.layer.borderColor = UIColor.white.cgColor
        dayCollectionView.layer.borderWidth = 0.7
        dayCollectionView.register(UINib(nibName: "HaroratCell", bundle: nil), forCellWithReuseIdentifier: "HaroratCell")
        
    }
    
    func setupNextDayCollectionView() {
        
        nextDayCollectionView.delegate = self
        nextDayCollectionView.dataSource = self
        nextDayCollectionView.backgroundColor = UIColor(named: "col")
        nextDayCollectionView.layer.cornerRadius = 15
        nextDayCollectionView.layer.borderColor = UIColor.white.cgColor
        nextDayCollectionView.layer.borderWidth = 0.7
        nextDayCollectionView.register(KunCell.cellNib, forCellWithReuseIdentifier: KunCell.identifier)
    }
    
    func getCurrentweather(for city: String) {
        
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=11ffd290d26f4ebcb4854359230610&q=\(city)&days=1&aqi=no&alerts=no"
        
        guard let url = URL(string: urlString) else  {return }
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) {data, response, error in
            
            guard let data, error == nil else {
                
                DispatchQueue.main.async {
                    self.showAlert(with: error?.localizedDescription)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
               
                let weather = try decoder.decode(CurrentResponse.self, from: data)
              
                DispatchQueue.main.async {
                    self.UpdateUI(weather: weather)
            
                }
                
            } catch  {
                DispatchQueue.main.async {
                    self.showAlert(with: error.localizedDescription)
                }
                print("Error while serialization", error)
            }
        }
        task.resume()
        
    }
    
    func getForecast(for city: String, days: Int) {
        
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=11ffd290d26f4ebcb4854359230610&q=\(city)&days=\(days)"
        
        guard let url = URL(string: urlString) else {return }
        
        let request = URLRequest(url: url)
        
        let data: Void = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data, error == nil else{
                DispatchQueue.main.async {
                    self.showAlert(with: error?.localizedDescription)
                    print(error!)
                    
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
      
            switch response.statusCode {
            case 200:
                print("Success: Response Status Code:", response.statusCode)
                break
            case 400...410:
                let dataDictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
                
                if let error = dataDictionary["error"] as? [String: Any] {
                    DispatchQueue.main.async {
                        self.showAlert(with: error["message"] as? String)
                        
                    }
                }
            default:
                break
            }
            
            let decoder = JSONDecoder()
            
            do {
                let forecast = try decoder.decode(ForecastResponse.self, from: data)
                self.hours = forecast.forecast.forecastday[0].hour
                self.days = forecast.forecast.forecastday
                
                DispatchQueue.main.async {
                    self.dayCollectionView.reloadData()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:00"
                    let hour = dateFormatter.string(from: Date())
                    
                    for i in 0..<self.hours.count - 1 {
                        if self.hours[i].time.suffix(5) == hour {
                            self.dayCollectionView.scrollToItem(at: IndexPath(item: i, section: 0), at: .centeredHorizontally, animated: true)
                        }
                    }
                    
                    
                    self.nextDayCollectionView.reloadData()
                }
                
            } catch  {
                
                DispatchQueue.main.async {
                    self.showAlert(with: error.localizedDescription)
                    print(error)
                }
            }
            
             
            print(data)
        }.resume()
        
    }
    
    func showAlert(with title: String?) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true)
        
    }
    
    func UpdateUI(weather: CurrentResponse ) {
        
        tembLbl.text = "\(String(Int(weather.current.temp_c)))℃"
        describtionLbl.text = weather.current.condition.text
     
        if let today = days.first {
            
            windLbl.text = "Min: \(today.day.mintemp_c)℃ / Max: \(today.day.maxtemp_c)℃"
            
        }
        
        weatherImage.setImage(by: URL(string: "https:" + weather.current.condition.icon))
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == dayCollectionView {
            return hours.count
        } else {
            return days.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == dayCollectionView {
            
            
            let cell = dayCollectionView.dequeueReusableCell(withReuseIdentifier: "HaroratCell", for: indexPath) as! HaroratCell
            
            cell.updateCell(hour: hours[indexPath.row])
            
            return cell
        } else {
            
            let cell = nextDayCollectionView.dequeueReusableCell(withReuseIdentifier: "KunCell", for: indexPath) as! KunCell

            cell.updateCell(day: days[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if collectionView == dayCollectionView {
            
            let width: CGFloat = 66
            let height: CGFloat = 132
            
            return CGSize(width: width, height: height)
            
        } else {
            
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = 57
            
            return CGSize(width: width, height: height)
            
        }
    
        
    }
    
}

extension HomeVC : UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        return editCity.count
       
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return editCity[row]
 
    }
  
}

