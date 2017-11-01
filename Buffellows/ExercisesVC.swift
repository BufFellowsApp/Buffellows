//
//  ExercisesVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/22/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit

class ExercisesVC: StandardVC, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    

    @IBOutlet weak var exerciseList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //The following sets up the table view
        exerciseList.delegate      =   self
        exerciseList.dataSource    =   self
        exerciseList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        //This sets up the search bar for the exercises
        searchBarSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //This will return the number of cells used, so we can call data from an array and get the size of
        //the array  (array.count) as the number of cells...
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        //this creates a basic cell for the table... each cell can work with the data
        return cell
    }

}
