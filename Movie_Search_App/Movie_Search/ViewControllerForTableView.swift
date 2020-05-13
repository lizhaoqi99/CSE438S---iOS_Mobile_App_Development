//
//  ViewControllerForTableView.swift
//  Lab4
//
//  Created by Steve Li on 10/21/19.
//  Copyright © 2019 Steve Li. All rights reserved.
//

import UIKit
import Foundation

class ViewControllerForTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var myArray: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel!.text = myArray[indexPath.row]
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {    // delete
        if (editingStyle == UITableViewCell.EditingStyle.delete){
            myArray.remove(at: indexPath.row)
            UserDefaults.standard.set(myArray, forKey: "fav")
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myArray = []
        let movies = UserDefaults.standard.array(forKey: "fav")
        if (movies != nil){
            for movie in movies!{
                myArray.append(movie as! String)
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let movies = UserDefaults.standard.array(forKey: "fav")
        if (movies != nil){
            for movie in movies!{
                myArray.append(movie as! String)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
