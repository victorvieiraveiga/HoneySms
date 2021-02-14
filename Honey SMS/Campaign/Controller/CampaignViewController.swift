//
//  CampaignViewController.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 01/02/21.
//

import UIKit

class CampaignViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navigation: UINavigationBar!
    
    var results : CampaignModel?
    var C = Constants()
    var campaignDelegate = CampaignManager()
    let defauts = UserDefaults.standard
    //var token : String?
    var tokenManager = TokenManager()
    var userManager = UserManager()
    var user : String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        campaignDelegate.delegate = self
        configureNameUser()
        loadCampaign()
    }
    
    func configureNameUser() {
        
        let userName = userManager.getUser()
        
        if  userName != nil {
            navigation.topItem?.title = "Ola, \(userName)"
        } else {
            navigation.topItem?.title = "Seja Bem vindo."
        }
        
//        if defauts.string(forKey: "nameUser") == nil {
//
//        } else {
//            if let userName = defauts.string(forKey: "nameUser") {
//                navigation.topItem?.title = "Ola, \(userName)"
//            }
//        }
    }
    //MARK:- Call API and Reload TableView
    func loadCampaign () {
       DispatchQueue.main.async {
        
        let accesToken = self.tokenManager.getToken()
        self.campaignDelegate.fecthCampaign(token: accesToken)
        self.tableView.reloadData()
        }
    }
    
    //MARK:- LOGOUT
    @IBAction func buttonLogOutPressed(_ sender: UIBarButtonItem) {
        
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(identifier: C.loginId) as! LoginViewController
        
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(controller, animated: true, completion: nil)
    }
}

//MARK:- Methods of TableView DataSource
extension CampaignViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cell, for: indexPath) as! CampaignViewCell
        
        cell.ConfigCell(campaign: results!.data, indexpath: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(identifier: C.leadsStoryId) as! LeadsViewController
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //controller.leadIdCampaign = results[indexPath.row].data[0].id
        controller.campaignSelect = results
        present(controller, animated: true, completion: nil)
    }
}

//MARK:- Delegate of Campaing Manager.
extension CampaignViewController : CampaignManagerDelegate {
    func didUpdateCampaign(_ campaignManager: CampaignManager, campaign: CampaignModel) {
        DispatchQueue.main.async {
                           self.results = campaign
                           self.tableView.reloadData()
                       }
    }
    
    func didFailWithError(error: Error) {
        print ("Erro ao carregar campanha")
    }
    
    
}
