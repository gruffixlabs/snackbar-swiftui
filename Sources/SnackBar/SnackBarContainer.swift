//
//  SnackBarContainer.swift
//
//  Created by Jason S. Armstrong on 2/1/24.
//

import SwiftUI

struct SnackBarContainer: View {
    @Environment(\.snackbar) private var snackBar
    
    func offset(for message: SnackBarMessage) -> CGSize {
        guard let index = snackBar.messages.firstIndex(where: {$0.id == message.id}), index > 0 else { return .zero }
        let j = min(index, 5) * 5
        return CGSize(width: j, height: j)
    }
    
    var body: some View {
        ZStack {
            ForEach(snackBar.messages.reversed()) { message in
                SnackBarMessageView(message: message)
                    .id(message.id)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .offset(offset(for: message))
            }
        }
    }
}
