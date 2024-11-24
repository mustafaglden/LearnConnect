//
//  UIViewControllerExtension.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import UIKit

extension UIViewController {
    func showAlert(
        _ message: String,
        title: String = "error_text".localized,
        actionButtonTitle: String = "ok_button".localized,
        actionButtonHandler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionButtonTitle, style: .default) { _ in
            actionButtonHandler?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
