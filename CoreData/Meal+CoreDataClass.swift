import Foundation
import CoreData

@objc(Meal)
public class Meal: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case strMeal, idMeal, strInstructions, strMealThumb, strTags, strYoutube, strCategory, strArea, ingredients
    }
    
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public required init(from decoder: Decoder) throws {
        let moc = PersistenceController.shared.container.viewContext
        super.init(entity: .entity(forEntityName: "Meal", in: moc)!, insertInto: moc)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal)
        self.idMeal = try container.decodeIfPresent(String.self, forKey: .idMeal)
        self.strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        self.strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        self.strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        self.strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)
        
        let categoryName = try container.decode(String.self, forKey: .strCategory)
        let areaName = try container.decode(String.self, forKey: .strArea)
        do
        {
            try fetchOrCreateCategory(withName: categoryName, in: moc)
            try fetchOrCreateArea(withName: areaName, in: moc)
        } catch let error {
            print(error)
        }
        
        

        // Rest of the decoding logic for other properties if any
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
