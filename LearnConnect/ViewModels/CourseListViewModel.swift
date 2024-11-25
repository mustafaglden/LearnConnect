//
//  CourseListViewModel.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//


import CoreData

class CourseListViewModel {
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
    func manageEnrollment(course: Course, isEnrolled: Bool) {
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
                if var enrolledUsers = course.enrolledUsers as? Set<User> {
                    enrolledUsers.insert(user)
                    course.enrolledUsers = enrolledUsers as NSSet
                }
            } else {
                if let enrollment = results.first {
                    context.delete(enrollment)
                    print("\(user.email) unenrolled from \(course.title).")
                }
                if var enrolledUsers = course.enrolledUsers as? Set<User> {
                    enrolledUsers.remove(user)
                    course.enrolledUsers = enrolledUsers as NSSet
                }
            }
            saveContext()
        } catch {
            print("Failed to manage enrollment: \(error.localizedDescription)")
        }
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
        
        
        saveContext()
        onFeedbackSaved?()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context \(error.localizedDescription)")
        }
    }
}
