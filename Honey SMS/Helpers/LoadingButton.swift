//
//  ActivityIndicator.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 05/02/21.
//

import Foundation
import UIKit


class LoadingButton: UIButton {

    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!

    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: UIControl.State.normal)

        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        self.setTitle(originalButtonText, for: UIControl.State.normal)
        activityIndicator.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }

}
