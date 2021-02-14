//
//  LeadsManager.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 03/02/21.
//

import Foundation


protocol LeadsManagerDelegate {
    func didUpdateLeads (_ leadsManager: LeadsManager, _ leadsModel : LeadsModel)
    func didFailWithError (_ error: Error)
}

struct LeadsManager {
    
    var delegate : LeadsManagerDelegate?
    
    func fechLead(_ idCampanha: String, token: String) {
        let C = Constants()
        let url =  "\(C.urlLeads)\(idCampanha)"
        performRequest(with: url, token: token)
    }
    
    func performRequest (with urlString: String, token: String) {
        
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            var request = URLRequest (url: url)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"

            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let leads = self.parseJson(safeData) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateLeads(self, leads)
                            
                        }
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
   
    }
    
    func parseJson(_ leadData: Data) -> LeadsModel? {
    
        let decoder = JSONDecoder()

        do {
            let decoderData = try decoder.decode(LeadsModel.self, from: leadData)
            print (decoderData)
            return decoderData

        } catch  {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
}
