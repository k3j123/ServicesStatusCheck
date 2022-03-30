import SwiftUI

struct ServiceStatusView: View {
    
    @StateObject var serviceStatusViewModel = ServiceStatusViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("Background").opacity(0.5), Color("Background")]), startPoint: .bottom, endPoint: .top)
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geo in
                    ScrollView {
                        VStack {
                            Divider().padding(.horizontal)
                            ForEach(serviceStatusViewModel.slackSystemStatus.first?.slackSystemService ?? []) { status in
                                
                            }
                            Spacer()
                        }
                        .task {
                            serviceStatusViewModel.slackSystemStatus = await serviceStatusViewModel.fetchSlackSystemStatus(0)
                        }
                    }
                }
            }
            .navigationTitle("Slack Service Status")
        }
    }
}

struct CloudKitStatusCardView: View {
    
    let geo: GeometryProxy
    let status: SlackSystemService
    let circleSize: CGFloat = 50
    
    @State var isAnimating = false
    
    var body: some View {
        VStack {
            
        }
    }
}

struct AffectedServiceStatusView: View {
    let string: String
    let status: String
    
    var body: some View {
        HStack {
            Text(string)
            Spacer()
            Text(status)
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .padding(.vertical, 0.04)
        .padding(.horizontal, 25)
    }
}

func formatDate(date: Date) -> String {
    let date = date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: date)
}

struct ServiceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceStatusView()
        ServiceStatusView().colorScheme(.dark)
    }
}
