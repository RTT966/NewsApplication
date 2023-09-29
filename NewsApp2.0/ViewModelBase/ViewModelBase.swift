//
//  ViewModelBase.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import Foundation

protocol ViewModelBase {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input)-> Output
}
