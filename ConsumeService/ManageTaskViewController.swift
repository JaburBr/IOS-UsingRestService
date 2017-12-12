//
//  ManageTaskViewController.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/11/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import UIKit

class ManageTaskViewController: UIViewController {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var schComplete: UISwitch!
    @IBOutlet weak var dtpData: UIDatePicker!
    
    var task: Task!
    var isEdit = false
    var dateSet: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEdit {
            fillTask()
        } else {
            task = Task()
        }
    }
    
    func fillTask(){
        txtTitle.text = task.title
        txtDescription.text = task.description1
        schComplete.isOn = task.is_complete!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dtpData.date = dateFormatter.date(from: task.expiration_date!)!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnSalvar(_ sender: UIButton) {
        task.title = txtTitle.text
        task.description1 = txtDescription.text
        task.is_complete = schComplete.isOn
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        task.expiration_date = formatter.string(from: dtpData.date)
        
        if isEdit {
           editarTask()
        } else {
           salvarTask()
        }
    }
    
    func salvarTask() {
        if Reachability.isConnectedToNetwork() {
            self.showLoading()
            TasksService().salvarTask(task: task, Success: { reponse in
                self.sendAlert(msg: "Registro Salvo com Sucesso")
                self.navigationController?.popViewController(animated: true)
            }, onError: { error in
                self.sendAlert(msg: "Servico indiponivel temporariamente.")
            }, always: {
                self.hideLoading()
            })
        } else {
            SaveBD()
        }
        
        
    }
    
    func editarTask() {
        self.showLoading()
        TasksService().editarTask(task: task, Success: { reponse in
            self.sendAlert(msg: "Registro atualizado com sucesso!")
            self.navigationController?.popViewController(animated: true)
        }, onError: { error in
            self.sendAlert(msg: "Servico indiponivel temporariamente.")
        }, always: {
            self.hideLoading()
        })
    }
    
    func sendAlert(msg: String) {
        let alert = UIAlertController(title: "Atencao", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func SaveBD(){
        let myTask = ResultDB()
        myTask.title = task.title
        myTask.desc = task.description1
        myTask.expirationDate = task.expiration_date
        myTask.isComplete = task.is_complete!
        do {
            try Repository.bd.write {
                Repository.bd.add(myTask)
            }
            sendAlert(msg: "Salvo no BD com sucesso")
        } catch let error as NSError {
            sendAlert(msg: error.description)
        }
    }
    
    func EditBD(){
        var myTask = ResultDB()
        myTask = Repository.bd.object(ofType: ResultDB.self, forPrimaryKey: self.task.id)!
        do {
            try Repository.bd.write {
                myTask.title = self.task.title
                myTask.desc = self.task.description1
                myTask.expirationDate = self.task.expiration_date
                myTask.isComplete = self.task.is_complete!
                Repository.bd.add(myTask, update: true)
            }
            sendAlert(msg: "Task editada com sucesso no BD")
        } catch let error as NSError {
            sendAlert(msg: "Erro ao Editar a task no BD -> \(error.description)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
