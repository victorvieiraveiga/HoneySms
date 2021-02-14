//
//  CampaignManager.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 01/02/21.
//

import Foundation

protocol CampaignManagerDelegate {
    func didUpdateCampaign (_ campaignManager : CampaignManager, campaign: CampaignModel)
    func didFailWithError(error: Error)
}


struct CampaignManager {
    
    var delegate: CampaignManagerDelegate?
   
    
    func fecthCampaign (token: String) {
        let C = Constants()
        let url = C.urlCampaign
        performRequest(with: url, with: token)
    }
    
    
    
    func performRequest (with urlString:String, with token: String)
    {
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
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let campaign = self.parseJson(safeData) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateCampaign(self, campaign: campaign)
                            
                        }
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    
    }
    
    func parseJson (_ campaignData: Data) -> CampaignModel? {
    
        let decoder = JSONDecoder()

        do {
            let decoderData = try decoder.decode(CampaignModel.self, from: campaignData)
            print (decoderData)
            return decoderData

        } catch  {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
