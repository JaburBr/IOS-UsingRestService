//
//  ViewController.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/6/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import UIKit
import MBProgressHUD


class ViewController: UIViewController {

    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtSenha: UITextField!
    @IBOutlet weak var btnOk: UIButton!
    
    var user:String?
    var pass:String?
    var tasks: Tasks?
    
    @IBAction func btnOk(_ sender: UIButton) {
        if validateFields() {
            getLoginRequest()
        }
    }
    
    func validateFields() -> Bool {
        if txtLogin.text == "" {
            sendAlert(msg: "Preencher o campo Login")
            return false
        }
        
        if txtSenha.text == "" {
            sendAlert(msg: "Preencher o campo Senha")
            return false
        }
        user = txtLogin.text
        pass = txtSenha.text
        return true
    }
    
    func sendAlert(msg: String) {
        let alert = UIAlertController(title: "Atencao", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in self.txtLogin.becomeFirstResponder()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnOk.clipsToBounds = true
        btnOk.layer.cornerRadius = 10
        
        txtLogin.text = "jaburmail@gmail.com"
        txtSenha.text = "docker2116"
        
    }
    
    func getLoginRequest(){
        
        LoginService().getLogin(user: user!, password: pass!, onSuccess: {
            response in
            if response?.httpStatusCode == 200{
                loginModel = (response?.body)!
                self.getToken(login: loginModel)
                self.prepareSegue()
            } else{
                self.sendAlert(msg: "Usuario ou senha invalido!")
            }
        }, onError: { erro in
            self.sendAlert(msg: "Servico indisponivel temporariamente.")
        }, always: {
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() {
            let expirateDate = UserDefaults.standard.integer(forKey: Config.expiration)
            let date = Date(timeIntervalSinceNow: TimeInterval(expirateDate))
            if date > Date() {
                synchronizeTask()
                self.prepareSegue()
            }
        } else {
            self.prepareSegue()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareSegue(){
        self.performSegue(withIdentifier: "segueTasks", sender: self)
    }
    
    func getToken(login: Login) {
        let preference = UserDefaults.standard
        preference.setValue(login.access_token, forKey: Config.token )
        preference.setValue(login.expires_in, forKey: Config.expiration)
    }
    
    func synchronizeTask() {
        
        let listResult: [ResultDB] = Repository.bd.objects(ResultDB.self)
            .filter(NSPredicate(format: "isEnviado == false")).map { $0 }
        
        let group = DispatchGroup()
        
        for i in 0..<listResult.count {
            group.enter()
            let result = Task()
            result.title = listResult[i].title
            result.description1 = listResult[i].desc
            result.expiration_date = listResult[i].expirationDate
            result.is_complete = listResult[i].isComplete
            
            TasksService().salvarTask(task: result,
                                      Success: { response in
                                        try! Repository.bd.write {
                                            Repository.bd.delete(listResult[i])
                                        }
            },
                                    onError: {error in},
                                    always: {})
            
        }
        
        group.notify(queue: .main) {
            print("Finished all requests.")
        }
    }
    
}




extension UIViewController {
    
    func showLoading() {
        let progressView = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressView.label.text = "Loading..."
        progressView.mode = .indeterminate
    }

    func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

