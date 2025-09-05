import SwiftUI
import CoreData

struct StudyPicker: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Study.title, ascending: true)])
    private var studies: FetchedResults<Study>
    @Binding var selection: Study?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(studies, id: \.id) { study in
                Button(action: {
                    selection = study
                    dismiss()
                }) {
                    HStack {
                        Text(study.title)
                        if selection == study {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationTitle("Studies")
        }
    }
}

struct StudyPicker_Previews: PreviewProvider {
    static var previews: some View {
        StudyPicker(selection: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
