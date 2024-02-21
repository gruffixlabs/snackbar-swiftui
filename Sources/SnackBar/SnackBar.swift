//
//  SnackBarViewModel.swift
//
//  Created by Jason S. Armstrong on 1/20/24.
//

import SwiftUI

/**
 To use add a .snackbar() modifier to a root view. e.g. on a NavigationStack().
 
 To display messages, add an @Environment(\.snackbar) private var snackbar to the view where a message may be generated from. Call one of the various show/error/info/warning functions.
 
 Passing a dismissAfterSeconds of zero keeps the message displayed until a user flicks down, left, or right. Flicking it up keeps it on the screen until the user flicks it off the screen.
 */
@Observable public class SnackBar {
    public var messages = [SnackBarMessage]()
    
    public init() {}
    
    public func show(_ text: String, type: SnackBarMessageType = .error, dismissAterSeconds: TimeInterval = 5) {
        withAnimation {
            messages.append(SnackBarMessage(text: text, type: type, dismissAfterSeconds: dismissAterSeconds))
        }
    }
    
    public func remove(_ message: SnackBarMessage) {
        withAnimation {
            messages.removeAll(where: {$0.id == message.id})
        }
    }
    
    func scheduleRemoval(_ message: SnackBarMessage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + message.dismissAfterSeconds) {
            if message.dismissAfterSeconds > 0 {
                self.remove(message)
            }
        }
    }
    
    public func error(_ text: String, dismissAterSeconds: TimeInterval = 5) {
        show(text, type: .error, dismissAterSeconds: dismissAterSeconds)
    }
    
    public func error(_ error: Error, dismissAterSeconds: TimeInterval = 5) {
        show(error.localizedDescription, type: .error, dismissAterSeconds: dismissAterSeconds)
    }
    
    public func info(_ text: String, dismissAterSeconds: TimeInterval = 5) {
        show(text, type: .info, dismissAterSeconds: dismissAterSeconds)
    }
    
    public func warning(_ text: String, dismissAterSeconds: TimeInterval = 5) {
        show(text, type: .warning, dismissAterSeconds: dismissAterSeconds)
    }
}

#Preview {
    struct Shim: View {
        @Environment(\.snackbar) private var snackBar
        
        @State private var text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam sodales lacus at volutpat faucibus."
        @State private var type = SnackBarMessageType.error
        @State private var dismissAfter: TimeInterval = 5
        
        var body: some View {
            Form {
                Section("Message") {
                    TextField("Text", text: $text)
                    
                    Picker("Message Type", selection: $type) {
                        ForEach(SnackBarMessageType.allCases, id: \.self) { type in
                            Text(type.description).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    VStack(alignment: .trailing) {
                        Stepper("Dismiss After", value: $dismissAfter, step: 1.0)
                        Text("\(dismissAfter.formatted()) seconds")
                    }
                }
                
                HStack {
                    Spacer()
                    Button("Show Message") {
                        snackBar.show(text, type: type, dismissAterSeconds: dismissAfter)
                    }
                    Spacer()
                }
            }
        }
    }
    
    return NavigationStack {
        NavigationStack {
            Shim()
        }
        .snackbar()
    }
}
