//
//  Structure.swift
//  Remive
//
//  Created by Devang IOS on 19/12/24.
//

import Foundation
import UIKit

// MARK: - Search data model


//recent search - history


// MARK: - Parent detail data model

//user account details
struct ParentDetail {
    var image: UIImage?
    var firstName: String
    var lastName: String?
    var phoneNumber: Int
    var email: String
    var address: String?
    
    var kids: [KidDetail]
}

//allergy
//struct AlTrack {
//    var allergy: AllergyCategory
//}

//kid profile
struct KidDetail {
    var id: Int
    var photo: UIImage?
    var firstName: String
    var lastName: String?
    var dob: Date
    var gender: String?
    var height: Double?
    var weight: Double?
    var alTrack: [AllergyCategory] = [] //allergy track
    var histroy: [HistoryRecord] = []

    var age: Int {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year, .month], from: dob, to: today)
        
        let yearsInMonths = (components.year ?? 0) * 12
        return yearsInMonths + (components.month ?? 0)
    }
}
//history record
struct HistoryRecord {
    let condition: String
    let selectedRemedy: Remedy
    let date: Date
    var rating : Bool = false
}

// user class
class FamilyManager {
    private var parentDetail = ParentDetail(
                image: UIImage(named: "Parent"),
                firstName: "Olivia",
                lastName: "",
                phoneNumber: 1234567890,
                email: "olivia.johnson@email.com",
                address: "123 Main St, Springfield, IL",
                kids: [
                    KidDetail(
                    id: 1,
                    photo: UIImage(named: "kid1"),
                    firstName: "Emma",
                    lastName: "",
                    dob: Calendar.current.date(byAdding: .year, value: -6, to: Date())!,
                    gender: "Female",
                    height: 120.0,
                    weight: 25.5,
                    alTrack: [.aloeVera],
                    histroy: [
                        HistoryRecord(condition: "Cold", selectedRemedy:
                            Remedy(
                                title: "Lemon for Fever",
                                shortDescription: "Lemon has cooling properties helps to boost immune system helps to keep body hydrated",
                                steps: ["Soak a clean cloth in cool water and add a few drops of fresh lemon juice.", "Gently place it on baby’s forehead.", "Apply for 10–15 minutes."],
                                images: ["lemon"],
                                link: "https://www.webmd.com/parenting/baby/features/natural-remedies"
                            ), date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 18))!
                        ),
                        HistoryRecord(condition: "Colic", selectedRemedy:
                            Remedy(
                                title: "Warm Baths",
                                shortDescription: "A warm bath helps soothe the baby and provides relief from colic.",
                                steps: ["Fill the bathtub with warm water (ensure it's not too hot)." ,
                                        "Gently place the baby in the water." ,
                                        "Let the baby relax in the warm water for 10-15 minutes." ,
                                        "Dry the baby gently with a soft towel after the bath."
                                       ],
                                images: ["warm_bath"],
                                link: "https://www.healthline.com/health/baby/baby-bath-temperature#ideal-temperature"
                            ), date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 15))!
                        ),
                    ]
                ),
                    
                KidDetail(
                    id: 2,
                    photo: UIImage(named: "john"),
                    firstName: "Liam",
                    lastName: "",
                    dob: Calendar.current.date(byAdding: .year, value: -3, to: Date())!,
                    gender: "Male",
                    height: 95.0,
                    weight: 15.0,
                    alTrack: [.bakingSoda],
                    histroy: [
                        HistoryRecord(condition: "Colic", selectedRemedy:
                        Remedy(
                            title: "Warm Baths",
                            shortDescription: "A warm bath helps soothe the baby and provides relief from colic.",
                            steps: ["Fill the bathtub with warm water (ensure it's not too hot)." ,
                                    "Gently place the baby in the water." ,
                                    "Let the baby relax in the warm water for 10-15 minutes." ,
                                    "Dry the baby gently with a soft towel after the bath."
                                   ],
                            images: ["warm_bath"],
                            link: "https://www.healthline.com/health/baby/baby-bath-temperature#ideal-temperature"
                        ), date: Date())
                    ]
                )
            ]
        )
    
    private var allAllergyCategories: [AllergyCategory] = [
        .aloeVera,.bakingSoda,.calendula,.cardamom,.chamomileTea,.coconut,.cornstarch,.cumin,.garlic,.ginger,.honey,.lavender,.lemon,.oatmeal,.olive,.onion,.turmeric
    ]
    
    //initialise the singleton instance
    static let shared = FamilyManager()
    
    private init() {}
    
    
    func updateParentDetails(details: ParentDetail) {
        parentDetail = details
    }
    
    // Get the details of the parent.
    func getParentDetails() -> ParentDetail {
        return parentDetail
    }
    
    // Get the details of a particular child by ID.
    func getChildDetails(byID id: Int) -> KidDetail? {
        return parentDetail.kids.first { $0.id == id }
    }
    
    // Get kid details from index
    func getChildDetails(byIndex index: Int) -> KidDetail? {
        return parentDetail.kids[index]
    }
    
    // Add a child to the parent's kids list.
    func addChild(_ child: KidDetail) {
        // Check if a child with the same details already exists
        if parentDetail.kids.contains(where: { $0.firstName == child.firstName && $0.lastName == child.lastName && $0.dob == child.dob }) {
            print("Child \(child.firstName) \(child.lastName ?? "") already exists.")
            return
        }
        
        // Assign a new unique ID
        let newID = (parentDetail.kids.map { $0.id }.max() ?? 0) + 1
        var newChild = child
        newChild.id = newID
        
        // Add the new child to the list
        parentDetail.kids.append(newChild)
        print("Child \(newChild.firstName) \(newChild.lastName ?? "") added with ID \(newID).")
    }
    
    // Remove a child from the parent's kids list by ID.
    func removeChild(byID id: Int) {
        if let index = parentDetail.kids.firstIndex(where: { $0.id == id }) {
            parentDetail.kids.remove(at: index)
            print("Child with ID \(id) removed successfully.")
        } else {
            print("No child found with ID \(id).")
        }
    }
    
    // Update the details of a child by ID
    func updateChildDetails(byID id: Int, with updatedChild: KidDetail) {
        if let index = parentDetail.kids.firstIndex(where: { $0.id == id }) {
            // Ensure the updated child retains the same ID
            var childToUpdate = updatedChild
            childToUpdate.id = id
            parentDetail.kids[index] = childToUpdate
            print("Child with ID \(id) updated successfully.")
        } else {
            print("No child found with ID \(id).")
        }
    }
    
    // Get child count
    func getChildCount() -> Int {
        return parentDetail.kids.count
    }
    
    // Get allergies of a child
    func getAllergies(ofChildID id: Int) -> [AllergyCategory] {
        if let kidDetails = getChildDetails(byID: id) {
            return kidDetails.alTrack
        }
        return []
    }
    
    // Get all allergies
    func getAllAllergies() -> [AllergyCategory] {
        allAllergyCategories
    }
    
    // Get all allergies count
    func getAllAllergiesCount() -> Int {
        allAllergyCategories.count
    }
    
    // Get allergies count of a child
    func getAllergiesCount(ofChildID id: Int) -> Int {
        return getAllergies(ofChildID: id).count
    }
    
    // Add an allergy to a child's allergy track.
    func addAllergy(toChildID id: Int, allergy: AllergyCategory) {
        if let index = parentDetail.kids.firstIndex(where: { $0.id == id }) {
            parentDetail.kids[index].alTrack.append(allergy)
            print("Allergy added to child with ID \(id).")
        } else {
            print("No child found with ID \(id).")
        }
    }
    
    // Remove an allergy from a child's allergy track by allergy name.
    func removeAllergy(fromChildID id: Int, allergy: AllergyCategory) {
        if let kidIndex = parentDetail.kids.firstIndex(where: { $0.id == id }) {
            if let allergyIndex = parentDetail.kids[kidIndex].alTrack.firstIndex(where: { $0.rawValue == allergy.rawValue }) {
                parentDetail.kids[kidIndex].alTrack.remove(at: allergyIndex)
                print("Allergy '\(allergy)' removed from child with ID \(id).")
            } else {
                print("No allergy named '\(allergy)' found for child with ID \(id).")
            }
        } else {
            print("No child found with ID \(id).")
        }
    }
    
    //add search history to the child profile
    func addChildSearchHistory(toChildID id: Int, condition: String, remedy: Remedy) {
        if let index = parentDetail.kids.firstIndex(where: { $0.id == id }) {
//            parentDetail.kids[index].histroy.append(HistoryRecord(condition: condition, selectedRemedy: remedy, date: Date()))
            parentDetail.kids[index].histroy.insert(HistoryRecord(condition: condition, selectedRemedy: remedy, date: Date()), at: 0)
        }
    }
    
    //remove search history of a child profile
    func removeChildSearchHistory(toChildID id: Int, condition: String, remedy: Remedy) {
        if let index = parentDetail.kids.firstIndex(where: { $0.id == id }) {
            // Find the index of the last matching HistoryRecord
            if let recordIndex = parentDetail.kids[index].histroy.lastIndex(where: {
                $0.condition == condition && $0.selectedRemedy.title == remedy.title
            }) {
                // Remove the last matching record
                parentDetail.kids[index].histroy.remove(at: recordIndex)
            }
        }
    }
    
    // For toggling like or dislike of a particular child history rating
    func toggleRating(ofChildId id: Int, condition: String, remedy: Remedy) {
        if let index = parentDetail.kids.firstIndex(where: { $0.id == id }) {
            if let recordIndex = parentDetail.kids[index].histroy.lastIndex(where: {
                $0.condition == condition && $0.selectedRemedy.title == remedy.title
            }) {
                parentDetail.kids[index].histroy[recordIndex].rating.toggle()
            }
        }
    }
}

// MARK: - Remedy suggestion data model

struct Remedy {
    let title: String
    let shortDescription: String
    let steps: [String]
    let images: [String]
    let link: String
}

//cureTip
struct Solution {
    let conditions: [String: [Remedy]]
}

//class for remedy
class RemedySuggestionsModel {
    private init() {}
    
    static let shared = RemedySuggestionsModel()
    
    private let cureTips = Solution (
        conditions: [
            "Diaper Rash":[
                Remedy(
                    title: "Olive Oil",
                    shortDescription: "Olive oil helps soothe and protect the skin from irritation in diaper rash.",
                    steps: ["Clean the affected area gently with water and let it air dry.",
                            "Pour 1 teaspoon of olive oil into your hand.",
                            "Gently apply the olive oil to the affected area.",
                            "Allow the skin to fully dry before putting on a fresh diaper."],
                    images: ["1.1.1", "1.1.2", "1.1.3", "1.1.4"],
                    link: "https://iyurved.com/blogs/allergy-skin-food-others/how-to-treat-diaper-rash-in-babies?utm_medium=sangria&utm_source=sangria_blogs&utm_campaign=sangria_organic"
                ),
                Remedy(
                    title: "Oatmeal",
                    shortDescription: "Oatmeal has moisturizing properties that can help calm irritated skin and provide relief from itching and discomfort.",
                    steps: ["Choose right oatmeal",
                            "Prepare bath with lukewarm water.",
                            "Soak the baby."],
                    images: ["1.2.1", "1.2.2", "1.2.3"],
                    link: "https://www.verywellhealth.com/oatmeal-bath-for-diaper-rash-8686288#:~:text=To%20prepare%20an%20oatmeal%20bath,and%20apply%20a%20gentle%20moisturizer."
                ),
                Remedy(
                    title: "Coconut Oil",
                    shortDescription: "Use coconut oil to moisturize.",
                    steps: ["Apply coconut oil",
                            "Massage gently into the skin"],
                    images: ["1.3.1","1.3.2"],
                    link: "https://example.com/coconut-oil"
                ),
                Remedy(
                    title: "Aloe Vera",
                    shortDescription: "It helps to calm irritated skin, reduce redness, and promote healing.",
                    steps: ["Gently clean your baby's diaper area with lukewarm water",
                            "Apply a thin layer of aloe vera gel directly onto the affected area",
                            "Get aloe vera absorb"],
                    images: ["1.4.1","1.4.2","1.4.3"],
                    link: "https://www.healthline.com/health/skin/aloe-vera-for-rash#how-to-use"
                ),
                Remedy(
                    title: "Cornstarch",
                    shortDescription: "Cornstarch is often used as a remedy for diaper rash because it helps absorb excess moisture and keep the skin dry, which can prevent further irritation.",
                    steps: ["Gently clean your baby’s diaper area using warm water", "Lightly sprinkle a small amount of cornstarch powder directly onto the affected area.", "Gently spread the powder to cover the skin evenly"],
                    images: ["1.5.1","1.5.2","1.5.3"],
                    link: "https://bubzico.com/blogs/news/how-to-get-rid-of-diaper-rash-diy-home-remedies?srsltid=AfmBOoqhotHITys0wncdhqc0WdrCCtYZ-gLHBJ0BI7gZJh8qdgJ2Xy4E"
                ),
                Remedy(
                    title: "Breast Milk",
                    shortDescription: "help prevent infection, while also moisturizing and promoting skin repair.",
                    steps: ["Clean the affected area gently with water and let it dry.", "Using a clean finger or a cotton ball, gently apply a small amount of breast milk directly onto the diaper rash" , "Let it dry for few minutes."],
                    images: ["1.6.1","1.6.2","1.6.3"],
                    link: "https://bubzico.com/blogs/news/how-to-get-rid-of-diaper-rash-diy-home-remedies?srsltid=AfmBOoqhotHITys0wncdhqc0WdrCCtYZ-gLHBJ0BI7gZJh8qdgJ2Xy4E"
                ),Remedy(
                    title: "Baking Soda",
                    shortDescription: "Baking soda is a natural remedy that can help soothe irritated skin, reduce inflammation A baking soda bath can help calm diaper rash by providing relief from itching and redness.",
                    steps: ["Fill your baby's bathtub or a small baby basin with warm water.", "For a small bath, add about 2 tablespoons of baking soda to the water. Stir the water well to dissolve the baking soda completely." , "Let your baby soak in the bath for about 10–15 minutes.", "Dry with soft towel."],
                    images: ["1.7.1","1.7.2","1.7.3","1.7.4"],
                    link: "https://www.webmd.com/parenting/diaper-rash-treatment"
                )
            ],
            "Cold" : [
                Remedy(
                    title: "Onion",
                    shortDescription: "The strong scent of onion vapors can help relieve nasal congestion by opening the nasal passages.",
                    steps: ["Take a medium to large onion and cut it into halves or quarters.", " Set the cut onion pieces in a bowl and place it in the room where your baby sleeps or spends time.","Creating steam that will release the onion’s vapors into the air. Just make sure the steam is mild and not too hot."],
                    images: ["2.1.1","2.1.2","2.1.3"],
                    link: "https://www.pediakid.com/en/blog/articles/5-natural-solutions-to-treat-colds-in-children#:~:text=This%20helps%20unblock%20the%20nose,helps%20your%20child%20sleep%20better."
                ),
                Remedy(
                    title: "Lemon",
                    shortDescription: "Lemon has cooling properties helps to boost immune system helps to keep body hydrated",
                    steps: ["Soak a clean cloth in cool water and add a few drops of fresh lemon juice.", "Gently place it on baby’s forehead.", "Apply for 10–15 minutes."],
                    images: ["2.2.1", "2.2.2","2.2.3"],
                    link: "https://www.webmd.com/parenting/baby/features/natural-remedies"
                ),
                Remedy(
                    title: "Steam",
                    shortDescription: "Steam inhalation works by creating warm, moist air that helps to hydrate and loosen mucus.",
                    steps: ["Boil the water hot.", "Put water in container.", "Let your baby take steam  for about 10–15 minutes", "Repeat 2-3 times in a day."],
                    images: ["2.3.1", "2.3.2", "2.3.3","2.3.4"],
                    link: "https://www.healthline.com/health/steam-inhalation."
                ),
                Remedy(
                    title: "Hot Water",
                    shortDescription: "A hot water bottle provides gentle heat that can help soothe discomfort in babies.",
                    steps: ["Boil water and allow it to cool for a few minutes(40-50 C).", "Gently place the wrapped hot water bottle on your baby’s tummy, back, or chest.","Apply for 10-15 minutes."],
                    images: ["2.4.1","2.4.2","2.4.3"],
                    link: "https://www.cocooncenter.co.uk/journal/a-hot-water-bottle-to-relax-the-baby.html#:~:text=The%20water%20should%20not%20be,the%20baby%20goes%20to%20sleep."
                ),
//
                Remedy(
                    title: "Fluids",
                    shortDescription: "Drinking plenty of water is one of the simplest and most effective remedies for congestion during a cold. Staying hydrated helps to loosen mucus, keep your nasal passages moist, and prevent dehydration, especially warm water",
                    steps: ["If your baby is under 6 months old, the primary source of hydration will still be breast milk or formula and for older give plain water.", "For formula-fed babies, continue to offer their usual formula at regular intervals.", "Give hot liquids for older than 6 months."],
                    images: ["2.5.1","2.5.2","2.5.3"],
                    link: "https://www.mayoclinic.org/diseases-conditions/common-cold/in-depth/cold-remedies/art-20046403#:~:text=Cold%20remedies%20that%20work,unit%20as%20the%20maker%20instructs."
                ),
                Remedy(
                    title: "Saline Drops",
                    shortDescription: "Using saline drops and nasal aspiration  is a common and safe way to relieve congestion in babies, especially when they are having trouble breathing through their nose due to a cold.",
                    steps: ["Prepare saline solution.", "Lay your baby down on their back." , "Gently place 1-2 drops of the saline solution into each nostril and allow to settle down for 1-2 minutes."],
                    images: ["2.6.1","2.6.2","2.6.3"],
                    link: "https://www.verywellhealth.com/how-to-use-saline-nose-drops-in-babies-770597"
                ),Remedy(
                    title: "Humidifier",
                    shortDescription: "It adds moisture to the air, which helps loosen mucus, soothes dry or irritated nasal passages, and can make it easier for your baby to breathe",
                    steps: ["Choose right humidifier.", "Keep it 3 feet away from baby." , "Fill with cool distilled water.", "Apply for overnight."],
                    images: ["2.7.1","2.7.2","2.7.3","2.7.4"],
                    link: "https://www.parents.com/baby/care/newborn/how-close-should-a-humidifier-be-to-baby/#:~:text=%22While%20you%20do%20want%20the,doesn't%20become%20excessively%20damp."
                )
            ],
            
            "Constipation" : [
                Remedy(
                    title: "Exercise",
                    shortDescription: "Exercise can be an effective way to relieve constipation in babies by encouraging movement in their digestive system and promoting bowel movements.",
                    steps: ["Lay your baby on their back on a soft surface, such as a blanket.", "Gently hold their legs.","Perform the bicycle movement slowly and gently, aiming for 1-2 minutes on each side.","help move gas or stool."],
                    images: ["3.1.1","3.1.2","3.1.3","3.1.4"],
                    link: "https://www.medicalnewstoday.com/articles/324543#:~:text=1.-,Exercise,bowels%20function%20and%20relieve%20constipation."
                ),
                Remedy(
                    title: "Warm Bath",
                    shortDescription: "A warm bath can be a soothing and effective remedy to help relieve constipation in babies. The warmth of the water can relax the baby's muscles, including those in the abdomen, which may help promote a bowel movement",
                    steps: ["Fill a baby bathtub with warm water", "he ideal water temperature should be around 98-100°F (37-38°C), which is comfortable for the baby.", "Allow your baby to soak in the warm water for about 10-15 minutes."],
                    images: ["3.2.1","3.2.2","3.2.3"],
                    link: "https://www.webmd.com/parenting/baby/features/natural-remedies"
                ),
                Remedy(
                    title: "Massage",
                    shortDescription: " massage can be an effective way to help relieve constipation in babies. The massage can promote the movement of gas and stool through the intestines, encourage relaxation, and ease discomfort.",
                    steps: ["Choose a quiet, comfortable area where you can give the massage without distractions.", "Place a soft towel or blanket on a flat surface, like a changing table or soft bed. Gently lay your baby on their back.", "Begin by placing your hands gently"],
                    images: ["3.3.1","3.3.2","3.3.3"],
                    link: "https://www.vinmec.com/eng/article/how-to-massage-a-child-with-constipation-en"
                ),
                Remedy(
                    title: "Fruit Juice",
                    shortDescription: "Pear juice can be a gentle and effective natural remedy to help relieve constipation in babies",
                    steps: ["Choose fresh, ripe pears that are soft to the touch but not overly mushy.", "Rinse the pears thoroughly under cold water to remove any dirt or pesticides","Prepare fresh juice."],
                    images: ["3.4.1","3.4.2","3.4.3"],
                    link: "https://medlineplus.gov/ency/article/003125.htm"
                ),
                Remedy(
                    title: "Hydration",
                    shortDescription: "Hydration is essential for maintaining your baby’s overall health and supporting their digestive system, especially when they're dealing with constipation",
                    steps: ["Choose fresh, ripe pears / prunes that are soft to the touch but not overly mushy.", "Rinse the pears/ prunes  thoroughly under cold water to remove any dirt or pesticides.", "Prepare fresh juice."],
                    images: ["3.5.1","3.5.2","3.5.3"],
                    link: "https://www.uptodate.com/contents/constipation-in-infants-and-children-beyond-the-basics/print"
                ),
                Remedy(
                    title: "Fiber Foods",
                    shortDescription: "High-fiber foods are excellent for promoting healthy digestion and can help alleviate constipation in both babies.",
                    steps: ["Give baby Fruits/juices.", "Give Vegetables" , "Give Grains"],
                    images: ["3.6.1","3.6.2","3.6.3"],
                    link: "https://www.niddk.nih.gov/health-information/digestive-diseases/constipation-children/eating-diet-nutrition"
                ),Remedy(
                    title: "Humidifier",
                    shortDescription: "It adds moisture to the air, which helps loosen mucus, soothes dry or irritated nasal passages, and can make it easier for your baby to breathe",
                    steps: ["Choose right humidifier.", "Keep it 3 feet away from baby." , "Fill with cool distilled water.", "Apply for overnight."],
                    images: ["3.7.1","3.7.2","3.7.3","3.7.4"],
                    link: "https://www.parents.com/baby/care/newborn/how-close-should-a-humidifier-be-to-baby/#:~:text=%22While%20you%20do%20want%20the,doesn't%20become%20excessively%20damp."
                )
            ],
            "Dry Skin" : [
                Remedy(
                    title: "Oatmeal",
                    shortDescription: "An oatmeal bath is a soothing and gentle remedy for babies with eczema, dry skin, or irritation. Oatmeal has natural anti-inflammatory properties that can help relieve itching, reduce redness, and moisturize the skin.",
                    steps: ["Take about 1 cup of oatmeal." , "Fill the bathtub with lukewarm water." ,
                            " Gently place your baby in the oatmeal bath for 10-15 minutes and let the baby dry."],
                    images: ["4.1.1","4.1.2","4.1.3"],
                    link: "https://www.verywellhealth.com/oatmeal-bath-for-diaper-rash-8686288."
                ),
                Remedy(
                    title: "Coconut Oil",
                    shortDescription: "It helps to lock in moisture, soothe irritated skin, and may even reduce the severity of eczema flare-ups.",
                    steps: ["Gently cleanse your baby’s skin." , "Once the skin is dry, apply a thin layer of the coconut oil to the affected areas." ,
                            "Allow the coconut oil to fully absorb into the skin."],
                    images: ["4.2.1","4.2.2","4.2.3"],
                    link: "https://www.medicalnewstoday.com/articles/323154."
                ),
                Remedy(
                    title: "Hot Baths",
                    shortDescription: "Hot water can strip the skin of its natural oils, making it even drier and potentially worsening eczema flare-ups.",
                    steps: ["The water should be lukewarm." , "Keep baths short, around 5 to 10 minutes After the bath, gently rinse your baby with cool or lukewarm water to remove any residual soap and help soothe the skin."],
                    images: ["4.3.1","4.3.2","4.3.3"],
                    link: "https://nationaleczema.org/eczema/treatment/bathing/#:~:text=Take%20a%20bath%20using%20lukewarm,areas%20of%20skin%20as%20directed."
                ),
                Remedy(
                    title: "Humidifier",
                    shortDescription: "Using a humidifier in your baby's room can be highly beneficial for managing dry skin, eczema, and respiratory issues, especially during dry months or in climates with low humidity. Humidifiers add moisture to the air, which helps prevent the skin from becoming dry and cracked, soothes irritated skin, and can reduce the severity of eczema flare-ups.",
                    steps: ["A cool mist humidifier is recommended, as it adds moisture to the air without heating the room." ,
                            "Place the humidifier at least 3 feet away from your baby’s crib."],
                    images: ["4.4.1","4.4.2"],
                    link: "https://www.healthline.com/health/eczema/can-using-a-humidifier-treat-the-symptoms-of-eczema."
                ),
                Remedy(
                    title: "Breast Milk",
                    shortDescription: "Breast milk is often considered the best source of nutrition for babies, especially for those with eczema or dry skin.",
                    steps: ["Gently clean your baby’s skin with warm water." , "Apply a small amount of fresh breast milk directly to the areas of skin." ,
                            "Allow the breast milk to fully absorb into the skin 2-3 times."],
                    images: ["4.5.1","4.5.2","4.5.3"],
                    link: "https://www.medicalnewstoday.com/articles/breast-milk-for-eczema#:~:text=For%20infants,treatments%20for%20infants%20with%20eczema.."
                ),
                Remedy(
                    title: "Avoid Soaps",
                    shortDescription: "Harsh soaps and cleansers can strip the skin of its natural oils, leading to dryness, irritation, and worsening of eczema. Instead, opting for mild, gentle, and fragrance-free cleansers is key to maintaining healthy skin.",
                    steps: ["Opt for baby-specific body washes." , "When bathing your baby, avoid scrubbing the skin." ,
                            "Lukewarm water bath 5- 10 min to avoid drying."],
                    images: ["4.6.1","4.6.2","4.6.3"],
                    link: "https://www.webmd.com/parenting/baby/baby-eczema-questions-answers."
                ),
                Remedy(
                    title: "Compress",
                    shortDescription: "Cold compresses can help soothe inflamed skin, reduce redness, and provide instant relief from the itching and burning sensations often associated with eczema.",
                    steps: ["Fill a clean bowl with cool or lukewarm water." , "Keep washcloth on baby’s affected area." ,
                            "Always check your baby’s reaction. If the compress feels too cold or if your baby becomes uncomfortable, remove it immediately. You can also replace the cold compress with a new one if it warms up too quickly."],
                    images: ["4.7.1","4.7.2","4.7.3"],
                    link:"https://www.aad.org/public/diseases/eczema/childhood/itch-relief/home-remedies#:~:text=6%20ways%20to%20relieve%20itchy,just%20treated%20with%20the%20compress."
                ),
                Remedy(
                    title: "Trim Nails",
                    shortDescription: "Keeping your baby's nails trimmed is a simple yet essential step in managing eczema and dry skin. Babies often scratch their skin, especially when they experience itching from conditions like eczema.",
                    steps: ["Choose right tool." , "Trim your baby’s nails when they are calm or sleeping." ,
                            "Hold your baby’s hand firmly but gently while you trim their nails avoid the corners."],
                    images: ["4.8.1","4.8.2","4.8.3"],
                    link: "https://www.webmd.com/skin-problems-and-treatments/eczema/features/child-scratching#:~:text=Be%20Willing%20to%20Try%20Different%20Things,-Experiment%20with%20different&text=SOURCES:,America:%20%22Atopic%20Dermatitis.%22."
                ),
                Remedy(
                    title: "Aloe Vera",
                    shortDescription: " Aloe vera can help calm irritated skin, reduce redness, and promote healing without harsh chemicals, making it a gentle option for babies with sensitive skin.",
                    steps: ["Gently cleanse your baby’s skin." , "Squeeze a small amount of pure aloe vera gel into your hands and gently apply it to the affected areas of your baby’s skin." ,
                            "Aloe vera has a cooling effect and should help soothe the skin almost immediately. You can reapply it 2–3 times a day or as needed."],
                    images: ["4.9.1","4.9.2","4.9.3"],
                    link: "https://www.medicalnewstoday.com/articles/323507."
                ),
            ],
            "Earache" : [
                Remedy(
                    title: "Compress",
                    shortDescription: "Honey helps promote healing and prevents infection in minor cuts and scrapes.",
                    steps: ["Soak a clean cloth in warm (not hot) water and wring out the excess." , "Place the warm, moist compress over your child’s affected ear. Leave the compress in place for 10 to 15 minutes. Repeat as needed to help reduce pain and inflammation."
                           ],
                    images: ["5.1.1","5.1.2"],
                    link: "https://www.healthline.com/health/childrens-health/remedies-for-baby-ear-infection."
                ),
                Remedy(
                    title: "Upright",
                    shortDescription: "Keeping a child upright can help alleviate ear pain by reducing pressure buildup.",
                    steps: ["Use pillows to gently elevate the child’s head while they sleep or rest." ,
                            "Encourage the child to sit upright whenever possible to reduce ear pressure." ,
                            "Ensure the child maintains this position comfortably, especially during sleep." ,
                            "Repeat as needed to provide ongoing relief from ear discomfort."],
                    images: ["5.2.1","5.2.2","5.2.3","5.2.4"],
                    link: "https://kidshealth.org/en/parents/earaches-sheet.html#:~:text=What%20Can%20Help%20a%20Child,your%20doctor%20says%20it's%20OK.."
                ),
                Remedy(
                    title: "Pacifiers",
                    shortDescription: "Avoiding pacifier use can help reduce the risk of ear infections in young children.",
                    steps: ["Gradually reduce the use of pacifiers, especially during sleep and feeding times." ,
                            "Offer alternative soothing methods, like a favorite toy or gentle rocking." ,
                            "Encourage self-soothing techniques to help the child adjust." ,
                            "Monitor for improvement in ear health over time."],
                    images: ["5.3.1","5.3.2","5.3.3","5.3.4"],
                    link: "https://pubmed.ncbi.nlm.nih.gov/11979200/."
                ),
                Remedy(
                    title: "Rest",
                    shortDescription: "Rest and staying hydrated can help relieve congestion by keeping mucus thin and preventing dehydration..",
                    steps: ["Encourage the child to drink water, herbal teas, or clear broths throughout the day." ,
                            "Provide extra pillows to help the child rest with their head elevated." ,
                            "Avoid caffeinated or sugary drinks to maintain hydration." ,
                            "Ensure they get plenty of rest to support recovery and relieve congestion."],
                    images: ["5.4.1","5.4.2","5.4.3","5.4.4"],
                    link: "https://www.mayoclinic.org/diseases-conditions/common-cold/in-depth/cold-remedies/art-20046403#:~:text=Cold%20remedies%20that%20work,unit%20as%20the%20maker%20instructs."
                ),
                Remedy(
                    title: "Liquids",
                    shortDescription: "Warm liquids can soothe a sore throat and ease congestion by providing gentle heat and hydration..",
                    steps: ["Prepare a warm (not hot) drink, such as herbal tea, broth, or warm lemon water with honey." ,
                            "Ensure the temperature is safe for the child to sip comfortably." ,
                            "Encourage slow sips to allow the warmth to soothe the throat and loosen mucus." ,
                            "Offer warm liquids several times a day to maintain relief and hydration."],
                    images: ["5.5.1","5.5.2","5.5.3","5.5.4"],
                    link: "https://health.clevelandclinic.org/home-remedies-for-ear-infection."
                ),
                Remedy(
                    title: "Elevate",
                    shortDescription: "Elevating the head can reduce congestion and ear pressure..",
                    steps: ["Place an extra pillow under the child’s head if they are 1 year or older." ,
                            "For infants, lay them on their back without a pillow." ,
                            "Ensure the child is comfortable and supported."],
                    images: ["5.6.1","5.6.2","5.6.3","5.6.4"],
                    link: "https://babygooroo.com/articles/7-home-remedies-for-ear-pain#:~:text=To%20apply%2C%20warm%20the%20olive,oil%20in%20your%20child's%20ear."
                ),
                Remedy(
                    title: "Garlic",
                    shortDescription: "Garlic oil drops may help ease ear discomfort in older children.",
                    steps: ["Peel and crush the garlic." ,
                            "Add garlic and oil to an unheated pan." ,
                            "Warm on low heat until fragrant, then cool." ,
                            "Strain into a jar and store."
                           ],
                    images: ["5.7.1","5.7.2","5.7.3","5.7.4"],
                    link: "https://www.healthline.com/health/garlic-in-ear#uses"
                ),
            ],
            "Minor Cuts" : [
                Remedy(
                    title: "Honey",
                    shortDescription: "A warm compress can help relieve ear pain by reducing inflammation and soothing discomfort.",
                    steps: ["Clean the wound before applying honey." ,
                            "Apply 5-10 ml of fresh, unprocessed honey to the wound." ,
                            "Repeat twice daily for effective healing." ,
                            "Continue for up to 21 days to ensure proper closure and healing."
                           ],
                    images: ["6.1.1","6.1.2","6.1.3","6.1.4"],
                    link: "https://pubmed.ncbi.nlm.nih.gov/9628301/#:~:text=All%20infants%20showed%20marked%20clinical,adverse%20reactions%20to%20the%20treatment."
                ),
                Remedy(
                    title: "Turmeric",
                    shortDescription: "Turmeric paste helps reduce inflammation and promotes healing of cuts and scrapes.",
                    steps: ["Mix turmeric with warm water to form a paste." ,
                            "Apply the paste gently to the wound." ,
                            "Cover the wound with a clean bandage." ,
                            "Change the bandage as needed to maintain cleanliness."
                           ],
                    images: ["6.2.1","6.2.2","6.2.3","6.2.4"],
                    link: "https://www.medicalnewstoday.com/articles/how-to-make-a-wound-heal-faster#:~:text=It%20also%20states%20that%20curcumin,it%20with%20a%20clean%20bandage."
                ),
                Remedy(
                    title: "Coconut Oil",
                    shortDescription: "Coconut oil helps moisturize and promote healing of minor cuts and scrapes.",
                    steps: ["Scoop a small amount of coconut oil into your hands." ,
                            "Rub it between your fingers or palms to warm it." ,
                            "Gently massage the oil into the affected skin area." ,
                            "Apply as needed to keep the skin moisturized and promote healing."
                           ],
                    images: ["6.3.1","6.3.2","6.3.3","6.3.4"],
                    link: "https://www.healthline.com/health/baby/coconut-oil-for-babies-eczema#how-to-use-it"
                ),
                Remedy(
                    title: "Aloe Vera",
                    shortDescription: "Aloe vera helps soothe the skin and promote healing of scars.",
                    steps: ["Apply aloe vera gel to the scar." ,
                            "Leave it on for 30 minutes." ,
                            "Repeat up to twice per day." ,
                            "Wash off any excess after 30 minutes."
                           ],
                    images: ["6.4.1","6.4.2","6.4.3","6.4.4"],
                    link: "https://www.mustelausa.com/blogs/mustela-mag/first-aid-for-babies-bruises-scars-cuts-wounds-and-scrapes#:~:text=Aloe%20Vera%20%E2%80%94%20Contains%20anti%2Dbacterial,baby's%20skin%20begins%20to%20heal."
                ),
                Remedy(
                    title: "Hydration",
                    shortDescription: "Proper hydration helps support recovery and prevents dehydration.",
                    steps: ["Limit fruit juice to 2–3 ounces (60–120 mL) daily for infants 4 to 8 months old." ,
                            "Offer water as the primary source of hydration." ,
                            "Ensure the child is drinking enough fluids throughout the day." ,
                            "Monitor for any signs of dehydration and adjust fluid intake as needed."
                           ],
                    images: ["6.5.1","6.5.2","6.5.3","6.5.4"],
                    link: "https://www.uptodate.com/contents/constipation-in-infants-and-children-beyond-the-basics/print"
                ),

                Remedy(
                    title: "Compress",
                    shortDescription: "A cold compress helps reduce swelling and numb pain.",
                    steps: ["Apply a cold compress to the injured area." ,
                            "Keep it on for no more than 20 minutes at a time." ,
                            "Repeat 4 to 8 times a day." ,
                            "Ensure the compress is wrapped in a cloth to avoid direct contact with the skin."
                           ],
                    images: ["6.6.1","6.6.2","6.6.3","6.6.4"],
                    link: "https://kidshealth.org/en/parents/strains-sprains-sheet.html#:~:text=Continue%20for%20no%20more%20than,heart%20level%20to%20decrease%20swelling."
                ),
                Remedy(
                    title: "Elevate",
                    shortDescription: "Elevating the affected area helps reduce swelling and promotes healing.",
                    steps: ["Raise the injured area above heart level." ,
                            "Support the area with pillows or cushions if needed." ,
                            "Keep it elevated for 15-30 minutes several times a day." ,
                            "Monitor for any discomfort or increased swelling."
                           ],
                    images: ["6.7.1","6.7.2","6.7.3","6.7.4"],
                    link: "https://kidshealth.org/en/parents/strains-sprains-sheet.html#:~:text=Continue%20for%20no%20more%20than,heart%20level%20to%20decrease%20swelling."
                ),
                Remedy(
                    title: "Bandage",
                    shortDescription: "Bandaging helps protect the wound from infection and promotes healing.",
                    steps: ["Clean the wound before applying a bandage." ,
                            "Use a sterile adhesive bandage or gauze." ,
                            "Secure the bandage with adhesive tape." ,
                            "Change the bandage regularly to keep the wound clean."
                           ],
                    images: ["6.8.1","6.8.2","6.8.3","6.8.4"],
                    link: "https://kidshealth.org/en/parents/bleeding.html#:~:text=Wash%20the%20wound%20with%20a,and%20apply%20a%20new%20one."
                ),
                Remedy(
                    title: "Soap",
                    shortDescription: "Cleaning with mild soap and water helps prevent infection and promotes healing of minor cuts and scrapes.",
                    steps: ["Gently wash the cut with mild soap and water." ,
                            "Let the water run over the wound for several minutes." ,
                            "Avoid scrubbing the wound to prevent irritation." ,
                            "Ensure the area is clean before applying any ointments or bandages."
                           ],
                    images: ["6.9.1","6.9.2","6.9.3","6.9.4"],
                    link: "https://www.childrenshospital.org/conditions/small-cuts-and-scrapes#:~:text=First%2Daid%20for%20cuts%20and%20scrapes&text=Wash%20the%20cut%20area%20well,thoroughly%20cleaned%20can%20cause%20scarring."
                ),
                
            ],
            "Hiccup" : [
                Remedy(
                    title: "Gripe Water",
                    shortDescription: "Gripe water can help reduce hiccups in babies.",
                    steps: ["Read and follow the instructions for the correct dosage." ,
                            "Administer gripe water using a dropper, placing it against the inside of your baby’s cheek." ,
                            "Allow the baby to swallow it slowly." ,
                            "Give gripe water immediately after feedings to help reduce gas and prevent hiccups."
                           ],
                    images: ["7.1.1","7.1.2","7.1.3","7.1.4"],
                    link: "https://www.healthline.com/health/parenting/gripe-water-for-babies#side-effects"
                ),
                Remedy(
                    title: "Burping",
                    shortDescription: "Burping helps release trapped air, reducing hiccups in babies.",
                    steps: ["Gently lift the baby upright after feeding." ,
                            "Burp the baby by patting or rubbing their back." ,
                            "Burp the baby when switching sides during breastfeeding."
                           ],
                    images: ["7.2.1","7.2.2","7.2.3"],
                    link: "https://www.baptisthealth.com/blog/mother-and-baby-care/how-to-get-rid-of-newborn-baby-hiccups-5-tips#:~:text=Burping%20your%20baby%20can%20relieve,be%20burped%20when%20switching%20sides."
                ),
                Remedy(
                    title: "Feedings",
                    shortDescription: "Small, frequent feedings help prevent and relieve hiccups in babies.",
                    steps: ["Feed the baby smaller amounts more frequently." ,
                            "Monitor the baby to avoid overfeeding." ,
                            "Ensure the baby is calm and comfortable during feeding."
                           ],
                    images: ["7.3.1","7.3.2","7.3.3"],
                    link: "https://www.medicalnewstoday.com/articles/321932"
                ),
                Remedy(
                    title: "Rub Back",
                    shortDescription: "Gentle back rubbing helps relax the diaphragm and relieve hiccups.",
                    steps: ["Gently rub your baby's back in circular motions." ,
                            "Start from the shoulder blades and move down to the lower back." ,
                            "Keep the pressure light and soothing." ,
                            "Continue for up to 21 days to ensure proper closure and healing."
                           ],
                    images: ["7.4.1","7.4.2","7.4.3", "7.4.3"],
                    link: "https://kendamil.com/blogs/blog/how-to-stop-baby-hiccups-home-remedies-and-techniques#:~:text=Massaging%20your%20baby's%20back%20can,down%20to%20their%20lower%20back.&text=Sucking%20on%20a%20dummy%20can,baby's%20breathing%20and%20stop%20hiccups."
                ),
                Remedy(
                    title: "Overfeeding",
                    shortDescription: "Avoiding overfeeding helps prevent hiccups in babies.",
                    steps: ["Feed the baby appropriate amounts based on their age and appetite." ,
                            "Monitor the baby's cues to prevent overfeeding." ,
                            "Ensure the baby is calm and comfortable during feeding."
                           ],
                    images: ["7.5.1","7.5.2","7.5.3"],
                    link: "https://www.webmd.com/baby/what-to-do-if-your-baby-has-hiccups"
                ),
                Remedy(
                    title: "Pacifier",
                    shortDescription: "Offering a pacifier can help the baby regulate breathing and stop hiccups.",
                    steps: ["Gently offer the baby a pacifier." ,
                            "Let the baby suck on it to help regulate their breathing." ,
                            "Monitor the baby to ensure comfort while using the pacifier."
                           ],
                    images: ["7.6.1","7.6.2","7.6.3"],
                    link: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2791560/#:~:text=Limit%20the%20time%20you%20allow,give%20up%20using%20a%20pacifier."
                ),
            ],
            "Colic" : [
                Remedy(
                    title: "Warm Baths",
                    shortDescription: "A warm bath helps soothe the baby and provides relief from colic.",
                    steps: ["Fill the bathtub with warm water (ensure it's not too hot)." ,
                            "Gently place the baby in the water." ,
                            "Let the baby relax in the warm water for 10-15 minutes." ,
                            "Dry the baby gently with a soft towel after the bath."
                           ],
                    images: ["8.1.1","8.1.2","8.1.3","8.1.4"],
                    link: "https://www.healthline.com/health/baby/baby-bath-temperature#ideal-temperature"
                ),
                Remedy(
                    title: "Massages",
                    shortDescription: "Gentle tummy massages help relieve gas and ease colic discomfort.",
                    steps: ["Place the baby on their back." ,
                            "Gently massage the tummy in a clockwise motion." ,
                            "Apply light pressure to avoid discomfort." ,
                            "Continue for a few minutes to help release gas and soothe the baby."
                           ],
                    images: ["8.2.1","8.2.2","8.2.3","8.2.4"],
                    link: "https://infacol.co.uk/videos/#:~:text=The%20sun%20and%20moon%20technique,gently%20around%20your%20baby's%20body."
                ),
                Remedy(
                    title: "Swinging",
                    shortDescription: "Rocking or swinging helps soothe and calm the baby during colic.",
                    steps: ["Gently place the baby in a rocking chair or swing." ,
                            "Rock or swing the baby slowly and steadily." ,
                            "Ensure the baby is secure and comfortable." ,
                            "Continue for a few minutes until the baby calms down."
                           ],
                    images: ["8.3.1","8.3.2","8.3.3","8.3.4"],
                    link: "https://my.clevelandclinic.org/health/diseases/10823-colic#:~:text=Comforting%20your%20baby,patting%20their%20back%20or%20chest."
                ),
                Remedy(
                    title: "Sounds",
                    shortDescription: "White noise or soothing sounds help calm the baby and reduce colic discomfort.",
                    steps: ["Play white noise or calming music at a low volume." ,
                            "Place the baby in a quiet and comfortable environment." ,
                            "Monitor the baby to ensure they are relaxed and calm." ,
                            "Continue playing the soothing sounds for 10-15 minutes."
                           ],
                    images: ["8.4.1","8.4.2","8.4.3","8.4.4"],
                    link: "https://www.sleepingbaby.com/blogs/news/white-noise-baby-sleep-explained"
                ),
                Remedy(
                    title: "Burping",
                    shortDescription: "Burping regularly during feedings helps reduce gas and colic discomfort.",
                    steps: ["Gently lift the baby upright during feeding." ,
                            "Burp the baby by patting or rubbing their back." ,
                            "Burp the baby after every few minutes of feeding and after finishing the bottle or breastfeeding."
                           ],
                    images: ["8.5.1","8.5.2","8.5.3"],
                    link: "https://www.unicef.org/parenting/child-care/how-to-burp-baby"
                ),
                Remedy(
                    title: "Swaddling",
                    shortDescription: "Swaddling helps calm and comfort the baby, reducing colic discomfort.",
                    steps: ["Lay the baby on a flat surface." ,
                            "Wrap the baby snugly in a soft, breathable blanket." ,
                            "Ensure the baby’s hips can move freely while keeping the arms secure." ,
                            "Monitor the baby for comfort and adjust the swaddle as needed."
                           ],
                    images: ["8.6.1","8.6.2","8.6.3","8.6.4"],
                    link: "https://kidshealth.org/en/parents/swaddling.html#:~:text=How%20Do%20I%20Swaddle%20My,that%20it%20could%20come%20undone."
                ),
                Remedy(
                    title: "Posture",
                    shortDescription: "Keeping the baby upright after feeding helps reduce gas and colic.",
                    steps: ["Hold the baby upright against your chest or on your shoulder." ,
                            "Keep the baby in this position for 15-30 minutes post-feeding." ,
                            "Gently pat or rub their back to encourage burping if needed."
                           ],
                    images: ["8.7.1","8.7.2","8.7.3","8.7.4"],
                    link: "https://infacol.co.uk/blog/baby-crying-after-feeding/#:~:text=There%20are%20a%20few%20things,to%20reduce%20the%20air%20intake."
                ),
            ],
            "Vomiting" : [
                Remedy(
                    title: "Coconut Water\nLemon Juice",
                    shortDescription: "Coconut water and lemon juice help soothe nausea and vomiting.",
                    steps: ["Mix 1 teaspoon of lemon juice with a cup of coconut water." ,
                            "Offer the mixture to the child in small sips." ,
                            "Repeat every 15 minutes to help relieve nausea."
                           ],
                    images: ["9.8.1","9.8.2","9.8.3"],
                    link: "https://www.krishnaherbals.com/nausea-vomiting.html"
                ),
                Remedy(
                    title: "Cardamom",
                    shortDescription: "Chewing cardamom seeds helps relieve nausea and vomiting.",
                    steps: ["Give the child 1 or 2 cardamom seeds." ,
                            "Encourage them to chew the seeds slowly." ,
                            "Repeat as needed to alleviate nausea."
                           ],
                    images: ["9.9.1","9.9.2","9.9.3"],
                    link: "https://www.krishnaherbals.com/nausea-vomiting.html"
                ),
                Remedy(
                    title: "Cumin",
                    shortDescription: "Cumin seeds and nutmeg tea help soothe nausea and vomiting.",
                    steps: ["Add 1 teaspoon of cumin seeds and a pinch of nutmeg to a cup of hot water." ,
                            "Let it steep for a few minutes." ,
                            "Strain the tea and offer it to the child once it cools slightly."
                           ],
                    images: ["9.10.1","9.10.2","9.10.3"],
                    link: "https://www.krishnaherbals.com/nausea-vomiting.html"
                ),

            ]
        ]
    )
    
    private var suggestedRemedies: [Remedy] = []
    private var suggestedIngredients: [String] = [] //the ones that will be displayed to the user
    private var finalIngredients: [String] = [] //wrt the remedy will be generated
    private var allergies: [AllergyCategory] = [] // to get the kids allergy for filtering the result
    
    func getRemedies() -> [Remedy] {
        return suggestedRemedies
    }
    
    //to set the allergies from the kid detail to the cureAsk
    func setAllergies(forKid kidDetail: KidDetail) {
        if kidDetail.alTrack.isEmpty {
            return
        }
        allergies = kidDetail.alTrack
    }
    
    //to get the allergy
    func getAllergies() -> [AllergyCategory] {
        return allergies
    }
    //to get all the symptoms
    func getSymptomTitles() -> [String] {
        return Array(cureTips.conditions.keys)
    }
//    to append all the remedies to the array
    func selectSymptom(_ symptom: String) -> [String] {
//        guard let remedies = cureTips.conditions[symptom] else { return suggestedIngredients }
//
//        var newSuggestedIngredients: [String] = []
//
//        if allergies.isEmpty {
//            suggestedRemedies.append(contentsOf: remedies)
//        } else {
//            for remedy in remedies {
//                if suggestedIngredients.contains(remedy.title) {
//                    suggestedRemedies.append(remedy)
//                } else if !allergies.contains(where: { $0.allergyName == remedy.title }) {
//                    suggestedRemedies.append(remedy)
//                    suggestedIngredients.append(remedy.title)
//                    newSuggestedIngredients.append(remedy.title)
//                }
//            }
//        }
//
//        return newSuggestedIngredients
        
        var ans: [String] = []
        
        if let remedies = cureTips.conditions[symptom] {
            for remedy in remedies {
                ans.append(remedy.title)
                suggestedRemedies.append(remedy)
            }
        }
        return ans
    }
    //to deselect and change the symptom
    func removeSymptom(_ symptom: String) {
        suggestedRemedies.removeAll(where: { $0.title == symptom })
        suggestedIngredients.removeAll(where: { $0 == symptom })
    }
    //select available remedies -- to append to final ingrediant
    func selectIngredient(_ ingredient: String) {
        finalIngredients.append(ingredient)
    }
    //if he deselect the ingredient
    func removeIngredient(_ ingredient: String) {
        finalIngredients.removeAll(where: { $0 == ingredient })
    }
    //on clicking submit the final list of remedies is returned
    func getSuggestedRemedies() -> [Remedy] {
        var suggestions: [Remedy] = []
        
        for remedy in suggestedRemedies {
            if finalIngredients.contains(where: { $0 == remedy.title }) {
                suggestions.append(remedy)
            }
        }
        
        return suggestions
    }
    //to reset the arrays for next operation
    func clearContent() {
        suggestedRemedies.removeAll()
        suggestedIngredients.removeAll()
        allergies.removeAll()
    }
}

//insights
enum InsightCatogory{
    case babyCare
    case babyDiet
    case naturalRemedies
}

enum AllergyCategory: String {
    case aloeVera = "Aloe Vera"
//    case pacifiers = "Pacifiers"
    case bakingSoda = "Baking Soda"
    case cardamom = "Cardamom"
//    case chewingGum = "Chewing gum"
    case coconut = "Coconut"
    case cornstarch = "Cornstarch"
    case cumin = "Cumin"
//    case fruitJuice = "Fruit juice"
    case garlic = "Garlic"
//    case gripeWater = "Gripe water"
//    case harshSoaps = "Harsh Soaps"
//    case highFiberFoods = "High-Fiber Foods"
    case honey = "Honey"
    case lemon = "Lemon"
    case oatmeal = "Oatmeal"
    case olive = "Olive"
    case onion = "Onion"
    case turmeric = "Turmeric"
    case chamomileTea = "Chamomile tea"
    case ginger = "Ginger"
    case lavender = "Lavender"
    case calendula = "Calendula"
}

struct Insights {
    var id: Int
    var image : UIImage?
    var headingOne : String
    var headingTwo : String
    var subheadingOne : String
    var dataOne : String
    var subheadingTwo : String?
    var dataTwo : String?
    var savedDateTime : Date? = nil
    var allergyCategory: [AllergyCategory]
}

//dont make everything nil
class InsightData {
    
    static var shared = InsightData()
    
    private var ckOne : [InsightCatogory : [[String: Insights]]] = [
        .babyCare: [
            ["Keeping the Baby Warm" : Insights(
                id:1,
                image : UIImage(named: "BabyCare1"),
                headingOne: "Keeping the Baby Warm",
                headingTwo: "Ensuring Baby's Comfort",
                subheadingOne: "Proper Layering for Comfort",
                dataOne: "To help newborns and children maintain body temperature, dress them in one or two more layers than you'd wear. Check their skin—add layers if it feels cold, but avoid overheating, which can pose health risks.",
                subheadingTwo: "Head Covering for Warmth",
                dataTwo: "To prevent heat loss, keep a newborn’s head covered in cooler environments. A soft, breathable hat provides warmth and airflow, ideal for cold weather. Indoors in warm settings, a hat may not be needed.",
                allergyCategory: []
            ),
            ],
            ["Ensuring Safe Sleep for Babies and Young Children" : Insights(
                id:2,
                image : UIImage(named: "BabyCare2"),
                headingOne: "Safe Sleep for Children",
                headingTwo: "Importance of Safe Sleep",
                subheadingOne: "Sleep Position and Safety",
                dataOne: "Always place babies on their backs to sleep, as this position reduces the risk of Sudden Infant Death Syndrome (SIDS). Ensure a safe sleep environment with a firm mattress, fitted sheet, and no soft objects like pillows or stuffed animals, which could obstruct breathing.",
                subheadingTwo: "Sleep Duration and Environment",
                dataTwo: "Newborns typically need 14-17 hours of sleep. As they grow, sleep needs decrease but remain essential. Ensure a quiet, dark room to support better sleep quality.",
                allergyCategory: []
            ),
            ],
            ["Hygiene and Safety Measures" : Insights(
                id:3,
                image : UIImage(named: "BabyCare3"),
                headingOne: "Hygiene and Safety Measures",
                headingTwo: "Cleanliness prevents infection",
                subheadingOne: "Handwashing and Clean Environment",
                dataOne: "Maintain good hygiene by washing hands thoroughly before handling your baby. Babies’ immune systems are still developing, so a clean environment is crucial. Use clean water for food and keep the area free from waste and contaminants to reduce illness risks.",
                subheadingTwo: "Home Safety Precautions",
                dataTwo: "Store toxic items like chemicals and medicines out of reach. Ensure pools or open water areas are secured. A smoke-free environment is vital—avoid smoking indoors or near your baby to protect their respiratory health",
                allergyCategory: []
            ),
            ],
            ["Engaging and Bonding with Your Baby" : Insights(
                id:4,
                image : UIImage(named: "BabyCare4"),
                headingOne: "Bonding with Your Baby",
                headingTwo: "Bond through interaction",
                subheadingOne: "Communication and Attention",
                dataOne: "Talking to your baby and making eye contact helps them feel secure and promotes development. Engage through gentle talk and touch, fostering a bond and creating a foundation for emotional security.",
                subheadingTwo: "Physical Activity for Development",
                dataTwo: "Encourage daily physical activity, like tummy time for muscle strength. As your baby grows, promote more active play like reaching and crawling. For older children, aim for 180 minutes of activity per day for physical and mental health.",
                allergyCategory: []
            ),
            ],
            ["Proper Care and Handling of Your Baby" : Insights(
                id:5,
                image : UIImage(named: "BabyCare5"),
                headingOne: "Hold baby gently",
                headingTwo: "Gentle Handling and Safety",
                subheadingOne: "Support and Care During Handling",
                dataOne: "Always support your baby’s head and neck when lifting or carrying them, as they are still fragile. Avoid shaking, as it can cause serious injury. Seek help if you feel overwhelmed to avoid handling frustration.",
                subheadingTwo: "Bonding Through Physical Contact",
                dataTwo: "Skin-to-skin contact, or kangaroo care, helps regulate temperature and soothes your baby, fostering a sense of safety and attachment crucial for emotional development.",
                allergyCategory: []
            ),
            ],
            ["Diapering and Bathing Care" : Insights(
                id:6,
                image : UIImage(named: "BabyCare6"),
                headingOne: "Clean with care",
                headingTwo: "Clean, wipe, apply cream",
                subheadingOne: "Hygiene and Comfort",
                dataOne: "Have all diapering supplies within reach and clean from front to back to avoid infection. Apply diaper cream as needed and wash your hands thoroughly afterward to prevent spreading germs.",
                subheadingTwo: "Bathing Newborns Safely",
                dataTwo: "Use sponge baths initially, transitioning to regular baths once the umbilical stump heals. Keep water warm, not hot, and bathe only a few times a week to protect sensitive skin from drying out.",
                allergyCategory: []
            ),
            ],
            ["Feeding and Sleep Patterns" : Insights(
                id:7,
                image : UIImage(named: "BabyCare7"),
                headingOne: "Establish a routine",
                headingTwo: "Feeding Your Newborn",
                subheadingOne: "Frequent Feeding and Monitoring",
                dataOne: "Newborns typically need feeding every 2-3 hours. Breastfeeding provides essential nutrients. Monitor for enough wet diapers and weight gain, and consult a pediatrician if concerned about feeding adequacy.",
                subheadingTwo: "Sleep Habits and Environment",
                dataTwo: "Newborns may sleep up to 16 hours daily but often in short periods. Follow safe sleep practices by placing them on their back and avoiding loose bedding. Establish a routine to help your baby develop a healthy sleep pattern as they grow.",
                allergyCategory: []
            ),
            ]
        ],
        .babyDiet: [
            ["Feeding Your Baby: Essential Nutrition for Growth" : Insights(
                id:8,
                image : UIImage(named: "BabyDiet1"),
                headingOne: "Ensure balanced nutrition",
                headingTwo: "Nourish, Grow, Thrive",
                subheadingOne: "6-8 Months: Introducing Solid Foods",
                dataOne: "At 6–8 months, breastmilk remains your baby's main source of nutrition, but solid foods should now be added. Offer half a cup of soft foods two to three times a day, along with small healthy snacks. Focus on mashed fruits, vegetables, grains, and tubers, while avoiding honey until after one year. If your baby refuses a food, try again later or mix it with a familiar food.",
                subheadingTwo: "9-11 Months: Advancing to Finger Foods",
                dataTwo: "From 9–11 months, offer half a cup of food three to four times a day, plus snacks. Your baby may start eating finger foods, so chop food into small pieces. Ensure meals are nutritious, including vegetables, fruits, dairy, eggs, and meats, along with fats for energy. Continue breastfeeding to support their nutritional needs.",
                allergyCategory: []
            ),
            ],
            ["Baby's First Foods: A Guide for 4-6 Months" : Insights(
                id:9,
                image : UIImage(named: "BabyDiet2"),
                headingOne: "Feed gradually",
                headingTwo: "Start with rice cereal",
                subheadingOne: "Why Iron is Essential",
                dataOne: "Between 4-6 months, babies need more iron than breastmilk alone can provide. Single-grain, iron-fortified cereals are an ideal first food, providing easy-to-digest iron. Mixing the cereal with breast milk, formula, or water helps create a smooth consistency for your baby to swallow comfortably.",
                subheadingTwo: "How to Serve Cereal",
                dataTwo: "Start with small spoonfuls, observing how your baby responds to the texture. Iron reserves from birth begin depleting around 6 months, so introducing iron-rich cereals ensures essential nutrition during this critical development period.",
                allergyCategory: []
            ),
            ],
            ["Fruits and Vegetables for 6-8 Month-Olds" : Insights(
                id:10,
                image : UIImage(named: "BabyDiet3"),
                headingOne: "Introduce soft purees",
                headingTwo: "Use fresh fruits/veggies",
                subheadingOne: "Nutrient-Rich Purees",
                dataOne: "By 6-8 months, babies are ready for pureed fruits and vegetables, such as bananas, pears, carrots, and peas. Washing, cooking, and pureeing these foods with a bit of breast milk, formula, or water creates a consistency that’s easy for your baby to eat.",
                subheadingTwo: "Adding Flavor and Texture",
                dataTwo: "Mixing purees with single-grain cereals adds flavor and texture, encouraging variety. Introducing different fruits and veggies lays the groundwork for balanced eating habits and familiarizes babies with various tastes, supporting healthy eating later on.",
                allergyCategory: []
            ),
            ],
            ["8-10 Months: Exploring Mashed Foods and Finger Foods" : Insights(
                id:11,
                image : UIImage(named: "BabyDiet4"),
                headingOne: "Introduce mashed textures",
                headingTwo: "Encourage self-feeding.",
                subheadingOne: "Introducing Mashed Foods",
                dataOne: "By 8-10 months, babies begin to transition from purees to mashed foods with more texture. Foods like mashed sweet potatoes, peas, and chicken offer more substance while remaining easy to eat. As babies gain more control, they may start using their fingers to feed themselves.",
                subheadingTwo: "Safety and Supervision with Finger Foods",
                dataTwo: "For finger foods like small pieces of soft fruit, vegetables, and scrambled eggs, make sure to supervise your baby to prevent choking. Cut food into small, manageable pieces, and be mindful of any allergies.",
                allergyCategory: []
            ),
            ],
            ["10-12 Months: Transitioning to Family Meals" : Insights(
                id:12,
                image : UIImage(named: "BabyDiet5"),
                headingOne: "Serve small, soft portions",
                headingTwo: "Preparing Balanced Meals",
                subheadingOne: "Introducing Family Foods",
                dataOne: "At 10-12 months, your baby can begin eating more family-style meals. Offer mashed, chopped, or soft foods from your plate. Include small portions of foods like pasta, cooked meats, soft fruits, and vegetables. Be mindful of salt and sugar intake at this stage.",
                subheadingTwo: "Continue Breastfeeding",
                dataTwo: "Continue breastfeeding or offering formula while transitioning to solid foods. Breastfeeding remains a primary source of nutrition for babies, providing key nutrients and antibodies.",
                allergyCategory: []
            ),
            ],
            ["Hydration and Baby’s First Drinks" : Insights(
                id:13,
                image : UIImage(named: "BabyDiet6"),
                headingOne: "Monitor hydration levels",
                headingTwo: "Milk and water are key",
                subheadingOne: "Introducing Water",
                dataOne: "Start offering water around 6 months as part of your baby’s hydration. Give small sips in a sippy cup or bottle alongside meals. Babies can also continue breastfeeding or formula feeding for adequate hydration and nutrition.",
                subheadingTwo: "Avoid Sugary Drinks",
                dataTwo: "Avoid offering sugary drinks like juice or soda. These can contribute to tooth decay and lead to unhealthy eating patterns. Water and milk are the best options during this stage.",
                allergyCategory: []
            ),
            ]
        ],
        .naturalRemedies: [
            ["Chamomile Tea for Babies: Soothing Benefits" : Insights(
                id:14,
                image : UIImage(named: "NaturalRemedy1"),
                headingOne: "Chamomile tea can soothe",
                headingTwo: "Calms and Sooths",
                subheadingOne: "Promoting Relaxation and Sleep",
                dataOne: "Chamomile tea is known for its calming properties. For babies experiencing mild discomfort or trouble sleeping, diluted chamomile tea may help soothe them and promote better sleep. Use caution and consult a pediatrician before introducing any herbal remedies.",
                subheadingTwo: "Mild Digestive Relief",
                dataTwo: "Chamomile tea may also provide mild relief for digestive issues like gas or colic. Always ensure the tea is diluted well and only offer small amounts.",
                allergyCategory: [.chamomileTea]
            ),
            ],
            ["Ginger for Baby’s Digestive Health" : Insights(
                id:15,
                image : UIImage(named: "NaturalRemedy2"),
                headingOne: "Ginger aids digestion",
                headingTwo: "Helps sooths tummy",
                subheadingOne: "Gentle Relief for Digestive Discomfort",
                dataOne: "Ginger is known for its ability to ease nausea and support digestion. In small amounts, ginger may help alleviate discomfort from indigestion or colic in babies. Always consult a pediatrician before giving your baby any herbal remedy.",
                subheadingTwo: "Preparation Tips for Babies",
                dataTwo: "Fresh ginger can be used to make a mild tea, but it should be diluted heavily and given in small doses. Avoid using ginger in excess, as it can be too strong for young babies.",
                allergyCategory: [.ginger]
            ),
            ],
            ["Lavender Oil for Baby’s Skin and Sleep" : Insights(
                id:16,
                image : UIImage(named: "NaturalRemedy3"),
                headingOne: "Lavender oil soothes skin",
                headingTwo: "Lavender calms and relaxes",
                subheadingOne: "Lavender’s Calming Effect",
                dataOne: "Lavender oil is often used to calm and relax babies, especially at bedtime. Diluted lavender oil can be gently applied to your baby’s skin to promote relaxation and help with sleep. Be sure to dilute properly and perform a patch test for allergies.",
                subheadingTwo: "Promoting Skin Health",
                dataTwo: "Lavender oil can also be used to treat minor skin irritations like rashes or insect bites. Its natural antiseptic properties help heal the skin without causing further irritation.",
                allergyCategory: [.lavender]
            ),
            ],
            ["Calendula for Baby’s Skin Care" : Insights(
                id:17,
                image : UIImage(named: "NaturalRemedy4"),
                headingOne: "Calendula soothes skin",
                headingTwo: "Ideal for sensitive skin",
                subheadingOne: "Treating Diaper Rash and Irritations",
                dataOne: "Calendula is a gentle herb known for its healing properties. It can be used to treat diaper rash and other skin irritations. Apply calendula-infused creams or oils to the affected area to promote healing and soothe your baby’s skin.",
                subheadingTwo: "Safe and Effective Remedy",
                dataTwo: "Calendula is safe for babies when used appropriately. Avoid using products that contain alcohol or harsh chemicals, and always opt for gentle, natural remedies to avoid irritating delicate skin.",
                allergyCategory: [.calendula]
            ),
            ]
        ]
    ]
    
    private var saved: [Insights] = []
    
    private init() {
    }
    
    func getInsight(section: Int, item: Int) -> Insights {
        switch section {
        case 0:
            return ckOne[.babyCare]![item].values.first!
        case 1:
            return ckOne[.babyDiet]![item].values.first!
        case 2:
            return ckOne[.naturalRemedies]![item].values.first!
        default:
            print("Invalid Section")
            fatalError("Invalid section")
        }
    }
    func getInsightCount() -> Int {
        return ckOne.count
    }
    func getInsightItemCount(at section: Int) -> Int {
        switch section {
        case 0:
            return ckOne[.babyCare]!.count
        case 1:
            return ckOne[.babyDiet]!.count
        case 2:
            return ckOne[.naturalRemedies]!.count
        default:
            fatalError("Invalid section")
        }
        
    }
    //random cat for recommanded for time being
    func getTwoRandomInsights() -> [Insights] {
        let randomCategoryIndex = Int.random(in: 0..<ckOne.count)
        var selectedCategory: [[String: Insights]] = []
        switch randomCategoryIndex {
        case 0:
            selectedCategory = ckOne[.babyCare]!
        case 1:
            selectedCategory = ckOne[.babyDiet]!
        case 2:
            selectedCategory = ckOne[.naturalRemedies]!
        default:
            fatalError("Invalid category index")
        }
        if selectedCategory.count < 2 {
            fatalError("Not enough insights to pick two random ones.")
        }
        // Randomly shuffle the category's items and pick the first two
        let randomItemIndices = Array(0..<selectedCategory.count).shuffled().prefix(2)
        // Fetch the corresponding insights
        let randomInsights = randomItemIndices.map { selectedCategory[$0].values.first! }
        return randomInsights
    }
    
    // Get saved insights array
    func getSavedInsights() -> [Insights] {
        return saved
    }
    
    // Save a insight
    func saveInsight(id: Int) {
        var insightData: Insights?
        
        for category in ckOne.values {
            for item in category {
                if let insight = item.values.first, insight.id == id {
                    insightData = insight
                    break
                }
            }
            if insightData != nil {
                break
            }
        }
        
        insightData?.savedDateTime = Date()
        
        if let insight = insightData {
            saved.append(insight)
        } else {
            print("Insight with ID \(id) not found.")
        }
    }
    
    // Remove an insight from saved list
    func removeInsight(id: Int) {
        if let index = saved.firstIndex(where: { $0.id == id }) {
            saved.remove(at: index)
        } else {
            print("Insight with ID \(id) not found.")
        }
    }
    
    // Remove all insights from saved list
    func removeAllInsights() {
        saved.removeAll()
    }
    
    // Get size of saved insights
    func getSavedInsightsCount() -> Int {
        return saved.count
    }
    
    // Get insight by headings
    func getInsight(byId id: Int) -> Insights {
        return saved.filter { $0.id == id }.first!
    }
    
    // Get heading by ID
    func getHeading(byId id: Int) -> String? {
        for category in ckOne.values {
            for insight in category {
                if insight.values.first!.id == id {
                    return insight.keys.first
                }
            }
        }
        return nil
    }
    
    // Check if an insight is saved
    func isSaved(id: Int) -> Bool {
        return saved.contains(where: { $0.id == id })
    }
    
}
