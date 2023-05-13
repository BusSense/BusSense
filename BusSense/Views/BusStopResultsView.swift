//
//  BusStopResultsView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/22/23.
//

import SwiftUI

struct BusStopResultsView: View {
    @ObservedObject var busStopRoutes: BusStopRoutesBuilder
    
    var body: some View {
        
               
        NavigationView {
            
            ZStack {
                
                Color("Color1").ignoresSafeArea()
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 20) {
                        VStack {
                            ForEach(busStopRoutes.busStopRoutes, id: \.id) { stop in
                                Text("Bus Stop Name:\n\(stop.name)")
                                    .frame(width: 350, height: 75)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                                    .background(Color("Color1"))
                                    .cornerRadius(10)
                                                                
                                ForEach(stop.routes, id: \.lineRef) { route in
                                    
                                    Button (action: {
                                        print(route.lineNameAndDestinationName)
                                    }, label: {
                                        NavigationLink(destination: BusTrackingView(busStop: stop, busRoute: route).navigationBarBackButtonHidden(true)) {
                                            Text("\(route.lineNameAndDestinationName)").frame(width: 300, height: 35, alignment: .leading)
                                                .padding(10)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.black)
                                                .background(Color("Color1"))
                                                .cornerRadius(10)
                                        }
                                    })
                                }.onAppear() {
                                    print(busStopRoutes.busStopRoutes)
                                }
                            }
                        }
                        .frame(width: 375, height: 700, alignment: .center)
                        .background(Color("Color2"))
                        .cornerRadius(20)
                    }
                }
            }
        }
        
        
                    
        // old code
//        NavigationView{
//            ZStack {
//                
//                Color("Color1").ignoresSafeArea()
//                
//                VStack {
//                    
//                    Image("logo")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                    
//                    Spacer()
//                    
//                    if locationManager.userLocation == nil {
//                        Text("Current Bus Stop:\nAMSTERDAM AV/W 131 ST (NE)")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(Color.white)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .background(Color("Color2"))
//                            .cornerRadius(20)
//                            .onAppear() {
//                                LocationManager.shared.requestLocation()
//                            }
//                    } else if let location = locationManager.userLocation {
//                        Text("Current Bus Stop:\n\(location.coordinate.longitude), \(location.coordinate.latitude)")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(Color.white)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .background(Color("Color2"))
//                            .cornerRadius(20)
//                    }
//                    
//                    Text("Select Buses:")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    // TODO: - Display JSON data
//                    //                    List {
//                    //                        for (busNumber, routeDescription) in sampleBusData {
//                    //                            Button {
//                    //                                print("\(busNumber)")
//                    //                            } label: {
//                    //                                NavigationLink(destination: BusConfimationView()) {
//                    //                                    Text("\(busNumber) - \(routeDescription)")
//                    //                                        .font(.title)
//                    //                                        .fontWeight(.bold)
//                    //                                        .foregroundColor(Color.white)
//                    //                                        .multilineTextAlignment(.center)
//                    //                                        .padding()
//                    //                                        .background(Color("Color2"))
//                    //                                        .cornerRadius(20)
//                    //                                }
//                    //                            }
//                    //                        }
//                    //                    }
//                    //                    .padding()
//                    
//                    Button {
//                        print("M11")
//                    } label: {
//                        NavigationLink(destination: BusConfimationView()) {
//                            Text("M11 - Riverbank Park & Harlem")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.white)
//                                .multilineTextAlignment(.center)
//                                .padding()
//                                .background(Color("Color2"))
//                                .cornerRadius(20)
//                        }
//                    }
//                    
//                    Button {
//                        print("M100")
//                    } label: {
//                        NavigationLink(destination: BusConfimationView()) {
//                            Text("M100 - Inwood")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.white)
//                                .multilineTextAlignment(.center)
//                                .padding()
//                                .background(Color("Color2"))
//                                .cornerRadius(20)
//                        }
//                    }
//                    
//                    Button {
//                        print("M101")
//                    } label: {
//                        NavigationLink(destination: BusConfimationView()) {
//                            Text("M100 - Fort George")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.white)
//                                .multilineTextAlignment(.center)
//                                .padding()
//                                .background(Color("Color2"))
//                                .cornerRadius(20)
//                        }
//                    }
//                }
//            }
//        }
    }
}

struct BusStopResultsView_Previews: PreviewProvider {
    static var previews: some View {
        BusStopResultsView(busStopRoutes: BusStopRoutesBuilder())
    }
}
