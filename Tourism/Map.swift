//
//  Map.swift
//  Tourism
//
//  Created by AnonymFromInternet on 19.09.21.
//

import SwiftUI

import MapKit

//MARK:- Integration MApKit with SwiftUI with Coordinator class

struct Map: UIViewRepresentable {
    
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool

    
    var annotations: [MKPointAnnotation]
    
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("Updating")
        if annotations.count != uiView.annotations.count {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: Map
        
        init(_ parent: Map) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Identifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
                }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placeMark = view.annotation as? MKPointAnnotation else { return }
            
            parent.selectedPlace = placeMark
            parent.showingPlaceDetails = true
        }
        
    }
    
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        //MARK:- Входящий параметр centerCoordinate: при инициализации экземпляра Map используется из расширения
        Map(selectedPlace: .constant(MKPointAnnotation.example), showingPlaceDetails: .constant(false), annotations: [MKPointAnnotation.example], centerCoordinate: .constant(MKPointAnnotation.example.coordinate))
    }
}

extension MKPointAnnotation {
    
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = ""
        annotation.coordinate = CLLocationCoordinate2D(latitude: 50, longitude: -0.14)
        return annotation
    }
}
