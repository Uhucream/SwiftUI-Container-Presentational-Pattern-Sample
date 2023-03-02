import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            ToDoListViewContainer()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
