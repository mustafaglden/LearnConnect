//
//  CourseListViewModel.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//


import CoreData

final class CourseListViewModel {
    private let context = CoreDataStack.shared.context
    
    var onFeedbackSaved: (() -> Void)?
    
    func fetchCourse() -> [Course] {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch courses \(error.localizedDescription)")
            return []
        }
    }
    
    func isUserEnrolled(in course: Course) -> Bool {
        guard let user = Session.user else { return false }
        let fetchRequest: NSFetchRequest<Enrollment> = Enrollment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@ AND course == %@", user, course)
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Failed to check enrollment status: \(error.localizedDescription)")
            return false
        }
    }
    
    func manageEnrollment(course: Course, isEnrolled: Bool, completion: @escaping () -> Void) {
        guard let user = Session.user else {
            return
        }
        let fetchRequest: NSFetchRequest<Enrollment> = Enrollment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@ AND course == %@", user, course)
        do {
            let results = try context.fetch(fetchRequest)
            if isEnrolled {
                if results.isEmpty {
                    let enrollment = Enrollment(context: context)
                    enrollment.user = user
                    enrollment.course = course
                    enrollment.videoProgress = 0.0
                    user.addToEnrollments(enrollment)
                    course.addToEnrollments(enrollment)
                    print("\(user.email) enrolled in \(course.title).")
                } else {
                    print("\(user.email) is already enrolled in \(course.title).")
                }
            } else {
                if let enrollment = results.first {
                    context.delete(enrollment)
                    print("\(user.email) unenrolled from \(course.title).")
                }
            }
            CoreDataStack.shared.saveContext()
            completion()
        } catch {
            print("Failed to manage enrollment: \(error.localizedDescription)")
        }
    }
    
    func toggleFavorite(course: Course, completion: @escaping (Bool) -> Void) {
        guard let user = Session.user else {
            completion(false)
            return
        }
        if user.favoriteCourses?.contains(course) == true {
            user.removeFromFavoriteCourses(course)
        } else {
            user.addToFavoriteCourses(course)
        }
        
        do {
            try CoreDataStack.shared.context.save()
            completion(true)
        } catch {
            print("Failed to toggle favorite: \(error.localizedDescription)")
            completion(false)
        }
    }

    func isFavorite(course: Course) -> Bool {
        guard let user = Session.user else { return false }
        return user.favoriteCourses?.contains(course) ?? false
    }
    
    func submitFeedback(for course: Course, rating: Int, feedback: String) {
        guard let user = Session.user else {
            return
        }
        
        let feedbackEntity = Feedback(context: context)
        feedbackEntity.rating = Int16(rating)
        feedbackEntity.feedback = feedback
        feedbackEntity.course = course
        feedbackEntity.user = user
        
        user.addToFeedbacks(feedbackEntity)
        course.addToFeedbacks(feedbackEntity)
        
        
        CoreDataStack.shared.saveContext()
        onFeedbackSaved?()
    }
}
