//
//  SnackBarModifier.swift
//
//  Created by Jason S. Armstrong on 1/20/24.
//

import SwiftUI

struct SnackBarModifier: ViewModifier {
    var viewModel: SnackBar
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            SnackBarContainer()
        }
        .environment(\.snackbar, viewModel)
    }
}

extension View {
    public func snackbar(_ viewModel: SnackBar = .init()) -> some View {
        self.modifier(SnackBarModifier(viewModel: viewModel))
    }
}

fileprivate struct SnackBarEnvironmentKey: EnvironmentKey {
    static var defaultValue: SnackBar { SnackBar() }
}

extension EnvironmentValues {
    public var snackbar: SnackBar {
        get { self[SnackBarEnvironmentKey.self] }
        set { self[SnackBarEnvironmentKey.self] = newValue }
    }
}
