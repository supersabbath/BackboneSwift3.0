//
//  MainTableViewController.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 30/01/2017.
//  Copyright © 2017 Alphabit. All rights reserved.
//

import UIKit
import BackboneSwift
 

class MainTableViewController: UITableViewController {

    var githubRepositories = Repositories(baseUrl:"https://api.github.com/search/repositories")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let requestOptions = HttpOptions(queryString: "q=language:swift&sort=stars&order=desc")
        githubRepositories.fetch(usingOptions:requestOptions).then { (repos:Repositories, _) -> Void in //Asynch call back
            self.tableView.reloadData()
        }.catch { (error) in
            print(error)
        }
    }
 

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return githubRepositories.models.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoId", for: indexPath)

        cell.textLabel?.text = githubRepositories.models[indexPath.row].html_url
        print(githubRepositories.models[indexPath.row].score)
  
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


}
