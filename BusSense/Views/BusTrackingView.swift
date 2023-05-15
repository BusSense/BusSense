//
//  BusConfimationView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/6/23.
//

import SwiftUI
import AVFAudio

struct BusTrackingView: View {
    
    var busStop: BusStopRoute
    var busRoute: RouteDetail
    @EnvironmentObject var speechSynthesizer: SpeechSynthesizer
    @StateObject var trackedStop: TrackedStopFetcher = TrackedStopFetcher()
    
    var body: some View {
        
//        let proximityData = trackedStop.getProximityAway()
//        let milesData = trackedStop.getMilesAway()
//        let stopsData = trackedStop.getStopsAway()
//        let timeData = trackedStop.getTimeAway()
        
        ZStack {
            
            Color("Color1").ignoresSafeArea()
            
            if !trackedStop.hasFetchCompleted || trackedStop.isLoading {
                LoadingView().onAppear() {
                    trackedStop.fetchStopMonitoring(monitoringRef: busStop.code, publishedLineName: busRoute.publishedLineName, destinationName: busRoute.destinationName)
                }
            } else {
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
                        
                        
                        
                        if trackedStop.proximityMsg == "No vehicles detected at this time. Please try again later." {
                            Text("\(busRoute.lineNameAndDestinationName)" + "\n\nApproaching")
                                .frame(width: 350, height: 200)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color("Color2"))
                                .cornerRadius(20)
    //                            .onAppear() {
    //                                speechSynthesizer.speak("currently tracking")
    //                                speechSynthesizer.speak("\(busRoute.lineNameAndDestinationName)" + "\n\n\(proximityData)")
    //                                speechSynthesizer.speak("NOTICE:")
    //                                speechSynthesizer.speak("Bx4A is approaching your stop. This is not your bus. There are two buses ahead of the Bx4.")
    //                            }
                        } else if trackedStop.proximityMsg == "approaching" {
                            Text("\(busRoute.lineNameAndDestinationName)" + "\n\n\(trackedStop.proximityMsg)")
                                .frame(width: 350, height: 200)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color("Color2"))
                                .cornerRadius(20)
    //                            .onAppear() {
    //                                speechSynthesizer.speak("currently tracking")
    //                                speechSynthesizer.speak("\(busRoute.lineNameAndDestinationName)" + "\n\n\(proximityData)")
    //                                speechSynthesizer.speak("NOTICE:")
    //                                speechSynthesizer.speak("Bx4A is approaching your stop. This is not your bus. There are two buses ahead of the Bx4.")
    //                            }
                        } else {
                            Text("\(busRoute.lineNameAndDestinationName)" + "\n\n\(trackedStop.milesAway) miles away\n\(trackedStop.stopsAway) stops away\n\(trackedStop.timeAway)")
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
                        
                        Text("BUSES AHEAD:")
                            .frame(width: 350, height: 30)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .background(Color("Color1"))
                            .cornerRadius(10)

                        Text(trackedStop.busesAhead! + " buses ahead of \(busRoute.publishedLineName)")
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
                            speechSynthesizer.toggleVoice()
                            if !speechSynthesizer.voiceEnabled {
                                if speechSynthesizer.synthesizer.isSpeaking {
                                    speechSynthesizer.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                                }
                            }
                        } label: {
                            toggleVoiceView()
                        }
                    }
                }
            }
        }
//        .onAppear {
//            trackedStop.fetchStopMonitoring(monitoringRef: busStop.code, lineRef: busRoute.lineRef.replacingOccurrences(of: " ", with: "%20"))
//        }
    }
}

struct BusTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        BusTrackingView(busStop: BusStopRoute.sampleData, busRoute: RouteDetail.sampleData)
    }
}
