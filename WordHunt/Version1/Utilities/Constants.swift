//
//  Constants.swift
//  WordHunt
//
//  Created by Neosoft on 16/10/23.
//

import Foundation

enum Environment{
    case production
    case test
}

var environment:Environment = .production

enum Topics:String{
    case classic = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/wordHunts"
    case animals = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/animalWords"
    case brands = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/brandWords"
    case cities = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/cityWords"
    case countries = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/countryWords"
    case gadgets = "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/deviceWords"
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

class Cells{
    static var homeTableViewCell = "HomeTableViewCell"
    static var questionsCollectionViewCell = "QuestionsCollectionViewCell"
    static var alphabetCollectionViewCell = "AlphabetCollectionViewCell"
}
