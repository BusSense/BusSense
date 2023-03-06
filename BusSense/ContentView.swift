//
//  ContentView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//  Home Page

import SwiftUI
import Foundation

// turn Substring() object into Int() object
func parse(_ s: String) -> Int {
    return Int(s, radix: 10)!
}

// return true if string contains number
func stringHasNumber(_ string:String) -> Bool {
    for character in string{
        if character.isNumber{
            return true
        }
    }
    return false
}

// return the string of digits in an alphanumeric string
func extractDigits(_ string:String) -> String {
    var stringToInt = ""
    for letter in string.unicodeScalars {
        if 48...57 ~= letter.value {
            stringToInt.append(String(letter))
        } else {
            break
        }
    }
    return stringToInt
}

// return true if string contains any element from an array
extension String {
    func contains(_ strings: [String]) -> Bool {
        strings.contains { contains($0) }
    }
}

// Use user input from mic to find bus information from "routes.txt"
// and return Bus() object with that bus information
func findBus(userInput: String) -> Bus {
        
    // read from txt file
    let fileURL = Bundle.main.url(forResource: "routes", withExtension: "txt")!
    let contents = try! String(contentsOf: fileURL, encoding: String.Encoding.utf8)
    
    // Bus instance to return
    var bus = Bus()
    
    // check which borough the user input contains & extract it
    let boroughOptions = ["BX","B","M","Q","S"]
    let containsBorough = userInput.contains(boroughOptions)
    var userBorough = ""
    if containsBorough == true {
        if userInput.contains("BX") {
            userBorough = "BX"
        }
        else if userInput.contains("B") {
            userBorough = "B"
        }
        else if userInput.contains("M") {
            userBorough = "M"
        }
        else if userInput.contains("Q") {
            userBorough = "Q"
        }
        else if userInput.contains("S") {
            userBorough = "S"
        }
    }
    
    let newInput = userBorough + extractDigits(userInput)

//    let contents = try! String(contentsOfFile: path, encoding: .utf8)
    let lines = contents.components(separatedBy: "\n")
//    let lines = contents.split(separator:"\n")
    
    for line in lines {
        let arguments = line.split(separator:",")
        if String(arguments[0]) == newInput {
//            let bus_number = Int(String(arguments[4])) ?? 0
//            let bus_number = nf.number(from: String(arguments[4]))?.intValue ?? 0
            bus = Bus(bound1: String(arguments[1]), bound2: String(arguments[2]), borough: String(arguments[3]), number: String(arguments[4]))
            break
        }
    }
    return bus
}

struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var foundBus = Bus()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var choice = ""
    @State var tapCounter: Int = 0
    
    // alternate recording on/off every time button is tapped
    // return mic transcription as user's bus choice
    func buttonAction(tapCounter: Int) -> String {
        var busChoice = ""
        if tapCounter % 2 == 1 {
            speechRecognizer.reset()
            speechRecognizer.transcribe()
//            isRecording = true
        } else {
            speechRecognizer.stopTranscribing()
//            isRecording = false
            busChoice = speechRecognizer.transcript
        }
        return busChoice
    }
    
    // change mic color when recording
    func changeMicColor(tapCounter: Int) -> Color {
        var micColor = Color(.white)
        if tapCounter % 2 == 1 {
            micColor = Color("Color2")
        } else {
            micColor = Color(.white)
        }
        return micColor
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Color("Color1").ignoresSafeArea()
                
                VStack {
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Spacer()
                    
                    if locationManager.userLocation == nil {
                        Text("Current Bus Stop:\nADD GPS LOCATION")
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
                    }
                    else if let location = locationManager.userLocation {
                        Text("Current Bus Stop:\n\(location.coordinate.longitude), \(location.coordinate.latitude)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    Text("Which bus are you looking for?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color("Color2"))
                        .cornerRadius(20)
                    
                    Spacer()
                    
                    
                    Button {
                        tapCounter += 1
                        print("button pressed")
                        choice = buttonAction(tapCounter: tapCounter)
                        print(choice)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(changeMicColor(tapCounter: tapCounter))
                                .frame(width: 200, height: 200)
                            Image("mic")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }
                    }
                    
                    if (choice.contains("B") || choice.contains("BX") || choice.contains("M") || choice.contains("Q") || choice.contains("S")) && stringHasNumber(choice)==true {
                            Button {
                                print("GO")
                            } label: {
                                NavigationLink(destination: BusBoundSelectionView(bus: findBus(userInput: choice))) {
                                    Text("GO")
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
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            print("B")
                        } label: {
                            NavigationLink(destination: BusNumberSelectionView(bus: Bus(bound1: "X", bound2: "X", borough: "B", number: "0"))) {
                                Text("B")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .frame(width: 65, height: 65)
                                .background(Color("Color2"))
                                .cornerRadius(20)
                            }
                        }
                                            
                        Button {
                            print("BX")
                        } label: {
                            NavigationLink(destination: BusNumberSelectionView(bus: Bus(bound1: "X", bound2: "X", borough: "BX", number: "0"))) {
                                Text("BX")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 65, height: 65)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                            }
                        }
                                            
                        Button {
                            print("M")
                        } label: {
                            NavigationLink(destination: BusNumberSelectionView(bus: Bus(bound1: "X", bound2: "X", borough: "M", number: "0"))) {
                                Text("M")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 65, height: 65)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                            }
                        }
                                        
                        Button {
                            print("Q")
                        } label: {
                            NavigationLink(destination: BusNumberSelectionView(bus: Bus(bound1: "X", bound2: "X", borough: "Q", number: "0"))) {
                                Text("Q")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 65, height: 65)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                            }
                        }
                                            
                        Button {
                            print("S")
                        } label: {
                            NavigationLink(destination: BusNumberSelectionView(bus: Bus(bound1: "X", bound2: "X", borough: "S", number: "0"))) {
                                Text("S")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 65, height: 65)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
