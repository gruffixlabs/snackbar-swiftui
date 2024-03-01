//
//  SnackBarMessageView.swift
//
//  Created by Jason S. Armstrong on 1/20/24.
//

import SwiftUI

public struct SnackBarMessageView: View {
    @Environment(\.snackbar) private var snackBar
    
    private let message: SnackBarMessage
    
    @GestureState private var offset: CGSize = .zero
    @State private var size: CGSize = .zero
    
    private var isTopMessage: Bool {
        snackBar.messages.first?.id == message.id
    }
    
    init(message: SnackBarMessage) {
        self.message = message
    }
    
    public var body: some View {
        HStack {
            message.type.icon.resizable().scaledToFit().frame(width: 24, height: 24)
            Text(message.text)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            snackBar.cancelRemoval(message)
        }
        .padding(.horizontal)
        .foregroundStyle(message.type.foregroundColor)
        .padding(.vertical)
        .frame(idealWidth: 325, maxWidth: 325)
        .background(message.type.backgroundColor.gradient, in: .rect(cornerRadius: 14))
        .clipShape(.rect(cornerRadius: 14))
        .offset(offset)
        .gesture(DragGesture()
            .updating($offset) { value, state, _ in
                state = value.translation
                snackBar.cancelRemoval(message)
            }
            .onEnded({ value in
                if value.translation.height > size.height * 0.25 || abs(value.translation.width) > size.width * 0.33 {
                    snackBar.remove(message)
                }
            }))
        .overlay {
            GeometryReader { proxy in
                Color.clear.onAppear {
                    size = proxy.size
                }
            }
        }
        .onAppear {
            scheduleRemovalIfNecessary(isFirst: isTopMessage)
        }
        .onChange(of: isTopMessage) { isFirst in
            scheduleRemovalIfNecessary(isFirst: isFirst)
        }
    }
    
    private func scheduleRemovalIfNecessary(isFirst: Bool) {
        if isFirst && message.dismissAfterSeconds > 0 {
            snackBar.scheduleRemoval(message)
        }
    }
}

