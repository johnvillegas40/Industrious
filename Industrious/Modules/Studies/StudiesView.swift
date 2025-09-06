import SwiftUI
@_implementationOnly import CoreData
struct StudiesView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Study.title, ascending: true)])
    private var studies: FetchedResults<Study>
    @State private var showingAdd = false
    @State private var newTitle = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(studies, id: \.id) { study in
                    NavigationLink(study.title) {
                        StudyDetailView(study: study)
                    }
                }
            }
            .navigationTitle("Studies")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack {
                    Form {
                        TextField("Title", text: $newTitle)
                        Button("Add") {
                            let study = Study(context: context)
                            study.id = UUID()
                            study.title = newTitle
                            try? context.save()
                            newTitle = ""
                            showingAdd = false
                        }
                    }
                    .navigationTitle("New Study")
                }
            }
        }
    }
}

#Preview {
    StudiesView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
