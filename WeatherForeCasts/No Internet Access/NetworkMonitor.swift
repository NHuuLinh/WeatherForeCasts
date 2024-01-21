import Foundation
import Network
import FirebaseAuth


final class NetworkMonitor {
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }

//    func startMonitoring1() {
//        monitor.pathUpdateHandler = { [weak self] path in
//            self?.status = path.status
//
//            if path.status == .satisfied {
//                print("We're connected!")
//
//            } else {
//                print("No connection.")
//                if Auth.auth().currentUser != nil {
//                    DispatchQueue.main.async {
////                        AppDelegate.scene?.goToMain()
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        AppDelegate.scene?.routeToNoInternetAccess()
//                    }
//                }
//            }
//        }
//        let queue = DispatchQueue(label: "NetworkMonitor")
//        monitor.start(queue: queue)
//    }
    func checkConnection() {
        startMonitoring { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
                if Auth.auth().currentUser != nil {
//                        AppDelegate.scene?.goToMain()
                } else {
                        AppDelegate.scene?.routeToNoInternetAccess()
                }
            }
        }
    }
    func startMonitoring(with action: @escaping (NWPath) -> Void) {
        let monitor = NWPathMonitor()
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
}
