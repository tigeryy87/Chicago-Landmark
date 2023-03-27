//
//  PlaceMarkerView.swift
//  Custom Map
//
//  Created by Yin-Lin Chen on 2023/2/7.
//

import Foundation
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
      willSet {
        clusteringIdentifier = "Place"
        displayPriority = .defaultLow
        markerTintColor = .systemRed
        glyphImage = UIImage(systemName: "pin.fill")
        }
  }
}
