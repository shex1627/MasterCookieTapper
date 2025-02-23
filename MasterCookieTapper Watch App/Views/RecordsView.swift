import SwiftUI

struct RecordsView: View {
    @Binding var records: [GameRecord]
    
    var body: some View {
        List {
            ForEach(records) { record in
                HStack {
                    VStack(alignment: .leading) {
                        Text(String(format: "Time: %.1f seconds", record.completionTime))
                            .font(.headline)
                        Text(record.date, style: .date)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if let index = records.firstIndex(where: { $0.id == record.id }) {
                            records.remove(at: index)
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            if !records.isEmpty {
                HStack {
                    Spacer()
                    Button(action: {
                        records.removeAll()
                    }) {
                        Text("Reset All Records")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}