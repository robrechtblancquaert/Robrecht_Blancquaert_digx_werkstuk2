//
//  TableViewController.swift
//  werkstuk2
//
//  Created by student on 03/06/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var station = Station()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let iftrue = "Ja"
        let iffalse = "Nee"
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = NSLocalizedString("number", comment: "") + " " + String(station.number)
            break
        case 1:
            cell.textLabel?.text = NSLocalizedString("name", comment: "") + " " + station.name!
            break
        case 2:
            cell.textLabel?.text = NSLocalizedString("address", comment: "") + " " + station.address!
            break
        case 3:
            cell.textLabel?.text = NSLocalizedString("banking", comment: "") + " " + ((station.banking) ? iftrue : iffalse)
            break
        case 4:
            cell.textLabel?.text = NSLocalizedString("bonus", comment: "") + " " + ((station.bonus) ? iftrue : iffalse)
            break
        case 5:
            cell.textLabel?.text = NSLocalizedString("status", comment: "") + " " + station.status!
            break
        case 6:
            cell.textLabel?.text = NSLocalizedString("bike stands", comment: "") + " " + String(station.bike_stands)
            break
        case 7:
            cell.textLabel?.text = NSLocalizedString("available bike stands", comment: "") + " " + String(station.available_bike_stands)
            break
        case 8:
            cell.textLabel?.text = NSLocalizedString("available bikes", comment: "") + " " + String(station.available_bikes)
            break
        default:
            break
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
