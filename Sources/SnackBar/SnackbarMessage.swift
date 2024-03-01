//
//  SnackbarMessage.swift
//
//  Created by Jason S. Armstrong on 2/1/24.
//

import Foundation

public struct SnackBarMessage: Identifiable, Sendable, Equatable {
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
}
