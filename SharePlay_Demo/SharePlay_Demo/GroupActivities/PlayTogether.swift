//
//  PlayTogether.swift
//  SharePlay_Demo
//
//  Created by ChuanZhen Tu on 3/13/25.
//

import GroupActivities
import CoreTransferable

struct PlayTogether: GroupActivity, Transferable {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = NSLocalizedString("Play Together",
                                           comment: "Set Off the Geyser")
        metadata.type = .generic
        return metadata
    }
}

