import UIKit

extension NoteTableViewController {
    func initSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        
        filterForSearchText(searchText: searchText)
    }
    
    func filterForSearchText(searchText: String)
    {
        filteredNotes = noteList.filter
        {
            note in
            if(searchController.searchBar.text != "")
            {
                let searchTitleTextMatch = note.title.lowercased().contains(searchText.lowercased())
                if (searchTitleTextMatch) {
                    return searchTitleTextMatch
                } else {
                    let searchDescTextMatch = note.desc.lowercased().contains(searchText.lowercased())
                    return searchDescTextMatch
                }
            }
            else
            {
                return false
            }
        }
        tableView.reloadData()
    }
}
