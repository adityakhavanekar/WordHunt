//
//  QuestionsViewModelV2.swift
//  WordHunt
//
//  Created by Neosoft on 15/09/23.
//

import Foundation

class QuestionsViewModelV2{
    private var wordHunt : [WordHuntElementV2]?
    private var url:URL
    
    init(wordHunt: [WordHuntElementV2]? = nil, url: URL) {
        self.wordHunt = wordHunt
        self.url = url
    }
    
    func getWords(completion:@escaping (Bool)->()){
        NetworkManager.shared.request(url: url,headers: ["apiKey":"ytCbxj7MCrYpTm5kt4EWlXXQlQl2bRrsvEjGsSRhEyig7SQeSvfFE7Vrq5WcBDF2"]) { result in
            switch result{
            case .success(let gotData):
                do{
                    let jsonData = try JSONDecoder().decode([WordHuntElementV2].self, from: gotData)
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
    
    func getElement(index:Int)->WordHuntElementV2?{
        return wordHunt?[index]
    }
}
