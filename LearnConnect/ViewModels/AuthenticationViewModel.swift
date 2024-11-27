//
//  AuthenticationViewModel.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import CoreData

final class AuthenticationViewModel {
    private let context = CoreDataStack.shared.context
    
    func registerUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let user = User(context: context)
        user.email = email
        user.username = email
        user.password = password
        
        do {
            try context.save()
            completion(true, nil) // Success
        } catch {
            print("Failed to register user: \(error.localizedDescription)")
            completion(false, "register_failed".localized +  "\(error.localizedDescription)")
            }
        }
        
    func loginUser(email: String, password: String) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let users = try context.fetch(fetchRequest)
            if !users.isEmpty {
                Session.user = users.first
                return true
            } else {
                return false
            }
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
            return false
        }
    }
}
