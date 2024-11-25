//
//  DummyDataLoader.swift
//  LearnConnect
//
//  Created by Mustafa on 23.11.2024.
//

import CoreData

class DummyDataLoader {
    static let shared = DummyDataLoader()
    private let context = CoreDataStack.shared.context
    
    private init() {}
    
    func saveDummyVideosToCoreData() {
        let dummyVideoNames = ["sample1", "sample2", "sample3"]
        
        for videoName in dummyVideoNames {
            // Check if the video already exists in Core Data
            let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "fileName == %@", videoName)
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.isEmpty {
                    let course = Course(context: context)
                    course.title = videoName // Assign the video name as the course title for simplicity
                    course.fileName = videoName
                    course.desc = "Dummy description for \(videoName)"
                }
            } catch {
                print("Error fetching existing video data: \(error)")
            }
        }
        
        saveContext()
        print("Dummy videos saved to Core Data.")
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
