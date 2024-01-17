//
//  HomeViewController.swift
//  DictHome
//
//  Created by Kholmumin Tursinboev on 17/01/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var localData:[String] = []
    var filteredData:[String] = []
    let parseLocal = ParseLocal()
    let dfVC = DefinitionViewController(nibName: "DefinitionViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppearTasks()
    }
    
    func willAppearTasks(){
        searchBar.text = ""
        filteredData = localData
        tableView.reloadData()
        
    }
    
    func initViews(){
        
        searchBar.delegate = self
        searchBar.showsBookmarkButton = false
        tableView.delegate = self
        tableView.dataSource = self
        
        if let data = parseLocal.loadJsonArray(){
            localData = data
        }else{
            print("Failed to load local data")
        }
        
        filteredData = localData
        
    }
    
}

//MARK: - SearchBarDelegates
extension HomeViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? localData : localData.filter { $0.lowercased().hasPrefix(searchText.lowercased()) }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredData = localData
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text {
            dfVC.word = searchText
            navigationController?.pushViewController(dfVC, animated: true)
        }
        searchBar.resignFirstResponder()
    }
    
    
}


//MARK: - TableViewDelegates
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = filteredData[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dfVC.word = filteredData[indexPath.row]
        navigationController?.pushViewController(dfVC, animated: true)
    }
}
