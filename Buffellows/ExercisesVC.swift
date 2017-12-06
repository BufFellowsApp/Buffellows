//
//  ExercisesVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/22/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit

class ExercisesVC: StandardVC, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let exercises = ["Shoulders","Chest", "Bicep", "Tricep", "Back", "Legs", "Cardio"]
    var exerciseData =  [String: [String]]()
    let eDB = ExerciseDB()
    @IBOutlet weak var exerciseList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //The following sets up the table view
        exerciseList.delegate      =   self
        exerciseList.dataSource    =   self
        exerciseList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
       getWorkouts()
        //This sets up the search bar for the exercises
        searchBarSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getWorkouts(){
        
        self.exerciseData.removeAll()
        eDB.getWorkouts(){
            (result: String) in
            if (result == "Exerecises"){
                self.exerciseData = self.eDB.passWorkouts()
               
                self.exerciseList.reloadData()
            }
            
        }
    }
    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = UIBarStyle.black
        
        self.exerciseList.tableHeaderView = searchBar
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        //in this function you can setup how the filter works (look up search bar filter)
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.exercises[section]
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return exerciseData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return (exerciseData[exercises[section]]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let name = exerciseData[exercises[indexPath.section]]?[indexPath.row]
        cell.textLabel?.text = name
        return cell
    }

}
