//
//  TasksTableViewController.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/8/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import UIKit
import EasyRest

class TasksTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var btnNovo: UIBarButtonItem!
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    
    var arrtask:[Task] = []
    var tasks: Tasks?
    var task: Task!
    var isSearch: Bool?
    
    @IBAction func btnSearch(_ sender: UIBarButtonItem) {
        prepareSearch()
    }
    
    @IBAction func btnNovo(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueNew", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteTask(indexPath: indexPath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTasksRequest()
    }
    
    func getTasksRequest(){
        if Reachability.isConnectedToNetwork() {
            self.showLoading()
            TasksService().getTasks(onSuccess: { response in
                if response?.httpStatusCode == 200{
                    self.tasks = response?.body
                    self.arrtask = (self.tasks?.results)!
                    self.tableView.reloadData()
                }
            }, onError: { error in
                self.sendAlert(msg: "Servico temporariamente indisponivel.")
            }, always: {
                self.hideLoading()
            })
        } else {
            getTasksBD()
        }
        
    }
    
    func getTasksBD(){
        self.tasks?.results = []
        do {
            try Repository.bd.write {
                Repository.bd.objects(ResultDB.self).forEach {
                    let result = Task()
                    result.title = $0.title
                    result.description1 = $0.desc
                    result.expiration_date = $0.expirationDate
                    result.is_complete = $0.isComplete
                    result.id = $0.id
                    self.tasks?.results?.append(result)
                }
            }
        } catch let error as NSError {
            sendAlert(msg: "Erro ao recuperar as Tasks do BD -> \(error.description)")
        }
        
        self.tableView.reloadData()
    }
    
    func deleteTask(indexPath: IndexPath) {
        let result = self.tasks?.results![indexPath.row]
        self.showLoading()
        TasksService().deleteTask(task: result!, Success: { reponse in
            self.tasks?.results?.remove(at: indexPath.row)
            self.arrtask.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }, onError: { error in
            
        }, always: {
            self.hideLoading()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTasksRequest()
    }
    
    func sendAlert(msg: String) {
        let alert = UIAlertController(title: "Atencao", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath) as! TasksTableViewCell

        let result = tasks?.results?[indexPath.row]
        
        cell.lblTitulo.text = result?.title
        cell.lblData.text = result?.expiration_date
        cell.lblDescricao.text = result?.description1
        cell.imgComplete.isHidden = (result?.is_complete)!

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.task = tasks?.results![indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "segueEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destino = segue.destination as! ManageTaskViewController
        if segue.identifier == "segueEdit" {
            destino.isEdit = true
        }
        destino.task = task
    }
    
    func prepareSearch(){
        let searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.tintColor = UIColor.blue
        searchBar.becomeFirstResponder()
        self.btnSearch.tintColor = UIColor.clear
        self.btnSearch.isEnabled = false
        self.btnNovo.tintColor = UIColor.clear
        self.btnNovo.isEnabled = false
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search"
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.navigationItem.titleView = nil
        self.btnSearch.tintColor = UIColor.blue
        self.btnSearch.isEnabled = true
        self.btnNovo.tintColor = UIColor.blue
        self.btnNovo.isEnabled = true
        self.isSearch = false
        getTasksRequest()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isSearch = true
        if searchText.isEmpty {
            tasks?.results = arrtask
            self.tableView.reloadData()
            return
        }
        tasks?.results = []
        for (result) in arrtask {
            if (result.title?.uppercased().range(of: searchText.uppercased()) != nil) {
                tasks?.results?.append(result)
            }
        }
        self.tableView.reloadData()
    }

}
