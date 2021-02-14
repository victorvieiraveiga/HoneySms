//
//  LoginManager.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 02/02/21.
//

import Foundation

protocol LoginManagerDelegate {
    //func didUpdateLogin (_ loginManager : LoginManager, login: [LoginModel])
    func didUpdateLogin (_ loginManager : LoginManager, data: LoginModel)
    func didFailWithError(error: Error)
}

struct LoginManager {
    
    var delegate : LoginManagerDelegate?
    var loginModel : LoginModel?
    

    
    mutating func fecthLogin (_ user : String, _ password:String) {
        let C = Constants()
        let url = "\(C.urlLogin)?user=\(user)&password=\(password)"
        performRequest(with: url,email: user,password: password)
    }
    
     func performRequest (with urlString:String, email: String, password: String)
    {
        
        guard let url = URL(string: urlString) else {return}

        var loginRequest = URLRequest(url: url)

        loginRequest.httpMethod = "POST"
        loginRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        loginRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let params = ["Email": email, "Password" : password]

            loginRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init())

            URLSession.shared.dataTask(with: loginRequest) { (data, response, error) in
               
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
          
                    
                    if let parseJson = json {
                        let data = parseJson["data"] as? NSDictionary
                        
                        if let succes = parseJson["success"] as? Bool {
                            if succes == true {
                                if let accessToken = data?["accessToken"] as? String {
                                    print(accessToken)
                                    
                                       
                                        let success = parseJson["success"] as! Bool
                                        let data = parseJson["data"] as! NSDictionary
                                        let userToken = data["userToken"] as! NSDictionary
                                        
                                        let accessToken = data["accessToken"] as! String
                                        let user = userToken["email"] as! String
                                        
                                        let loginData = LoginModel(success: success, accessToken: accessToken, user: user)
                                        
                                        self.delegate?.didUpdateLogin(self, data: loginData)
                                }
                            } else {
                                DispatchQueue.main.async {
                                   
                                    self.delegate?.didUpdateLogin(self, data: loginModel!)
                                }
                            }
                      
                        }
                    }
                    
                }
                catch {
                    
                }
                
                
                
            }.resume()



        } catch  {
            self.delegate?.didFailWithError(error: error)
                return
        }
        
//        //1. Create a URL
//        if let url = URL(string: urlString) {
//            //2. Create a URLSession
//
//            let session = URLSession(configuration: .default)
//            //3. Give the session a task
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    self.delegate?.didFailWithError(error: error!)
//                    return
//                }
//                if let safeData = data {
//                    if let loginUser = self.parseJson(safeData) {
//                       DispatchQueue.main.async {
//                            self.delegate?.didUpdateLogin(self, login: [loginUser])
//                        }
//                    }
//                }
//            }
//            //4. Start the task
//            task.resume()
//        }
    
    }
    
    
//    func parseJson (_ loginData: Data) -> LoginModel {
//        let decoder = JSONDecoder()
//        do {
//            let decoderData = try decoder.decode(LoginModel.self, from: loginData)
//
////            let name = decoderData[0].name
////            let user = decoderData[0].user
////            let password = decoderData[0].password
////
////            let login = LoginModel(name: name, password: password, user: user)
//
//            return decoderData
//
//        } catch  {
//            delegate?.didFailWithError(error: error)
//            print (error)
//        }
//
//    }
    
}
