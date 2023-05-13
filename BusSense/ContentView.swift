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
    
    var body: some View {
        // TODO: - Check camera permission here too
        if locationManager.permission == .denied {
            DeniedPermissionsView()
        } else if locationManager.permission == .notDetermined {
            DefaultView().onAppear() {
                locationManager.requestLocation()
            }
        } else if let location = locationManager.userLocation {
            if !busStopRoutes.hasFetchedCompleted || busStopRoutes.isLoading {
                LoadingView().onAppear() {
                    print(location.coordinate.latitude, location.coordinate.longitude)
//                    busStopRoutes.buildBusStopRoutesOld(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                    busStopRoutes.buildBusStopRoutes(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                }
            } else {
                BusStopResultsView(busStopRoutes: busStopRoutes).onAppear() {
//                    print("BusStopResultsView()")
//                    print(busStopRoutes.busStopRoutes)
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
