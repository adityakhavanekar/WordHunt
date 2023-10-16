//
//  QuestionsViewModel.swift
//  WordHunt
//
//  Created by APPLE on 19/05/23.
//

import Foundation

enum Topics:String{
    case classic = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/wordHunts"
    case animals = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/animalWords"
    case brands = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/brandWords"
    case cities = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/cityWords"
    case countries = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/countryWords"
    case gadgets = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/deviceWords"
}

class QuestionsViewModel{
    private var wordHunt : [WordHuntElement]?
    private var topic:Topics
    
    init(wordHunt: [WordHuntElement]? = nil,topic:Topics) {
        self.wordHunt = wordHunt
        self.topic = topic
    }
    
    func getWordsNewApi(completion:@escaping (Bool)->()){
        guard let url = URL(string: topic.rawValue) else { return }
        NetworkManager.shared.request(url: url,headers: ["apiKey":"ytCbxj7MCrYpTm5kt4EWlXXQlQl2bRrsvEjGsSRhEyig7SQeSvfFE7Vrq5WcBDF2"]) { result in
            switch result{
            case .success(let gotData):
                do{
                    let jsonData = try JSONDecoder().decode([WordHuntElement].self, from: gotData)
                    self.wordHunt = jsonData.shuffled()
                    completion(true)
                }catch{
                    completion(false)
                    print("error")
                }
            case .failure(_):
                print("error")
                completion(false)
            }
        }
    }
    
    func getCount()->Int?{
        return wordHunt?.count
    }
    
    func getElement(index:Int)->WordHuntElement?{
        return wordHunt?[index]
    }
}
