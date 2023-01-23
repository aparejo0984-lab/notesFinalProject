
import CoreData
import UIKit

@objc(Note)
class Note: NSManagedObject
{
	@NSManaged var id: NSNumber!
	@NSManaged var title: String!
	@NSManaged var desc: String!
	@NSManaged var deletedDate: Date?
    @NSManaged var createdDate: Date?
    @NSManaged var image: Data?
    @NSManaged var latitude: Double
    @NSManaged var longtitude: Double
}
