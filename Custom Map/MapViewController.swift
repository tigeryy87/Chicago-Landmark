//
//  MapViewController.swift
//  Custom Map
//
//  Created by Yin-Lin Chen on 2023/2/7.
//


import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var theTitle: UILabel!
    @IBOutlet var theDescription: UILabel!
    @IBOutlet var theButton: UIButton!
    @IBOutlet var smallView: UIView!
    
    var buttonOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // https://stackoverflow.com/questions/48713377/how-to-show-mapkit-compass
        // Not show any of the Apple provided points of interests
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.setRegion(DataManager.sharedInstance.loadRegion(), animated: true)
        
        // Add annotations
        mapView.register(PlaceMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotations(DataManager.sharedInstance.loadAnnotations())
        
        // initial value of title and description
        theTitle.textColor = UIColor.systemYellow
        theTitle.numberOfLines = 2
        theTitle.lineBreakMode = .byWordWrapping
        theTitle.text = DataManager.sharedInstance.annotations.first?.title
        theDescription.textColor = UIColor.white
        theDescription.numberOfLines = 4
        theDescription.lineBreakMode = .byWordWrapping
        theDescription.text = DataManager.sharedInstance.annotations.first?.longDescription
        smallView.alpha = 0.8
        smallView.backgroundColor = UIColor.black
        smallView.layer.cornerRadius = 10.0
        // this vc should comform to MKMapViewDelegate
        mapView.delegate = self
    }
    
    @IBAction func pressButton(_ sender: Any) {
        if buttonOn {
            buttonOn = false
            theButton.setImage(UIImage(systemName: "star"), for: .normal)
            DataManager.sharedInstance.deleteFavorite(name: theTitle.text!)
            print(DataManager.sharedInstance.favorites)
        } else {
            buttonOn = true
            theButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            DataManager.sharedInstance.saveFavorites(name: theTitle.text!)
            print(DataManager.sharedInstance.favorites)
        }
    }
    
    @IBAction func tapFavoriteButton(_ sender: Any) {
        let favoritesViewController = self.storyboard?.instantiateViewController(identifier: "FavoritesViewController") as! FavoritesViewController
        // https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller
        if let sheet = favoritesViewController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(favoritesViewController, animated: true, completion: nil)
        // this vc should comform to PlacesFavoritesDelegate
        favoritesViewController.delegate = self
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation as? Place
        theTitle.text = selectedAnnotation?.name
        theDescription.text = selectedAnnotation?.longDescription
        if let title = theTitle.text {
            if DataManager.sharedInstance.isFavorite(name: title) {
                buttonOn = true
                theButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                buttonOn = false
                theButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
}

extension MapViewController: PlacesFavoritesDelegate {
    func favoritePlace(name: String) {
        print(name)
        // show the place
        mapView.setRegion(DataManager.sharedInstance.getRegion(name: name)!, animated: true)
        // change title, description, and star
        theTitle.text = name
        theDescription.text = DataManager.sharedInstance.getDescription(name: name)
        buttonOn = true
        theButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
}
