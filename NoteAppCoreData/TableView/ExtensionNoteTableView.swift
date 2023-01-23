import UIKit

extension NoteTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! NoteCell
        
        let thisNote: Note!
        
        if(searchController.isActive)
        {
            thisNote = filteredNotes[indexPath.row]
        }
        else
        {
            thisNote = nonDeletedNotes()[indexPath.row]
        }
        
        noteCell.titleLabel.text = thisNote.title
        noteCell.descLabel.text = thisNote.desc
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM"

        let createdDate = dateFormatter.string(from: thisNote.createdDate!)
        
        noteCell.dateLabel.text = createdDate
        
        return noteCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(searchController.isActive)
        {
            return filteredNotes.count
        }
        
        return nonDeletedNotes().count
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
}
