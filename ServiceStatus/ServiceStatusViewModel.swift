import Foundation

struct SlackSystemStatus: Codable {
    let slackSystemService: [SlackSystemService]
    
    enum CodingKeys: String, CodingKey {
        case slackSystemService = "slackSystemServices"
    }
}

struct SlackSystemService: Codable, Identifiable {
    let id = UUID()
    let status: String?
    let date_created: String?
    let date_updated: String?
    let active_incidents: [SlackActiveIncidents]

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case date_created = "date_created"
        case date_updated = "date_updated"
        case active_incidents = "active_incidents"
    }
}


struct SlackActiveIncidents: Codable, Identifiable {
    let id = UUID()
    let date_created: String
    let date_updated: String
    let title: String
    let type: String
    let status: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case date_created = "date_created"
        case date_updated = "date_updated"
        case title = "title"
        case type = "type"
        case status = "status"
        case url = "url"
    }
}


class ServiceStatusViewModel: ObservableObject {
    
    @Published var slackSystemStatus: [SlackSystemStatus] = []
        
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    var systemStatusURL = "https://status.slack.com/api/v2.0.0/current"
    
    func fetchSlackSystemStatus(_ urlType: Int) async -> [SlackSystemStatus] {
        
        guard let url = URL(string: systemStatusURL) else {
            return []
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("\(#function) \(response)")
                return []
            }
            
            let statusData = try JSONDecoder().decode(SlackSystemStatus.self, from: data)
            return [statusData]
        } catch {
            showErrorAlert = true
            errorMessage = ("Error: \(error.localizedDescription)")
            print("\(#function) \(error)")
            return []
        }
    }
}
