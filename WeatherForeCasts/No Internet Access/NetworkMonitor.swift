import Foundation
import Network
import FirebaseAuth


class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }

    
    func startMonitoring(with action: @escaping (NWPath) -> Void) {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            DispatchQueue.main.async {
                action(path)
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

    }

    func stopMonitoring() {
        monitor.cancel()
    }
    func checkConnection() {
        startMonitoring { path in
            if path.status == .satisfied {
                print("We're connected!")
                print("isReachable: \(self.isReachable)")

            } else {
                print("No connection.")
                print("isReachable: \(self.isReachable)")

//                AppDelegate.scene?.routeToNoInternetAccess()

                if UserDefaults.standard.hasOnboarded {
                    if Auth.auth().currentUser != nil {
                        AppDelegate.scene?.goToMain()
                    } else {
                        AppDelegate.scene?.routeToNoInternetAccess()
                    }
                }  else {
                    AppDelegate.scene?.routeToNoInternetAccess()
                }
            }
        }
    }
}
