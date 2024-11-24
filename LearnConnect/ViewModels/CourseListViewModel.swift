//
//  CourseListViewModel.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//


import CoreData

class CourseListViewModel {
    private let context = CoreDataStack.shared.context
    
    func fetchCourse() -> [Course] {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch courses \(error.localizedDescription)")
            return []
        }
    }
    
    func enrollInCourse(course: Course, isEnrolled: Bool) {
        course.isEnrolled = isEnrolled
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context \(error.localizedDescription)")
        }
    }
}
