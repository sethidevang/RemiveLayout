//
//  Allergy.swift
//  Remive
//
//  Created by Disha Sharma on 01/12/24.
//

import Foundation

struct Allergy {
    var title: String
    var subtitle : String
}

var Allergies: [Allergy] = [
    Allergy(title: "Allergy1", subtitle: "Allergy Description"),
    Allergy(title: "Allergy1", subtitle: "Allergy Description"),
    Allergy(title: "Allergy1", subtitle: "Allergy Description")
]




enum allergyName: String {
    case aloeVera = "Aloe Vera"
    case appleJuice = "Apple Juice"
    case breastMilk = "Breast Milk"
    case cardamom = "Cardamom"
    case coconutOil = "Coconut Oil"
    case cornstarch = "Cornstarch"
    case cumin = "Cumin"
    case fruitJuice = "Fruit Juice"
    case garlicOilDrops = "Garlic Oil Drops"
    case gripeWater = "Gripe Water"
    case highFiberFoods = "High-Fiber Foods"
    case honey = "Honey"
    case lemon = "Lemon"
    case oatmeal = "Oatmeal"
    case oatmealBath = "Oatmeal Bath"
    case oliveOil = "Olive Oil"
    case onion = "Onion"
    case pearJuice = "Pear Juice"
    case pruneJuice = "Prune Juice"
    case turmeric = "Turmeric"
}
