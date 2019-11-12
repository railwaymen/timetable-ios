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

typealias AccessServiceBuilderType = ((ServerConfiguration, JSONEncoderType, JSONDecoderType) -> AccessServiceLoginType)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(
            dependencyContainer: DependencyContainer(
                application: UIApplication.shared,
                window: self.window,
                messagePresenter: self.messagePresenter,
                storyboardsManager: StoryboardsManager.shared,
                errorHandler: self.errorHandler,
                serverConfigurationManager: self.serverConfigurationManager,
                coreDataStack: self.coreDataStack,
                accessServiceBuilder: self.accessServiceBuilder,
                encoder: self.encoder,
                decoder: self.decoder,
                notificationCenter: NotificationCenter.default))
    }()
    
    private lazy var encoder: JSONEncoderType = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return encoder
    }()
    
    private lazy var decoder: JSONDecoderType = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    private lazy var messagePresenter: MessagePresenterType = {
       return MessagePresenter(window: self.window)
    }()
    
    private lazy var errorHandler: ErrorHandlerType = {
        return ErrorHandler()
    }()
    
    private lazy var serverConfigurationManager: ServerConfigurationManagerType = {
        return ServerConfigurationManager(urlSession: URLSession.shared, userDefaults: UserDefaults.standard, dispatchQueueManager: DispatchQueueManager())
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
    
    private lazy var accessServiceBuilder: AccessServiceBuilderType = { (serverConfiguration, encoder, decoder) in
        return AccessService(userDefaults: UserDefaults.standard,
                             keychainAccess: self.createKeychain(with: serverConfiguration),
                             coreData: self.coreDataStack,
                             buildEncoder: { return encoder },
                             buildDecoder: { return decoder })
    }

    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        self.appCoordinator.start()
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
