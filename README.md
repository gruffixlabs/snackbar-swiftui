# Snackbar

Provides a Snackbar-like notification at the bottom of the user's screen.

## Features
* Display errors, warnings, or informational messages with matching color coding
* Auto dismiss after a period of time
* Flick down, left, or right to dismiss
* Flick up or tap to keep on screen
* Automatically stacks messages; it won't take over the entire screen

## Installation
To use, with Swift Package Manager, add [https://github.com/gruffixlabs/snackbar-swiftui.git](https://github.com/gruffixlabs/snackbar-swiftui.git).

## Getting Started
```
import SnackBar

struct ContentView: View {
    @Environment(\.snackbar) private var snackbar
    
    var body: some View {
        VStack {
            Spacer()
            Button("Get Started") {
                Task {
                    do {
                        // Do something that throws an error.
                    } catch {
                        snackbar.error(error)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .snackbar()
}
```

In addition to throwing errors you can also display warnings and informational messages.

### Initializing and using within the same view
If you want to declare and use the snackbar within the same view do the following instead:

```
import SnackBar

struct ContentView: View {
    @State private var snackbar = SnackBar()
    
    var body: some View {
        VStack {
            Spacer()
            Button("Get Started") {
                Task {
                    do {
                        // Do something that throws an error.
                    } catch {
                        snackbar.error(error)
                    }
                }
            }
            Spacer()
        }
        .snackbar(snackbar)
    }
}

#Preview {
    ContentView()
}
```

### Nested Snackbar
The Snackbar uses the SwiftUI view hierarchy and environment features. This means that when you add a message to the 
snackbar it will look for the nearest snacbar in the view hierarchy. If you want error messages to be displayed at the 
bottom of the sheet it's recommended to create a new snackbar on the sheet, e.g.:

In the presenting view:
```
.sheet(isPresented: .constant(true)) {
    NavigationStack {
        MySheetView()
    }
    .snackbar()
}

```
In the presenting view, add `@Environment(\.snackbar) private var snackbar` and you're all set.

## Contributing
If there's a feature you'd like to see added, submit an issue or a pull request.
