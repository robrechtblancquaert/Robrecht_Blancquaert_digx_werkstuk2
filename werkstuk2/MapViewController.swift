//
//  MapViewController.swift
//  werkstuk2
//
//  Created by student on 02/06/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import CoreData

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale")
        let urlRequest = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            DispatchQueue.main.async {
                do {
                   let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [AnyObject]
                    self.loadJson(json: json!)
                } catch let error as NSError {
                    print(error)
                }
                
            }
        }
        task.resume()
    }
    
    func loadJson(json: [AnyObject]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for index in 0...json.count-1 {
            let station = NSEntityDescription.insertNewObject(forEntityName: "Station", into: managedContext) as! Station
            let object = json[index] as! [String: AnyObject]
            station.number = object["number"] as! Int16
            station.name = object["name"] as? String
            station.address = object["address"] as? String
            
            let position = object["position"] as! [String: AnyObject]
            station.lat = position["lat"] as! Double
            station.lng = position["lng"] as! Double
            
            station.banking = object["banking"] as! Bool
            station.bonus = object["bonus"] as! Bool
            station.status = object["status"] as? String
            station.contract_name = object["contract_name"] as? String
            station.bike_stands = object["bike_stands"] as! Int16
            station.available_bike_stands = object["available_bike_stands"] as! Int16
            station.available_bikes = object["available_bikes"] as! Int16
            station.last_update = object["last_update"] as! Int64
        }
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        updateMap()
    }
    
    func updateMap() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        let stations: [Station]
        do {
            stations = try managedContext.fetch(fetch) as! [Station]
            for s in stations {
                print(s.name)
            }
        } catch {
            fatalError("Failed to fetch stations: \(error)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
