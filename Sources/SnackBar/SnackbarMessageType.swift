//
//  SnackbarMessageType.swift
//
//  Created by Jason S. Armstrong on 2/1/24.
//

import SwiftUI

public enum SnackBarMessageType: CaseIterable, CustomStringConvertible, Hashable {
    case error, warning, info
    
    public var backgroundColor: Color {
        switch self {
        case .error: .red
        case .warning: .yellow
        case .info: .blue
        }
    }
    
    public var foregroundColor: Color {
        switch self {
        case .error: .white
        case .warning: .black
        case .info: .white
        }
    }
    
    public var icon: Image {
        switch self {
        case .error:
            Image(systemName: "exclamationmark.square.fill")
        case .warning:
            Image(systemName: "exclamationmark.triangle.fill")
        case .info:
            Image(systemName: "info.circle.fill")
        }
    }
    
    public var description: String {
        switch self {
        case .error:
            "ERROR"
        case .warning:
            "WARNING"
        case .info:
            "INFO"
        }
    }
}
