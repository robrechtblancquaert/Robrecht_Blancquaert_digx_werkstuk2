//
//  MapViewController.swift
//  werkstuk2
//
//  Created by student on 02/06/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var selectedStation = Station()
    var locationManager = CLLocationManager()
    var lastUpdate: Int = 0
    
    @IBOutlet weak var interval: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.getData()
        
        self.lastUpdate = 0
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.updateTimer()
        })
    }

    @IBAction func refresh() {
        self.lastUpdate = 0
        getData()
    }
    
    func updateTimer() {
        lastUpdate = lastUpdate + 1
        let (h,m,s) = convertTime(seconds: lastUpdate)
        self.interval.text = String(h) + "h " + String(m) + "m " + String(s) + "s sinds update" 
    }
    
    func convertTime (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
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
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let object = json[index] as! [String: AnyObject]
            
            fetch.predicate = NSPredicate(format: "number = %d", object["number"] as! Int16)
            
            let foundStations: [Station]
            do {
                foundStations = try managedContext.fetch(fetch) as! [Station]
            } catch {
                fatalError("Failed to fetch stations: \(error)")
            }
            
            let station: Station
            if(foundStations.count == 0) {
                station = NSEntityDescription.insertNewObject(forEntityName: "Station", into: managedContext) as! Station
                print("new station")
            } else {
                station = foundStations[0]
                print("refreshed station")
            }
            
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
            
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            
            for s in stations {
                let annotation = MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: s.lat, longitude: s.lng), title: s.name!)
                annotation.station = s;
                self.mapView.addAnnotation(annotation)
            }
        } catch {
            fatalError("Failed to fetch stations: \(error)")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped")
        let pin = view.annotation as? MyAnnotation
        self.selectedStation = (pin?.station)!
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetails") {
            let vc = segue.destination as! DetailsViewController
            vc.station = self.selectedStation
        }
    }
    

}
