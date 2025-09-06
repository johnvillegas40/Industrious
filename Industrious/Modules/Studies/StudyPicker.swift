import SwiftUI
import CoreData

struct StudyPicker: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Study.title, ascending: true)])
    private var studies: FetchedResults<Study>
    @Binding var selection: Set<Study>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(studies, id: \.id) { study in
                Button(action: {
                    if selection.contains(study) {
                        selection.remove(study)
                    } else {
                        selection.insert(study)
                    }
                }) {
                    HStack {
                        Text(study.title)
                        if selection.contains(study) {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationTitle("Studies")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct StudyPicker_Previews: PreviewProvider {
    static var previews: some View {
        StudyPicker(selection: .constant([]))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
