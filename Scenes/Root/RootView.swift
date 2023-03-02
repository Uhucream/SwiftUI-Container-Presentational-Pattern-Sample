import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            ToDoListViewContainer()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
