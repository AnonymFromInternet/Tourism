//
//  ContentView.swift
//  Tourism
//
//  Created by AnonymFromInternet on 19.09.21.
//

import SwiftUI


import MapKit
import LocalAuthentication

struct ContentView: View {
    
    //MARK:- This properties are related with properties from struct Map
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var centerCoordinate = CLLocationCoordinate2D()
    //MARK:-
    
    
    @State private var locations = [CodableMKPointAnnotation]()
    
    
    @State private var showingEdit = false
    
    
    
    //MARK:- Property for Face- and TouchId
    @State private var isUnlocked = false
    //MARK:-
    
    //MARK:- Alert properties
    @State private var isAlert = false
    @State private var alertMessage = ""
    //MARK:-
    
    var body: some View {
        
        ZStack {
            if isUnlocked {
                
                
                Map(selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations, centerCoordinate: $centerCoordinate)
                    .edgesIgnoringSafeArea(.all)
                Circle()
                    .fill(Color.blue)
                    .opacity(0.36)
                    .frame(width: 36, height: 36)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            let newLocation = CodableMKPointAnnotation()
                            newLocation.coordinate = self.centerCoordinate
                            newLocation.title = "Location"
                            self.locations.append(newLocation)
                            self.selectedPlace = newLocation
                            self.showingEdit = true
                            
                        }, label: {
                            Image(systemName: "plus")
                            
                        })
                        .padding()
                        .background(Color.black.opacity(0.36))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                        
                        
                    }
                }
            } else {
                Button("Authentificate please") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .alert(isPresented: $isAlert, content: {
                    Alert(title: Text(alertMessage), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
                })
            }
        }
        .onAppear(perform: {
            loadData()
        })
        .alert(isPresented: $showingPlaceDetails, content: {
            Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Unknown"), primaryButton: .default(Text("Ok")), secondaryButton: .default(Text("Edit")) {
                self.showingEdit = true
            })
        })
        .sheet(isPresented: $showingEdit, onDismiss: saveData, content: {
            if self.selectedPlace != nil {
                Edit(placeMark: self.selectedPlace!)
            }
        })
        
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        
        let fileName = getDocumentDirectory().appendingPathComponent("SavedPlaces")
        
        do {
            let data = try Data(contentsOf: fileName)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data")
        }
    }
    
    
    
    func saveData() {
        do {
            let fileName = getDocumentDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authentificate yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {authentification, error in
                DispatchQueue.main.async {
                    if authentification {
                        self.isUnlocked = true
                    } else {
                        //error
                        self.isAlert = true
                        self.alertMessage = error?.localizedDescription ?? "Unknown error"
                    }
                }
                
            }
        } else {
            // no biometrics
            self.isAlert = true
            self.alertMessage = error?.localizedDescription ?? "Unknown error"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
