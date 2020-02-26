//
//  CoViTableViewCell.swift
//  ViperArchitecture
//
//  Created by Jorge Guilabert Ibáñez on 12/02/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit

/**
 CoVi base table view cell.
 */
open class CoViTableViewCell: UITableViewCell {

    // MARK: - Properties

    /// Background color when the user keeps his finger on the cell.
    public var highlightColor: UIColor?
    /// Background color when the user selects a row.
    public var selectedBackgroundColor: UIColor?
    /// Tint color of disclosure indicator.
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
