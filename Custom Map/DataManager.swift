//
//  DataManager.swift
//  Custom Map
//
//  Created by Yin-Lin Chen on 2023/2/7.
//


import Foundation
import MapKit

// https://stackoverflow.com/questions/28604429/how-to-open-maps-app-programmatically-with-coordinates-in-swift
public class DataManager {
  
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()
    var plist = NSDictionary()
    var favorites: [String] = []
    var annotations: [Place] = []
    
    //This prevents others from using the default '()' initializer
    fileprivate init() {
        loadAnnotationFromPlist()
    }

    // Your code (these are just example functions, implement what you need)
    func loadAnnotationFromPlist() -> Void {
        plist = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Data", ofType: "plist")!)!
    }
    
    func saveFavorites(name: String) -> Void {
        favorites.append(name)
    }
    
    func deleteFavorite(name: String) -> Void {
        var index = 0
        for i in 0...favorites.count-1 {
            if favorites[i] == name {
                index = i
            }
        }
        favorites.remove(at: index)
    }
    
    func isFavorite(name: String) -> Bool {
        return favorites.contains(name)
    }
    
    func getRegion(name: String) -> MKCoordinateRegion? {
        for annotation in annotations {
            if annotation.title == name {
                let miles: Double = 3 * 500
                let centerPoint = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)
                let viewRegion = MKCoordinateRegion(center: centerPoint, latitudinalMeters: miles, longitudinalMeters: miles)
                return viewRegion
            }
        }
        return nil
    }
    
    func getDescription(name: String) -> String? {
        for annotation in annotations {
            if annotation.title == name {
                return annotation.longDescription
            }
        }
        return nil
    }
    
    // Load data from plist
    func loadRegion() -> MKCoordinateRegion {
        let region = plist["region"]! as? [Double]
        let miles: Double = 3 * 500
        let centerPoint = CLLocationCoordinate2DMake(region![0], region![1])
        let viewRegion = MKCoordinateRegion(center: centerPoint, latitudinalMeters: miles, longitudinalMeters: miles)
        return viewRegion
    }
    
    func loadAnnotations() -> [Place] {
        let places = plist["places"]! as? [NSDictionary]
        for place in places! {
            let annotation = Place()
            annotation.title = place["name"]! as? String
            annotation.name = place["name"]! as? String
            annotation.longDescription = place["description"]! as? String
            if let lat = place["lat"]! as? Double, let long = place["long"]! as? Double{
                annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                annotations.append(annotation)
            }
        }
        return annotations
    }
  
}
