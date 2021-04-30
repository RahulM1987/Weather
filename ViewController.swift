//
//  ViewController.swift
//  Weather
//
//  Created by Rahul's MacBook Pro 
//  Copyright © 2021 Rahul M. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    let mockDataCity = ["Sydney","Brisbane","Melbourne"]
    let mockTempr = [300, 303, 302]
    var cityname = [String]()
    var temperature = [Double]()


    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib.init(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cityname.removeAll()
        self.temperature.removeAll()
        self.fetchData()
        self.tableview.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cityname.count == 0{
            return mockDataCity.count
        } else {
            return cityname.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        if cityname.count == 0 {
            cell.cityTitle.text = mockDataCity[indexPath.row]
            cell.cityTemperature.text = "\(mockTempr[indexPath.row])"
        } else {
        cell.cityTitle.text = cityname[indexPath.row]
        cell.cityTemperature.text = "\(temperature[indexPath.row])"
        }
        return cell
    }

        
    
    @IBAction func searchBtnTap(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "searchVC") as! SearchController
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as!AppDelegate

        let managedContext = appDelegate.persistentContainer.viewContext

        // restoring data back from database
        let request = NSFetchRequest < NSFetchRequestResult > (entityName: "Temperature")
        request.returnsObjectsAsFaults = false

        do {
            let results =
                try managedContext.fetch(request)
            
            if results.count > 0 {
                
                for result in results as![NSManagedObject] {
                    
                    if let cityNm = result.value(forKey: "cityName") as? String {
                        print(cityNm)
                        self.cityname.append(cityNm)
                    }
                    if let tempr = result.value(forKey: "temperature") as? Double {
                        print(tempr)
                        self.temperature.append(tempr)
                    }
                }
            } else {
                print("No results")
            }
        } catch {
            print("Couldn't fetch results")
        }
    }
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Temperature")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            self.cityname.removeAll()
            self.temperature.removeAll()
            self.tableview.reloadData()
            let alert = UIAlertController(title: "Data Deleted.", message: "All records deleted.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)

        } catch {
            print ("There was an error")
        }
    }

    @IBOutlet weak var deleteAll: UIBarButtonItem!
    
    @IBAction func deleteAllData(_ sender: AnyObject) {
        self.deleteAllRecords()
    }
    
}

