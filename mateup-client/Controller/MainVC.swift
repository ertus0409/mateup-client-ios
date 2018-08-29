//
//  MainVC.swift
//  mateup-client
//
//  Created by Guner Babursah on 28/08/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let authService = AuthService.instance
    let dataService = DataService.instance
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataService.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dataService.getAllProjects()
//        tableView.reloadData()
        
        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "loading...")
        refreshControl.addTarget(self, action: #selector(MainVC.refreshData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (authService.isAuthenticated == false) {
            performSegue(withIdentifier: "toLoginVC", sender: self)
        } else {
            dataService.getAllProjects()
//            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataService.getAllProjects()
//        tableView.reloadData()
    }
    
    
    //TBALEVIEW FUNCTONS:
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataService.projects.count == 0 {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        return dataService.projects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectCell {
            cell.configureCell(project: dataService.projects[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    @objc func refreshData(){
        dataService.getAllProjects()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}
extension MainVC: DataServiceDelegate {
    func projectsLoaded() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
}
