import UIKit
import PlaygroundSupport

extension Notification.Name {
    static let HWSSettingsDidChange =
    Notification.Name("HWSSettingsDidChangeNotification")
}

class Controller {
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSettings), name: .HWSSettingsDidChange, object: nil)
    }
    
    @objc func reloadSettings() {
        print("Reloading settings!")
    }
}

let controller = Controller()
print("Before")
let notification = Notification(name: .HWSSettingsDidChange)
NotificationQueue.default.enqueue(notification,
postingStyle: .whenIdle, coalesceMask: .none, forModes: nil)
PlaygroundPage.current.needsIndefiniteExecution = true
print("After")
