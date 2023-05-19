//
//  QuestionsViewModel.swift
//  WordHunt
//
//  Created by APPLE on 19/05/23.
//

import Foundation

class QuestionsViewModel{
    private var wordHunt : [WordHuntElement]?
    private var url:URL
    
    init(wordHunt: [WordHuntElement]? = nil, url: URL) {
        self.wordHunt = wordHunt
        self.url = url
    }
    
    func getWords(completion:@escaping ()->()){
        NetworkManager.shared.request(url: url) { result in
            switch result{
            case .success(let gotData):
                do{
                    let jsonData = try JSONDecoder().decode([WordHuntElement].self, from: gotData)
                    self.wordHunt = jsonData
                    completion()
                }catch{
                    print("error")
                }
            case .failure(_):
                print("Error")
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
