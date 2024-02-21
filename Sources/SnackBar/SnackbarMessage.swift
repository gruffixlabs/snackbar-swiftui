//
//  SnackbarMessage.swift
//
//  Created by Jason S. Armstrong on 2/1/24.
//

import Foundation

@Observable public class SnackBarMessage: Identifiable {
    public var id: String
    public var text: String
    public var type: SnackBarMessageType
    public var dismissAfterSeconds: TimeInterval
    
    public init(id: String = UUID().uuidString, text: String, type: SnackBarMessageType, dismissAfterSeconds: TimeInterval) {
        self.id = id
        self.text = text
        self.type = type
        self.dismissAfterSeconds = dismissAfterSeconds
    }
    
    public func cancelDismissal() {
        dismissAfterSeconds = 0
    }
}
