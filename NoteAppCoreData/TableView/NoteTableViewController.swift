import UIKit
import CoreData


var noteList = [Note]()

class NoteTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating
{
	var firstLoad = true
    var filteredNotes = [Note]()
    
    let searchController = UISearchController()
    
	func nonDeletedNotes() -> [Note]
	{
		var noDeleteNoteList = [Note]()
		for note in noteList
		{
			if(note.deletedDate == nil)
			{
				noDeleteNoteList.append(note)
			}
		}
		return noDeleteNoteList
	}
	
	override func viewDidLoad()
	{
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        initSearchController()
        
		if(firstLoad)
		{
			firstLoad = false
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
			do {
				let results:NSArray = try context.fetch(request) as NSArray
				for result in results
				{
					let note = result as! Note
					noteList.append(note)
				}
			}
			catch
			{
				print("Fetch Failed")
			}
		}
	}
		
    @IBAction func sortAsc(_ sender: Any)
    {
        noteList = [Note]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let sort = NSSortDescriptor(key: #keyPath(Note.createdDate), ascending: true)
        request.sortDescriptors = [sort]
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let note = result as! Note
                noteList.append(note)
            }
        }
        catch
        {
            print("Fetch Failed")
        }
        tableView.reloadData()
    }
    
    @IBAction func sortDesc(_ sender: Any)
    {
        noteList = [Note]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let sort = NSSortDescriptor(key: #keyPath(Note.createdDate), ascending: false)
        request.sortDescriptors = [sort]
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let note = result as! Note
                noteList.append(note)
            }
        }
        catch
        {
            print("Fetch Failed")
        }
        tableView.reloadData()
    }
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if(segue.identifier == "editNote")
		{
			let indexPath = tableView.indexPathForSelectedRow!
			
			let noteDetail = segue.destination as? NoteDetailViewController
			
			let selectedNote : Note!
			selectedNote = nonDeletedNotes()[indexPath.row]
			noteDetail!.selectedNote = selectedNote
			
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
}
