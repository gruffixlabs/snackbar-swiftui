//
//  SnackBarViewModel.swift
//
//  Created by Jason S. Armstrong on 1/20/24.
//

import SwiftUI
import OSLog

private var logger = Logger(OSLog(subsystem: "com.gruffix.snackbar", category: "snackbar"))

/**
 To use add a .snackbar() modifier to a root view. e.g. on a NavigationStack().
 
 To display messages, add an @Environment(\.snackbar) private var snackbar to the view where a message may be generated from. Call one of the various show/error/info/warning functions.
 
 Passing a dismissAfterSeconds of zero keeps the message displayed until a user flicks down, left, or right. Flicking it up keeps it on the screen until the user flicks it off the screen.
 */
public class SnackBar: ObservableObject {
    @Published public var messages = [SnackBarMessage]()
    
    private var tasks = [SnackBarMessage.ID : Task<Void, Never>]()
    
    public init() {}
    
    deinit {
        tasks.values.forEach { 
            $0.cancel()
        }
    }
    
    public func show(_ text: String, type: SnackBarMessageType = .error, dismissAterSeconds: TimeInterval = 5) {
        withAnimation {
            messages.append(SnackBarMessage(text: text, type: type, dismissAfterSeconds: dismissAterSeconds))
        }
    }
    
    public func remove(_ message: SnackBarMessage) {
        withAnimation {
            messages.removeAll(where: {$0.id == message.id})
        }
        cancelRemovalTask(message.id)
    }
    
    private func cancelRemovalTask(_ messageId: SnackBarMessage.ID) {
        if let task = tasks[messageId] {
            task.cancel()
            tasks[messageId] = nil
        }
    }
    
    public func cancelRemoval(_ message: SnackBarMessage) {
        cancelRemovalTask(message.id)
    }
    
    func scheduleRemoval(_ message: SnackBarMessage) {
        tasks[message.id] = Task {
            do {
                try await Task.sleep(nanoseconds: UInt64(message.dismissAfterSeconds * 1E9))
                self.remove(message)
            } catch is CancellationError {
            } catch {
                logger.error("An error occurred while waiting for the snackbar message to be automatically removed: \(error)")
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
    
    return NavigationView {
        Shim()
    }
    .snackbar(SnackBar())
}
