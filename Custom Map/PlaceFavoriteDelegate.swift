//
//  PlaceFavoriteDelegate.swift
//  Custom Map
//
//  Created by Yin-Lin Chen on 2023/2/7.
//

import Foundation

protocol PlacesFavoritesDelegate: AnyObject {
    func favoritePlace(name: String) -> Void
}
