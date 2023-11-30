import Foundation
import CoreData

@objc(Meal)
public class Meal: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strInstructions, strMealThumb, strTags, strYoutube, strCategory, strArea, strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20, strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20, ingredients
    }
    
    
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    public required init(from decoder: Decoder) throws {
        
        let moc = PersistenceController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Meal", in: moc)!
        super.init(entity: entity, insertInto: moc)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idMeal = try container.decodeIfPresent(String.self, forKey: .idMeal)
        self.strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal)
        self.strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        self.strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        self.strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        self.strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)
        
        let categoryName = try container.decodeIfPresent(String.self, forKey: .strCategory)
        let areaName = try container.decodeIfPresent(String.self, forKey: .strArea)
        do {
            self.category = try fetchOrCreateCategory(withName: categoryName ?? "unkown", in: moc)
            self.area = try fetchOrCreateArea(withName: areaName ?? "unkown", in: moc)
        } catch let error {
            print("Error: \(error)")
        }
        
        let mealDetails = try MealDetails(from: decoder)

        // Processing ingredients and measurements
        var measurementsSet = Set<Measurements>()

        // Assuming MealDetails has strIngredient1...strIngredient20 and strMeasure1...strMeasure20
        if let ingredient1 = mealDetails.strIngredient1, let measure1 = mealDetails.strMeasure1, !ingredient1.isEmpty, !measure1.isEmpty {
                let measurement = Measurements(context: moc)
                measurement.strIngredients = ingredient1
                measurement.strMeasure = measure1
                measurement.meal = self
                measurementsSet.insert(measurement)
            
        }
        self.measurements = NSSet(set: measurementsSet)
        
    }
       
    
    
    func fetchOrCreateIngredient(withName name: String, in context: NSManagedObjectContext) throws -> Ingredients {
        let fetchRequest: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "strIngredient == %@", name)

        let results = try context.fetch(fetchRequest)
        if let existingIngredient = results.first {
            return existingIngredient
        } else {
            let newIngredient = Ingredients(context: context)
            newIngredient.strIngredient = name
            return newIngredient
        }
    }

    
    func fetchOrCreateCategory(withName categoryName: String, in context: NSManagedObjectContext) throws -> Category {
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "strCategory == %@", categoryName)
        
        let categories = try context.fetch(categoryFetchRequest)
        if let category = categories.first {
            self.category = category
            return category
        } else {
            let newCategory = Category(context: context)
            newCategory.strCategory = categoryName
            return newCategory
        }
    }
    func fetchOrCreateArea(withName areaName: String, in context: NSManagedObjectContext) throws -> Area {
        let areaFetchRequest: NSFetchRequest<Area> = Area.fetchRequest()
        areaFetchRequest.predicate = NSPredicate(format: "strArea == %@", areaName)
        
        let area = try context.fetch(areaFetchRequest)
        if let area = area.first {
            self.area = area
            return area
        } else {
            let newArea = Area(context: context)
            newArea.strArea = areaName
            return newArea
        }
    }
}

