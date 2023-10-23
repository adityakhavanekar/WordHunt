//
//  QuestionsViewModel.swift
//  WordHunt
//
//  Created by APPLE on 19/05/23.
//

import Foundation

class QuestionsViewModel{
    private var wordHunt : [WordHuntElement]?
    private var topic:Topics
    
    init(topic:Topics) {
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
