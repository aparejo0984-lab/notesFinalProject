import UIKit
import CoreData

class DataBaseHelper {
    
    static let shareInstance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveNote(data: Note) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
        let newNote = Note(entity: entity!, insertInto: context)

        do
        {
            try context.save()
            noteList.append(data)
            return true
        }
        catch
        {
            return false
        }
    }
}
