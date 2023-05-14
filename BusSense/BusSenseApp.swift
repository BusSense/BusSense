//
//  BusSenseApp.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI
import UserNotifications

@main
struct BusSenseApp: App {
    @Environment(\.scenePhase) private var phase
   
    var body: some Scene {
        WindowGroup {
            AnyView(ContentView())
                .onAppear(){
                    // Ask for notification permission
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                }
        }
        .onChange(of: phase) { newPhase in
//            print("changing phase", phase)
//            scheduleNotification()
            switch newPhase {
            case .background: StopMonitoringFetcher.scheduleAppRefresh()
            default: break
            }
        }
        .backgroundTask(.appRefresh("myapprefresh")) {
            print("background task")
            Task{
                await StopMonitoringFetcher.handleBackgroundTask()
            }
        }

    }
}
