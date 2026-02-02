//
//  UIViewController+Extension.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 2/2/26.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, onOK: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in onOK?() })
        present(alert, animated: true)
    }
}
