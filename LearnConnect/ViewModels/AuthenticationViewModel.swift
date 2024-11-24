//
//  AuthenticationViewModel.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import CoreData

class AuthenticationViewModel {
    private let context = CoreDataStack.shared.context
    
    func registerUser(email: String, password: String) -> Bool {
        let user = User(context: context)
        user.email = email
        user.password = password
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to register user: \(error.localizedDescription)")
            return false
        }
    }
        
    func loginUser(email: String, password: String) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let users = try context.fetch(fetchRequest)
            return !users.isEmpty
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
            return false
        }
    }
}
