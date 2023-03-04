//
//  Bus.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/18/23.
//  Bus Class 

import Foundation

var bus_id = 1

class Bus: ObservableObject {
    let id: Int
    let bound1: String
    let bound2: String
    let borough: String
    let number: Int
    
    init() {
        self.id = bus_id
        self.bound1 = "X"
        self.bound2 = "X"
        self.borough = "X"
        self.number = 0
    
        bus_id += 1
    }
    
    init(bound1: String, bound2: String, borough: String, number: Int) {
        self.id = bus_id
        self.bound1 = bound1
        self.bound2 = bound2
        self.borough = borough
        self.number = number
    
        bus_id += 1
    }
}

// chosenBus object to represent bus and direction bound
// chosen by user
class ChosenBus: ObservableObject {
    let id: Int
    let bound: String
    let borough: String
    let number: Int
    
    init() {
        self.id = bus_id
        self.bound = "X"
        self.borough = "X"
        self.number = 0
    
        bus_id += 1
    }
    
    init(bound: String, borough: String, number: Int) {
        self.id = bus_id
        self.bound = bound
        self.borough = borough
        self.number = number
    
        bus_id += 1
    }
}
