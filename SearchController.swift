//
//  SearchController.swift
//  Weather
//
//  Created by Rahul's MacBook Pro on 28/04/21.
//  Copyright © 2021 Rahul M. All rights reserved.
//

import UIKit
import CoreData

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var textield: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var citynameArr = [String]()
    var temperatr = [Double]()
    var city = ""
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?q="
    let apiKey = "6d7246cc53f3f98189ff375b55bfc03b"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext:NSManagedObjectContext!
    var entity:NSEntityDescription!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.navigationItem.title = "Search"
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citynameArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "City Temperature.", message: "Do you wish to add the city weather to Home screen ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No",
                                         style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            //run your function here
            self.saveData(cityName: self.citynameArr[indexPath.row], temperature: self.temperatr[indexPath.row])
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func savedataadsa(){
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.cityTitle.text = citynameArr[indexPath.row]
        cell.cityTemperature.text = "\(temperatr[indexPath.row])"
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        city = textField.text!
        getCityTemp(cityname: city.trimmingCharacters(in: .whitespaces))
        self.view.endEditing(true)
        textField.text = ""
        return true
    }
    
    func getCityTemp(cityname: String) {
        let url : String =
        "\(baseURL)\(cityname)&appid=\(apiKey)"
        
        URLSession.shared.dataTask(with: NSURL(string: url) as! URL) { data, response, error in
            // Handle result
            
            let response = String (data: data!, encoding: String.Encoding.utf8)
            print("response is \(response)")
            
            do {
                let getResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                print(getResponse)
                
                let countryArray = getResponse as! NSDictionary
                print(countryArray)
                //
                //                let country1 = countryArray[0] as! [String:Any]
                //
                if let main = countryArray["main"] as? NSDictionary {
                let temp = main["temp"] as! Double
                let cityName = countryArray["name"] as! String
                print(temp)
                self.citynameArr.append(cityName)
                self.temperatr.append(temp)
                DispatchQueue.main.async {
                    self.tableView.reloadData()

                    }
                } else {
                    let message = countryArray["message"] as! String
                    let alert = UIAlertController(title: "Result.", message: message, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK",
                                                     style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
            }.resume()
    }


    
    func fetchData() {
        
        // restoring data back from database
        let request = NSFetchRequest < NSFetchRequestResult > (entityName: "Temperature")
        request.returnsObjectsAsFaults = false
        
        do {
            let results =
                try managedContext.fetch(request)
            
            if results.count > 0 {
                
                for result in results as![NSManagedObject] {
                    
                    if let username = result.value(forKey: "cityName") as? String {
                        
                        print(username)
                    }
                }
            } else {
                print("No results")
            }
        } catch {
            print("Couldn't fetch results")
        }
    }
    
    func saveData(cityName: String, temperature: Double) {
        managedContext = appDelegate.persistentContainer.viewContext
        
        entity = NSEntityDescription.entity(forEntityName: "Temperature", in: managedContext)
        
        let storeData = NSManagedObject.init(entity: entity, insertInto: managedContext)
        
        storeData.setValue(cityName, forKey: "cityName")
        storeData.setValue(temperature, forKey: "temperature")
        
        do {
            try managedContext.save()
            let alert = UIAlertController(title: "Data saved.", message: "New city temperature added can be checked on Home screen.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            self.citynameArr.removeAll()
            self.temperatr.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error as Error! {
            print(error.localizedDescription)
        }
    }
    
    
    
}
