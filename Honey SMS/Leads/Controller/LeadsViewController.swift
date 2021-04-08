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
    var accessToken : String = ""
    var indexCampaignSelect : Int = 0
    
    var interesseDelegate = InteresseManager()
    var interesse : InteresseModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        leadDelegate.delegate = self
        interesseDelegate.delegate = self
        
        guard let campDate = campaignSelect?.data[indexCampaignSelect].date_dateFormated else {return}
        guard let campName = campaignSelect?.data[indexCampaignSelect].nome else {return}
        //guard let campLocal = campaignSelect?.Local else {return}
        
        labelCampaign.text = "\(campDate) | \(campName) "
        
        guard let idCampanha = campaignSelect?.data[indexCampaignSelect].id else {return}
        
        accessToken = tokenManager.getToken()
        
        getLeads(idCampanha: idCampanha, token: accessToken)
        
        configureNameUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if menuView.isHidden == true {
//            menuView.isHidden = false
//        } else {
//            menuView.isHidden = true
//        }
//    }
    
    //MARK:- Load Leds Api
    func getLeads (idCampanha: String, token: String) {
        DispatchQueue.main.async {
            self.leadDelegate.fechLead(idCampanha, token: token)}
            self.tableView.reloadData()
       // }
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
    
 //MARK:- Post Interesse
//    @IBAction func postInteresseButtonPressed(_ sender: Any) {
//        guard let button = sender as? UIButton else {return}
//        switch button.tag {
//        case 1:
//            //TODO:- Tenho Interesse
//            postInteresse(idLead: <#T##String#>, interesse: <#T##Int#>, token: <#T##String#>)
//        case 2:
//            postInteresse(idLead: <#T##String#>, interesse: <#T##Int#>, token: <#T##String#>)
//        case 3:
//            postInteresse(idLead: <#T##String#>, interesse: <#T##Int#>, token: <#T##String#>)
//        default:
//            print ("Erro Post")
//            return
//        }
//
//    }
    
    func postInteresse(interesse: Int) -> Bool {
        return true
    }
    
    func postInteresseButtonPressed(indexPath: IndexPath, interesse: String) {
       // guard let button = sender as? ButtonInteresse else {return}
       // let indexPath = IndexPath(row: sender.tag, section: 0)

        let cell = leads?.data[indexPath.row]

        let idLead = cell?.id
       // let idleadB = button.idLead

        switch interesse {
        case "1":
            //TODO:- Tenho Interesse
            postInteresse(idLead: idLead ?? "", interesse: "1", token: accessToken )
            //self.menuView.isHidden = true
        case "2":
            postInteresse(idLead: idLead ?? "", interesse: "2", token: accessToken)
           // self.menuView.isHidden = true
        case "3":
            postInteresse(idLead: idLead ?? "" , interesse: "3", token: accessToken)
           // self.menuView.isHidden = true
        default:
            print ("Erro Post")
            return
        }

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

    private func handleMarkAsInterested(indexPath: IndexPath, interesse: String) {
        postInteresseButtonPressed(indexPath: indexPath, interesse: interesse)
  
    }

    private func handleMoveToDontInterested(indexPath: IndexPath, interesse: String) {
        postInteresseButtonPressed(indexPath: indexPath, interesse: interesse)

    }
    
    private func handleMarkAsDontInterestedCamp (indexPath: IndexPath, interesse: String){
        postInteresseButtonPressed(indexPath: indexPath, interesse: interesse)

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
        //Não deixa executar automaticamente no deslizamento total
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    

    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Don't have interested action
        let dontInterested = UIContextualAction(style: .normal,
                                       title: "Não tenho interesse.") { [weak self] (action, view, completionHandler) in
                                        self?.handleMoveToDontInterested(indexPath: indexPath, interesse: "2")
                                        completionHandler(true)
        }
        
        // Have interested action
        let interested = UIContextualAction(style: .normal,
                                         title: "Tenho interesse.") { [weak self] (action, view, completionHandler) in
            self?.handleMarkAsInterested(indexPath: indexPath, interesse: "1")
                                            completionHandler(true)
        }
        
        // Have interested action
        let ntinterestedCamp = UIContextualAction(style: .normal,
                                         title: "Interesse em uma prox. campanha.") { [weak self] (action, view, completionHandler) in
            self?.handleMarkAsDontInterestedCamp(indexPath: indexPath, interesse: "3")
                                            completionHandler(true)
        }
        
        
        interested.backgroundColor = UIColor(named: "title_interesse_color")
        
        dontInterested.backgroundColor = UIColor(named: "title_nt_interesse_color")
        ntinterestedCamp.backgroundColor = UIColor(named: "title_interesse_campanha")

        let configuration = UISwipeActionsConfiguration(actions: [dontInterested,interested, ntinterestedCamp])
        //Não deixa executar automaticamente no deslizamento total
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
//    func closeMenu() {
//        if menuView.isHidden == false {
//            menuView.isHidden = true
//        }
//    }
    
    
    
}

//MARK:- Methods of TableView DataSource

extension LeadsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leads?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cell, for: indexPath) as! LeadsTableViewCell
        
        if leads?.data[indexPath.row].interesse == 1 {
            cell.backgroundColor = UIColor(named: "tInteresseColor")
        } else if leads?.data[indexPath.row].interesse == 2 {
            cell.backgroundColor = UIColor(named: "ntInteresseColor")
        } else if leads?.data[indexPath.row].interesse == 3 {
            cell.backgroundColor = UIColor(named: "ntcampanhaInteresseColor")
        }
        
        cell.configureCell(leads: leads!.data, indexPath: indexPath.row)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = self.leads?.data[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            // Create an action for tenho interesse
            let tInteresse = UIAction(title: "Tenho interesse", image: nil) { action in
                print("Sharing \(String(describing: item?.nome))")
                self.postInteresseButtonPressed(indexPath: indexPath, interesse: "1")
                
            }
            let nTInteresse = UIAction(title: "Não tenho interesse", image: nil) { action in
                self.postInteresseButtonPressed(indexPath: indexPath, interesse: "2")
            }
            let nTInteresseCampanha = UIAction(title: "Tenho Interesse em uma proxima campanha", image: nil) { action in
                self.postInteresseButtonPressed(indexPath: indexPath, interesse: "3")
            }
    
        return UIMenu(title: "Informar Interesses", children: [tInteresse,nTInteresse,nTInteresseCampanha])
        }
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
extension LeadsViewController : InteresseManagerDelegate {
    func didUpdateInteresse(_ interesseManager: InteresseManager, _ interesseModel: InteresseModel) {
        self.interesse = interesseModel
        getLeads(idCampanha: campaignSelect?.data[indexCampaignSelect].id ?? "", token: accessToken)
        self.tableView.reloadData()
    }
    
    func postInteresse (idLead: String, interesse: String, token: String) {
        DispatchQueue.main.async {
            self.interesseDelegate.postInteresse(idLead, interesse, token: token)
            //self.tableView.reloadData()
        }
    }
}

