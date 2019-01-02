//
//  AppDelegate.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 17/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit
import KeychainAccess
import CoreStore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: window,
                              storyboardsManager: StoryboardsManager.shared,
                              errorHandler: errorHandler,
                              serverConfigurationManager: serverConfigurationManager,
                              coreDataStack: coreDataStack,
                              accessServiceBuilder: { (serverConfiguration, encoder, decoder) in
                                return AccessService(userDefaults: UserDefaults.standard,
                                                     keychainAccess: self.createKeychain(with: serverConfiguration),
                                                     coreData: self.coreDataStack,
                                                     buildEncoder: { return encoder },
                                                     buildDecoder: { return decoder })
        })
    }()
    
    private lazy var errorHandler: ErrorHandlerType = {
        return ErrorHandler()
    }()
    
    private lazy var serverConfigurationManager: ServerConfigurationManagerType = {
        return ServerConfigurationManager(urlSession: URLSession.shared, userDefaults: UserDefaults.standard)
    }()
    
    private lazy var coreDataStack: CoreDataStackType = {
        do {
            return try CoreDataStack(buildStack: { (xcodeModelName, fileName) throws -> DataStack in
                let dataStack = DataStack(xcodeModelName: xcodeModelName)
                try dataStack.addStorageAndWait(
                    SQLiteStore(
                        fileName: fileName,
                        localStorageOptions: .recreateStoreOnModelMismatch
                    )
                )
                return dataStack
            })
        } catch {
            fatalError("Core Data Stack error:\n \(error)")
        }
    }()

    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        appCoordinator.start()
        return true
    }
    
    // MARK: - Private
    private func createKeychain(with configuration: ServerConfiguration) -> Keychain {
        if let host = configuration.host {
            if host.isHTTP {
                return Keychain(server: host, protocolType: .http)
            } else if host.isHTTPS {
                return Keychain(server: host, protocolType: .https)
            }
        }
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return Keychain()
        }
        return Keychain(accessGroup: bundleIdentifier)
    }
}
