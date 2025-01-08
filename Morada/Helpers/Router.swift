//
//  Router.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 24/09/24.
//

import Foundation

@Observable
class Router {
    var navigationPath = NavigationPath()

    func navigateTo(route: Route) {
        navigationPath.append(route)
    }
}
