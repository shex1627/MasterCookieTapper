import SwiftUI

struct RecordsView: View {
    let records: [GameRecord]
    
    var body: some View {
        List {
            ForEach(records) { record in
                VStack(alignment: .leading) {
                    Text(String(format: "Time: %.1f seconds", record.completionTime))
                        .font(.headline)
                    Text(record.date, style: .date)
                        .font(.caption)
                }
            }
        }
    }
}