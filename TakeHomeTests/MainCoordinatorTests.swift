//
//  MainCoordinatorTests.swift
//  TakeHomeTests
//
//  Created by Josue Hernandez on 2024-08-10.
//

import XCTest
@testable import TakeHome

final class MainCoordinatorTests: XCTestCase {

    var navigationController: MockNavigationController!
    var mainCoordinator: MainCoordinator!

    override func setUp() {
        super.setUp()
        navigationController = MockNavigationController()
        mainCoordinator = MainCoordinator(navigationController: navigationController)
    }

    override func tearDown() {
        navigationController = nil
        mainCoordinator = nil
        super.tearDown()
    }

    func testStartPushesMainViewController() {
        // Act
        mainCoordinator.start()
        
        // Assert
        XCTAssertTrue(navigationController.pushedVC is MainViewController)
    }

    func testPresentBirdDetailSheetPresentsDetailViewController() {
        // Arrange
        let bird = Bird(
            id: "1",
            nameSpanish: "Halcón",
            nameEnglish: "Falcon",
            nameLatin: "Falco",
            thumbImageUrl: "https://example.com/thumb.jpg",
            fullImageUrl: "https://example.com/full.jpg",
            sortIndex: 1
        )

        // Act
        mainCoordinator.presentBirdDetailSheet(for: bird)

        // Assert
        XCTAssertTrue(navigationController.presentedVC is BirdDetailViewController)
        let detailViewController = navigationController.presentedVC as? BirdDetailViewController
        XCTAssertEqual(detailViewController?.bird.nameEnglish, "Falcon")
    }
}

// Mock Navigation Controller

class MockNavigationController: UINavigationController {
    var pushedVC: UIViewController?
    var presentedVC: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }

    override func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewController
        super.present(viewController, animated: animated, completion: completion)
    }
}
