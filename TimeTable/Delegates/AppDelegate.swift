//
//  AppDelegate.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 17/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit
import KeychainAccess
import Firebase

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
                storyboardsManager: StoryboardsManager(),
                errorHandler: self.errorHandler,
                serverConfigurationManager: self.serverConfigurationManager,
                accessServiceBuilder: self.accessServiceBuilder,
                encoder: self.encoder,
                decoder: self.decoder,
                notificationCenter: NotificationCenter.default))
    }()
    
    private lazy var encoder: JSONEncoderType = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private lazy var decoder: JSONDecoderType = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
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
    
    private lazy var accessServiceBuilder: AccessServiceBuilderType = { (serverConfiguration, encoder, decoder) in
        return AccessService(
            keychainAccess: self.createKeychain(with: serverConfiguration),
            encoder: encoder,
            decoder: decoder)
    }

    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        self.appCoordinator.start()
        #if TEST
        if let screenToTest = ProcessInfo.processInfo.environment["screenToTest"],
            let coordinatorType = CoordinatorType(rawValue: screenToTest) {
            self.appCoordinator.openDeepLink(option: .testPage(coordinatorType))
        }
        #endif
        return true
    }
}

// MARK: - Private
extension AppDelegate {
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
