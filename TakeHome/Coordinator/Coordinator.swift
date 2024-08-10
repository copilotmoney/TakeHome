//
//  Coordinator.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-09.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
