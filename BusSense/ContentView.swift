//
//  ContentView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var busStopRoutes = BusStopRoutesBuilder()
//    @StateObject var busStopRoutes = MTA()
    let speechSynthesizer = SpeechSynthesizer()
    
    var body: some View {
        // TODO: - Check camera permission here too
        if locationManager.permission == .denied {
            DeniedPermissionsView()
        } else if locationManager.permission == .notDetermined {
            DefaultView().onAppear() {
                locationManager.requestLocation()
            }
        } else if let location = locationManager.userLocation {
            if !busStopRoutes.hasFetchCompleted || busStopRoutes.isLoading {
                LoadingView().onAppear() {
                    print(location.coordinate.latitude, location.coordinate.longitude)
                    busStopRoutes.buildBusStopRoutes(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                }
            } else if busStopRoutes.busStopRoutes.count != 0 {
                BusStopResultsView(busStopRoutes: busStopRoutes)
                    .onAppear() {
                        print("BusStopResultsView()")
                        print(busStopRoutes.busStopRoutes)
//                        speechSynthesizer.speak("hello there")
                        print("bus stop results view")
                        for stop in busStopRoutes.busStopRoutes {
                            print(stop.name)
                        }
                    }
            } else {
                NoNearbyView().onAppear() {
                    print("no nearby bus stops view")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
