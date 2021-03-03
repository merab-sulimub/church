//Created for churchApp  (07.11.2020 )

import Foundation
import RealmSwift
import AVFoundation


struct AppConfigurator {
    
    static func realmSetup() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 11,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        
        // fetch url patch & print it
        do {
            let realm = try Realm()
            
            print("✅ Realm URL: \(realm.configuration.fileURL?.absoluteString ?? "not URL found")")
            
        } catch {
            print(error)
            fatalError("❌ Realm URL: Realm can't be init() ")
        }
         
        
    }
    
    
    // set category for AVAudioSession
    static func setupAVAudioSession() {
        
        do {
            //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            
            // .ambient and .mixWithOthers so silent video won't interrupt background music
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.mixWithOthers, .allowBluetoothA2DP, .defaultToSpeaker])
            
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
        }
        catch {
            print("❌ Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
}
