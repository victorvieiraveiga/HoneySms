//
//  LoginViewController.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 31/01/21.
//

import UIKit


class LoginViewController: UIViewController {
    
  
    @IBOutlet weak var textUser: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var swicthRemember: UISwitch!
    @IBOutlet weak var buttonLoginEnter: LoadingButton!

    
    var loginDelegate = LoginManager()
    var loginUser : LoginModel?
    var C = Constants()
    let defauts = UserDefaults.standard
    var lbutton = LoadingButton()
    var tokenManager = TokenManager()
    var userManager = UserManager()
    
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    //Activity Indicator
    //var spinner = UIActivityIndicatorView()
    var loadingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        loginDelegate.delegate = self
        swicthRemember.setOn(defauts.bool(forKey: "Switch"), animated: true)
        loadUserPasswordSave()
        
    }
    //MARK:- Switch Controller
    @IBAction func switchPressed(_ sender: UISwitch) {
        
        if swicthRemember.isOn  == true {
            defauts.set(true, forKey: "Switch")
        }else {
            defauts.set(false, forKey: "Switch")
            defauts.set("", forKey: "user")
            defauts.set("", forKey: "password")
        }
    }
    
    //MARK:- Validate Login
    func checkLogin(loginUser: LoginModel) {
           
        let success = loginUser.success
        if success == true {
                print ("Acesso Liberado")

                let storyboard  = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: C.campainId) as! CampaignViewController
                controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
                controller.user = loginUser.user
                //controller.token = loginUser.accessToken
            
                self.present(controller, animated: true, completion: nil)
            } else {
                print ("Usuario não encontrado")
            }
    }
    
    
    func rememberLoginSave(_ user: String, _ password: String) {
        
        if swicthRemember.isOn {
            userManager.saveUserAndPassword(user, password)
            
            //defauts.set(user, forKey: "user")
            //defauts.set(password, forKey: "password")
            
        } else {
            userManager.saveUserAndPassword("", "")
            //defauts.set("", forKey: "user")
            //defauts.set("", forKey: "password")
        }
    }
    
    func loadUserPasswordSave() {
        if swicthRemember.isOn {
            
            let userPass = userManager.getUserAndPassword()
            
            if let user = userPass["user"] {
                textUser.text = user as! String
            }
            else { textUser.text = ""}
            
            if let password = userPass["password"]  {
                textPassword.text = password as! String
            } else {textPassword.text = ""}
            
        }else {
            textUser.text = ""
            textPassword.text = ""
        }
        
    }

    @IBAction func buttonEnterPressed(_ sender: UIButton) {
        
               buttonLoginEnter.showLoading()
                if let user = textUser.text {
                    if let password = textPassword.text {
                        
                        //Save login an password on userdefauts
                        rememberLoginSave(user,password)
                        
                        if user != "" && password != "" {
                                self.getLogin(user: user, password: password)
                        } else {
                            print ("Digite usuario e senha")
                        }

                    }
                }
    }
    
    
    @IBAction func buttonForgot(_ sender: UIButton) {
    }
    
    
    func getLogin(user: String, password: String) {
            self.loginDelegate.fecthLogin(user,password)
    }
    
}
//MARK:- Login Delegate Methods
extension LoginViewController : LoginManagerDelegate {
    func didUpdateLogin(_ loginManager: LoginManager, data: LoginModel) {
                DispatchQueue.main.async {
                    self.loginUser = data
                    self.checkLogin(loginUser: self.loginUser!)
                    
                    //save token in userDefauts
                    let token = data.accessToken
                    self.tokenManager.saveTokenUserDefauts(token: token)
                    self.buttonLoginEnter.hideLoading()
                }
    }
    func didFailWithError(error: Error) {
        print ("Erro ao recuperar login")
    }
    
}

//MARK:- Methods for dismiss keyboard when touch out
extension LoginViewController {
    /**
         * Called when 'return' key pressed. return NO to ignore.
         */
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
       /**
        * Called when the user click on the view (outside the UITextField).
        */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
           
}



