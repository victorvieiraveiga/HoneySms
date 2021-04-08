//
//  InteresseManager.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 17/03/21.
//

import Foundation

protocol InteresseManagerDelegate {
    func didUpdateInteresse (_ interesseManager: InteresseManager, _ interesseModel : InteresseModel)
    func didFailWithError (_ error: Error)
}

struct InteresseManager {
    
    var delegate : InteresseManagerDelegate?
    
    func postInteresse(_ idLead: String, _ interesse: String, token: String) {
        let C = Constants()
        let url =  "\(C.urlPostInteresse)\(idLead)" + "/" + interesse
        performRequest(with: url, token: token)
    }
    
    func performRequest (with urlString: String, token: String) {
        
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            var request = URLRequest (url: url)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "Post"

            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let interesse = self.parseJson(safeData) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateInteresse(self, interesse)
                        }
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
   
    }
    
    func parseJson(_ interesseData: Data) -> InteresseModel? {
    
        let decoder = JSONDecoder()

        do {
            let decoderData = try decoder.decode(InteresseModel.self, from: interesseData)
            print (decoderData)
            return decoderData

        } catch  {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
}
