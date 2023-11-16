
import Foundation
import CoreData

@objc(Ingredients)
public class Ingredients: NSManagedObject, Decodable {
    enum codingKeys: CodingKey{
        case idIngredient
        case strIngredient
        case strDescription
        case strType
    }
    
    public required init(from decoder: Decoder) throws {
        let moc = PersistenceController.shared.container.viewContext
        
        super.init(entity: .entity(forEntityName: "Ingredients", in: moc)!, insertInto: moc)
        
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.idIngredient = try container.decodeIfPresent(String.self, forKey: .idIngredient)
        self.strIngredient = try container.decodeIfPresent(String.self, forKey: .strIngredient)
        self.strDescription = try container.decodeIfPresent(String.self, forKey: .strDescription)
        self.strType = try container.decodeIfPresent(String.self, forKey: .strType)
    }
    
}
