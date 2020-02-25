//
//  CoViTableViewCell.swift
//  ViperArchitecture
//
//  Created by Jorge Guilabert Ibáñez on 12/02/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit

open class CoViTableViewCell: UITableViewCell {

    // MARK: - Properties

    public var highlightColor: UIColor?
    public var selectedBackgroundColor: UIColor?
    public var disclosureIndicatorColor: UIColor?

    // MARK: - Lifecycle

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if let selectedBackgroundColor = selectedBackgroundColor {
            if selected {
                let selectedBackgroundView = UIView()
                selectedBackgroundView.backgroundColor = selectedBackgroundColor

                self.selectedBackgroundView = selectedBackgroundView
            } else {
                self.selectedBackgroundView = nil
            }
        }
    }

}
