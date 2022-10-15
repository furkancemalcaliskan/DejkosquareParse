//
//  PlacesViewController.swift
//  DejkosquareParse
//
//  Created by Furkan Cemal Çalışkan on 18.09.2022.
//

import UIKit
import Parse

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutButtonClicked))
        
        getDataFromParse()
        
    }
    
    func getDataFromParse() {
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                
            } else {
                
                if objects != nil {
                    
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        
                        if let placeName = object.object(forKey: "name") as? String {
                            
                            if let placeId = object.objectId {
                                
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                                
                            }
                            
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
                
            }
        }
        
    }
    
    @objc func addButtonClicked() {
        
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
        
    }
    
    @objc func logOutButtonClicked() {
        
        PFUser.logOutInBackground { (error) in
            if error != nil {
                
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                
            } else {
                
                self.performSegue(withIdentifier: "toLoginVC", sender: nil)
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenPlaceId = selectedPlaceId
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    func makeAlert(title: String, message: String) {
        
        let error = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        error.addAction(okButton)
        self.present(error, animated: true, completion: nil)
        
    }

}
