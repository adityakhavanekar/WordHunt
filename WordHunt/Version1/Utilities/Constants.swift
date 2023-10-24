//
//  Constants.swift
//  WordHunt
//
//  Created by Neosoft on 16/10/23.
//

import Foundation

let environment:Environment = .test

enum Environment{
    case production
    case test
}

enum ColorEnums:String{
    case correct = "#3CB572"
    case wrong = "#FF5252"
}

enum Topics:String{
    
    private var baseUrl:String{
        switch environment {
        case .production:
            return "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/"
        case .test:
            return "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/"
        }
    }
    
    case classic = "wordHunts"
    case animals = "animalWords"
    case brands = "brandWords"
    case cities = "cityWords"
    case countries = "countryWords"
    case gadgets = "deviceWords"
    
    var fullUrl:String{
        return baseUrl+self.rawValue
    }
}

class AdKeys{
    static var bannerAd:String{
        switch environment {
        case .production:
            return "ca-app-pub-8260816350989246/1684325870"
        case .test:
            return "ca-app-pub-3940256099942544/2934735716"
        }
    }
    static var rewardedAd:String{
        switch environment {
        case .production:
            return "ca-app-pub-8260816350989246/9671724588"
        case .test:
            return "ca-app-pub-3940256099942544/1712485313"
        }
    }
}

class BackgroundImages{
    static var classic = "classicBack"
    static var animals = "animalsBack"
    static var brands = "brandsBack"
    static var cities = "citiesBack"
    static var countries = "countriesBack"
    static var gadgets = "gadgetsBack"
}

class InternalImages{
    static var classic = "alphabet"
    static var animals = "animals"
    static var brands = "brand"
    static var cities = "cities"
    static var countries = "countries"
    static var gadgets = "gadgets"
}

class Cells{
    static var homeTableViewCell = "HomeTableViewCell"
    static var questionsCollectionViewCell = "QuestionsCollectionViewCell"
    static var alphabetCollectionViewCell = "AlphabetCollectionViewCell"
}

//Banner:
//        ca-app-pub-8260816350989246/1684325870
//TESTAD: ca-app-pub-3940256099942544/2934735716

//Rewarded
//    Test: ca-app-pub-3940256099942544/1712485313
//    ca-app-pub-8260816350989246/9671724588
