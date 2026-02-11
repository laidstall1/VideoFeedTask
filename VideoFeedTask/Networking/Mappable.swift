//
//  Mappable.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 08/02/2026.
//

protocol Mappable {
  associatedtype Output
  
  func map() -> Output
}
