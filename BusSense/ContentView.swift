//
//  ContentView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//



import SwiftUI

struct ContentView: View {

    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationView{
            ZStack {
                
                Color("Color1").ignoresSafeArea()
                
                VStack {
                    
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Spacer()
                    
                    if locationManager.userLocation == nil {
                        Text("Current Bus Stop:\nAMSTERDAM AV/W 131 ST (NE)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                            .onAppear() {
                                LocationManager.shared.requestLocation()
                            }
                    } else if let location = locationManager.userLocation {
                        Text("Current Bus Stop:\n\(location.coordinate.longitude), \(location.coordinate.latitude)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                    }
                    
                    Text("Select Buses:")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // TODO: - Display JSON data
                    //                    List {
                    //                        for (busNumber, routeDescription) in sampleBusData {
                    //                            Button {
                    //                                print("\(busNumber)")
                    //                            } label: {
                    //                                NavigationLink(destination: BusConfimationView()) {
                    //                                    Text("\(busNumber) - \(routeDescription)")
                    //                                        .font(.title)
                    //                                        .fontWeight(.bold)
                    //                                        .foregroundColor(Color.white)
                    //                                        .multilineTextAlignment(.center)
                    //                                        .padding()
                    //                                        .background(Color("Color2"))
                    //                                        .cornerRadius(20)
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                    //                    .padding()
                    
                    Button {
                        print("M11")
                    } label: {
                        NavigationLink(destination: BusConfimationView()) {
                            Text("M11 - Riverbank Park & Harlem")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color("Color2"))
                                .cornerRadius(20)
                        }
                    }
                    
                    Button {
                        print("M100")
                    } label: {
                        NavigationLink(destination: BusConfimationView()) {
                            Text("M100 - Inwood")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color("Color2"))
                                .cornerRadius(20)
                        }
                    }
                    
                    Button {
                        print("M101")
                    } label: {
                        NavigationLink(destination: BusConfimationView()) {
                            Text("M100 - Fort George")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color("Color2"))
                                .cornerRadius(20)
                        }
                    }
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
