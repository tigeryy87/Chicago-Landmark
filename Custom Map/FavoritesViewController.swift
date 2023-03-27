//
//  FavoritesViewController.swift
//  Custom Map
//
//  Created by Yin-Lin Chen on 2023/2/7.
//


import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    weak var delegate: PlacesFavoritesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // https://stackoverflow.com/questions/42769875/uitableview-without-uiviewcontroller
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func tapDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.sharedInstance.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = DataManager.sharedInstance.favorites[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // send the information about the tapped cell to the MapViewController
        delegate?.favoritePlace(name: DataManager.sharedInstance.favorites[indexPath.row])
        // dismiss itself
        self.dismiss(animated: true, completion: nil)
    }
}
