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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(
            dependencyContainer: DependencyContainer(
                application: UIApplication.shared,
                window: self.window,
                messagePresenter: self.messagePresenter,
                errorHandler: self.errorHandler,
                serverConfigurationManager: self.serverConfigurationManager,
                accessService: self.accessService,
                encoder: self.encoder,
                decoder: self.decoder,
                notificationCenter: NotificationCenter.default,
                taskFormFactory: TaskFormFactory(calendar: Calendar.autoupdatingCurrent),
                viewControllerBuilder: ViewControllerBuilder(),
                keyboardManager: KeyboardManager()))
    }()
    
    private lazy var encoder: JSONEncoderType = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        return encoder
    }()
    
    private lazy var decoder: JSONDecoderType = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        return decoder
    }()
    
    private lazy var messagePresenter: MessagePresenterType = {
       return MessagePresenter(window: self.window)
    }()
    
    private lazy var errorHandler: ErrorHandlerType = {
        return ErrorHandler()
    }()
    
    private lazy var serverConfigurationManager: ServerConfigurationManagerType = {
        return ServerConfigurationManager(
            userDefaults: UserDefaults.standard,
            dispatchQueueManager: DispatchQueueManager(),
            restlerFactory: RestlerFactory())
    }()
    
    private lazy var accessService: AccessServiceLoginType = {
        let sessionManager = SessionManager(
            keychainBuilder: KeychainBuilder(),
            encoder: self.encoder,
            decoder: self.decoder,
            errorHandler: self.errorHandler,
            serverConfigurationManager: self.serverConfigurationManager)
        return AccessService(
            sessionManager: sessionManager,
            temporarySessionManager: TemporarySessionManager(dateFactory: DateFactory()))
    }()

    // MARK: - UIApplicationDelegate
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
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
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.accessService.suspendSession()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.accessService.continueSuspendedSession()
        self.appCoordinator.appDidResume()
    }
}

// MARK: - Private
extension AppDelegate {
}
