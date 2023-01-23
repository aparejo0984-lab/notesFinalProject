import UIKit
import CoreData
import CoreLocation

class NoteDetailViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
	@IBOutlet weak var titleTF: UITextField!
	@IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var locationManager:CLLocationManager!
    var selectedNote: Note? = nil
    var latitude: Double = 0.0
    var longtitute: Double = 0.0
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		if(selectedNote != nil)
		{
			titleTF.text = selectedNote?.title
			descTV.text = selectedNote?.desc
            latitude = selectedNote!.latitude
            longtitute = selectedNote!.longtitude
            if UIImage(data: selectedNote!.image ?? Data()) != nil {
                imageView.image = UIImage(data: selectedNote!.image ?? Data())
            }
		}
	}
    
	@IBAction func saveAction(_ sender: Any)
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
		if(selectedNote == nil)
		{
			let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
			let newNote = Note(entity: entity!, insertInto: context)
			newNote.id = noteList.count as NSNumber
			newNote.title = titleTF.text
			newNote.desc = descTV.text
            newNote.createdDate = Date()
            newNote.latitude = latitude
            newNote.longtitude = longtitute
            
            if let imageData = imageView.image?.pngData() {
                newNote.image = imageData
            }
			do
			{
				try context.save()
				noteList.append(newNote)
                Toast(Title: "Note saved", Text: "Note is successfully saved")
			}
			catch
			{
				print("context save error")
			}
		}
		else //edit
		{
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
			do {
				let results:NSArray = try context.fetch(request) as NSArray
				for result in results
				{
					let note = result as! Note
					if(note == selectedNote)
					{
						note.title = titleTF.text
						note.desc = descTV.text
                        if let imageData = imageView.image?.pngData() {
                            note.image = imageData
                        }
                        
						try context.save()
                        Toast(Title: "Note saved", Text: "Note is successfully modified")
					}
				}
			}
			catch
			{
				print("Fetch Failed")
			}
		}
	}
	
	@IBAction func DeleteNote(_ sender: Any)
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
		do {
			let results:NSArray = try context.fetch(request) as NSArray
			for result in results
			{
				let note = result as! Note
				if(note == selectedNote)
				{
					note.deletedDate = Date()
					try context.save()
                    Toast(Title: "Note deleted", Text: "Note is successfully deleted")
				}
			}
		}
		catch
		{
			print("Fetch Failed")
		}
	}
    
    @IBAction func pickPhoto(_ sender: Any) {
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .photoLibrary
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.modalPresentationStyle = .fullScreen
        present(photoPicker, animated: true)
    }
    
    func Toast(Title:String ,Text:String) -> Void {
        let alert = UIAlertController(title: Title, message: Text, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "mapSegue")
        {
            let mapView = segue.destination as? MapViewController
            mapView?.latitude = latitude
            mapView?.longtitute = longtitute
            
        }
    }
}
