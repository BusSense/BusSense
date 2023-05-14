//
//  BusConfimationView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/6/23.
//

import SwiftUI

struct BusTrackingView: View {
    
    var busStop: BusStopRoute
    var busRoute: RouteDetail
    
    @StateObject var stopMonitoringFetcher: StopMonitoringFetcher = StopMonitoringFetcher.shared
    
    let notificationManager: NotificationManager = NotificationManager.shared

    // Notify users of status and fetch new changes every 30 seconds
    func notifyLoop() {
        Task{
            Timer.scheduledTimer(withTimeInterval:10.0, repeats: true) {time in
                print("timer tick")
                stopMonitoringFetcher.scheduleNotification()
                fetchUpdates()
            }
            
        }
    }
    
    func fetchUpdates(){
        Task{
            await stopMonitoringFetcher.fetchStopMonitoring(monitoringRef: busStop.code, lineRef: busRoute.lineRef.replacingOccurrences(of: " ", with: "%20"))
        }
    }
    
    var body: some View {
        
        let proximityData = stopMonitoringFetcher.getProximityAway()
        let metersData = stopMonitoringFetcher.getMetersAway()
        let stopsData = stopMonitoringFetcher.getStopsAway()
        let timeData = stopMonitoringFetcher.getTimeAway()
        
        ZStack {
            
            Color("Color1").ignoresSafeArea()
            
            VStack {
                
                Spacer().frame(height: 10)
                
                VStack {
                    
                    Spacer().frame(height: 10)
                    
                    Text("CURRENTLY TRACKING:")
                        .frame(width: 350, height: 30)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                    
                    if proximityData == "No vehicles detected at this time. Please try again later." {
                        Text("\(busRoute.lineNameAndDestinationName)" + "\n\n\(proximityData)")
                            .frame(width: 350, height: 200)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                    } else {
                        Text("\(busRoute.lineNameAndDestinationName)" + "\n\n\(proximityData)\n\(metersData) meters away\n\(stopsData) stops away\n\(timeData)")
                            .frame(width: 350, height: 200)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                    }
                }
                .frame(width: 375, height: 300, alignment: .top)
                .background(Color("Color2"))
                .cornerRadius(20)
                
                VStack {
                    
                    Spacer().frame(height: 10)
                    
                    Text("NOTICE:")
                        .frame(width: 350, height: 30)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                    
                    Text("Bx4A is approaching your stop. This is not your bus. There are two buses ahead of the Bx4.")
                        .frame(width: 350, height: 100)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color("Color2"))
                        .cornerRadius(20)
                    
                    
                    
                }.frame(width: 375, height: 200, alignment: .top)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer().frame(height: 10)
                
//                Image("logo2")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 150).cornerRadius(20)
                
                Spacer().frame(height: 10)
                
                HStack {
                    
                    Button {
                        print("user requests to change bus")
                    } label: {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            
                            ZStack {
                                
                                Text("").frame(width: 175, height: 225)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                                
                                VStack {
                                    
                                    Spacer().frame(height: 10)
                                    
                                    Text("Change\nBus").frame(width: 175, height: 50)
                                        .background(Color("Color2"))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                    
                                    Spacer().frame(height: 20)
                                    
                                    Image("leftarrow")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                }
                            }
                        }
                    }
                    
                    Button {
                        print("user requests to change bus")
                    } label: {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            
                            ZStack {
                                
                                Text("").frame(width: 175, height: 225)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                                
                                Button(action: {
                                    Task{
                                        await stopMonitoringFetcher.fetchStopMonitoring(monitoringRef: busStop.code, lineRef: busRoute.lineRef.replacingOccurrences(of: " ", with: "%20"))
                                    }
                                }){
                                    VStack {
                                        Text("Update Bus \nStatus")
                                            .frame(width: 175, height: 50)
                                            .multilineTextAlignment(.center)
                                            .background(Color("Color2"))
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(20)
                                        
                                        Spacer().frame(height: 40)
                                        
                                        Image("refresh")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 75)
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            stopMonitoringFetcher.initData(busStop1: busStop, busRoute1: busRoute, stopMonitoringFetcher1: stopMonitoringFetcher)
            Task{
                await stopMonitoringFetcher.fetchStopMonitoring(monitoringRef: busStop.code, lineRef: busRoute.lineRef.replacingOccurrences(of: " ", with: "%20"))
                notifyLoop()
            }
        }
    }
}

struct BusTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        BusTrackingView(busStop: BusStopRoute.sampleData, busRoute: RouteDetail.sampleData)
    }
}


class NotificationManager: NSObject, UNUserNotificationCenterDelegate{
    //Singleton is requierd because of delegate
    static let shared: NotificationManager = NotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    private override init(){
        super.init()
        //This assigns the delegate
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() {
        print(#function)
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Access Granted!")
            } else {
                print("Access Not Granted")
            }
        }
    }
    
    func deleteNotifications(){
        print(#function)
        notificationCenter.removeAllPendingNotificationRequests()
    }
    ///This is just a reusable form of all the copy and paste you did in your buttons. If you have to copy and paste make it reusable.
    func scheduleTriggerNotification(title: String, body: String, categoryIdentifier: String, dateComponents : DateComponents, repeats: Bool) {
        print(#function)
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = categoryIdentifier
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    ///Prints to console schduled notifications
    func printNotifications(){
        print(#function)
        notificationCenter.getPendingNotificationRequests { request in
            for req in request{
                if req.trigger is UNCalendarNotificationTrigger{
                    print((req.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()?.description ?? "invalid next trigger date")
                }
            }
        }
    }
    //MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.banner)
    }
}
