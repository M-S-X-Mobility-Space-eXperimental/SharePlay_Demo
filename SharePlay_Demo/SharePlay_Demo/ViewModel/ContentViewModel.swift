////
////  ContentViewModel.swift
////  SharePlay_Demo
////
////  Created by ChuanZhen Tu on 3/13/25.
////
//import Foundation
//import GroupActivities
//import UIKit
//
//class ContentViewModel: ObservableObject {
//    
//    
//    
//    func registerGroupActivity() {
//        // Create the activity
//        let activity = PlayTogether()
//
//        // Register the activity on the item provider
//        let itemProvider = NSItemProvider()
//        itemProvider.registerGroupActivity(activity)
//
//        // Create the activity items configuration
//        let configuration = UIActivityItemsConfiguration(itemProviders: [itemProvider])
//
//        // Provide the metadata for the group activity
//        configuration.metadataProvider = { key in
//            guard key == .linkPresentationMetadata else { return Void.self }
//            return PlayTogether().metadata
//        }
//        
//        UIApplication.shared
//                    .connectedScenes
//                    .compactMap { $0 as? UIWindowScene }
//                    .first?
//                    .windows
//                    .first?
//                    .rootViewController?
//                    .activityItemsConfiguration = configuration
//    }
//}
