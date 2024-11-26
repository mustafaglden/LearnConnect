//
//  VideoPlayerViewModel.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import CoreData

final class VideoPlayerViewModel {
    private let context = CoreDataStack.shared.context
    
    func saveVideoProgress(course: Course, user: User, progress: Float) {
        let fetchRequest: NSFetchRequest<Enrollment> = Enrollment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@ AND course == %@", user, course)
        
        do {
            if let enrollment = try CoreDataStack.shared.context.fetch(fetchRequest).first {
                enrollment.videoProgress = progress // Update progress
                CoreDataStack.shared.saveContext()
                print("Progress saved to Core Data: \(progress * 100)%")
            } else {
                print("Enrollment not found for user: \(user.email) in course: \(course.title)")
            }
        } catch {
            print("Failed to save video progress: \(error.localizedDescription)")
        }
    }
    
    func getVideoProgress(for user: User, in course: Course) -> Float {
        let fetchRequest: NSFetchRequest<Enrollment> = Enrollment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@ AND course == %@", user, course)
        do {
            if let enrollment = try CoreDataStack.shared.context.fetch(fetchRequest).first {
                print("Fetched progress from Core Data: \(enrollment.videoProgress * 100)%")
                return enrollment.videoProgress
            } else {
                print("Enrollment not found for user: \(user.email) in course: \(course.title)")
                return 0.0
            }
        } catch {
            print("Failed to fetch video progress: \(error.localizedDescription)")
            return 0.0
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context \(error.localizedDescription)")
        }
    }
}
