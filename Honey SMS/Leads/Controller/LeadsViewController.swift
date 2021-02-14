//
//  LeadsViewController.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 03/02/21.
//

import UIKit

class LeadsViewController: UIViewController {

    @IBOutlet weak var labelCampaign: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigation: UINavigationBar!
    
    var leadIdCampaign : Int?
    var campaignSelect : CampaignModel?
    var leads : LeadsModel?
    let C = Constants()
    var leadDelegate = LeadsManager()
    let contact = Contact()
    let login : LoginModel? = nil
    let userManager = UserManager()
    let tokenManager = TokenManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        leadDelegate.delegate = self
        guard let campDate = campaignSelect?.data[0].date_dateFormated else {return}
        guard let campName = campaignSelect?.data[0].nome else {return}
        //guard let campLocal = campaignSelect?.Local else {return}
        
        labelCampaign.text = "\(campDate) | \(campName) "
        
        guard let idCampanha = campaignSelect?.data[0].id else {return}
        let token = tokenManager.getToken()
        
        getLeads(idCampanha: idCampanha, token: token)
        
        configureNameUser()
    }
    
    //MARK:- Load Leds Api
    func getLeads (idCampanha: String, token: String) {
        DispatchQueue.main.async {
            self.leadDelegate.fechLead(idCampanha, token: token)
            self.tableView.reloadData()
        }
    }
    func configureNameUser() {
        let userName = userManager.getUser()
        if  userName != nil {
            navigation.topItem?.title = "Ola, \(userName)"
        }else { navigation.topItem?.title = ""}
    }

    //MARK:- Button Return to Campaign Screen
    @IBAction func buttonBackCampaignPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: C.campainId)
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK:- Save Contact Alert
    func SaveContactAlert(indexPath: IndexPath) {

        let refreshAlert = UIAlertController(title: "Salvar Contato", message: "Deseja salvar este contato?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (action: UIAlertAction!) in
            self.contact.SaveContact(lead: self.leads!)
            
            //Alert Message OK
            let AlertSave =  UIAlertController(title: "Sucesso", message: "Contato Salvo", preferredStyle: UIAlertController.Style.alert)
            AlertSave.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(AlertSave, animated: true, completion: nil)
            //Alert Message OK
        }))

        refreshAlert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { (action: UIAlertAction!) in
          print ("No")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
}


//MARK:- Methods of TableView Delegate (Swipe)
extension LeadsViewController : UITableViewDelegate {
    
    private func handleSaveContact(indexPath: IndexPath) {
        print("Salvar Contato")
        SaveContactAlert(indexPath: indexPath)
    }
    
    private func handleCallWhatsApp(phoneNumber:String) {
        print("Chamar WhatsApp")
        self.contact.openWhatsapp(phoneNumber: phoneNumber )
    }

    private func handleMarkAsInterested() {
        print("I have interested")
    }

    private func handleMoveToDontInterested() {
        print("I don't have interested")
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Save Contacts
        let saveContact = UIContextualAction(style: .normal,
                                        title: "Salvar Contato") { [weak self] (action, view, completionHandler) in
            
            self?.handleSaveContact(indexPath: indexPath)
                                            completionHandler(true)
        }
        saveContact.backgroundColor = .systemBlue
        
        //Call WhatsApp
        let callWhatsApp = UIContextualAction(style: .normal,
                                        title: "Chamar WhatsApp") { [weak self] (action, view, completionHandler) in
            
            let phoneNumber = self?.leads?.data[indexPath.row].PhoneFormated
                                            self?.handleCallWhatsApp(phoneNumber: phoneNumber ?? "")
                                            completionHandler(true)
        }
        
        
        callWhatsApp.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [saveContact,callWhatsApp])
        return configuration
    }
    

    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Don't have interested action
        let dontInterested = UIContextualAction(style: .normal,
                                       title: "Não tenho interesse.") { [weak self] (action, view, completionHandler) in
                                        self?.handleMoveToDontInterested()
                                        completionHandler(true)
        }
        
        // Have interested action
        let interested = UIContextualAction(style: .normal,
                                         title: "Tenho interesse.") { [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsInterested()
                                            completionHandler(true)
        }
        interested.backgroundColor = .systemYellow

 
        dontInterested.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [dontInterested,interested])

        return configuration
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
}

//MARK:- Methods of TableView DataSource

extension LeadsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leads?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cell, for: indexPath) as! LeadsTableViewCell
        
        cell.configureCell(leads: leads!.data, indexPath: indexPath.row)
        return cell
    }
}

//MARK:- Methods for get leads from api
extension LeadsViewController : LeadsManagerDelegate {
    func didUpdateLeads(_ leadsManager: LeadsManager, _ leadsModel: LeadsModel) {
                DispatchQueue.main.async {
                    self.leads = leadsModel
                    self.tableView.reloadData()
                }
    }
    
    func didFailWithError(_ error: Error) {
        print ("Deu erro")
    }
    
    
}
