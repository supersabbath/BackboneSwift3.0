//
//  Repositories.swift
//  BackboneSwift
//
//  Created by Fernando Canon on 30/01/2017.
//  Copyright © 2017 Alphabit. All rights reserved.
//

import UIKit
import BackboneSwift

class Repo : Model {
    
    var name: String = ""
    /*
    full_name: "PerfectlySoft/Perfect",
    owner: {
    login: "PerfectlySoft",
    id: 14945043,
    avatar_url: "https://avatars.githubusercontent.com/u/14945043?v=3",
    gravatar_id: "",
    url: "https://api.github.com/users/PerfectlySoft",
    html_url: "https://github.com/PerfectlySoft",
    followers_url: "https://api.github.com/users/PerfectlySoft/followers",
    following_url: "https://api.github.com/users/PerfectlySoft/following{/other_user}",
    gists_url: "https://api.github.com/users/PerfectlySoft/gists{/gist_id}",
    starred_url: "https://api.github.com/users/PerfectlySoft/starred{/owner}{/repo}",
    subscriptions_url: "https://api.github.com/users/PerfectlySoft/subscriptions",
    organizations_url: "https://api.github.com/users/PerfectlySoft/orgs",
    repos_url: "https://api.github.com/users/PerfectlySoft/repos",
    events_url: "https://api.github.com/users/PerfectlySoft/events{/privacy}",
    received_events_url: "https://api.github.com/users/PerfectlySoft/received_events",
    type: "Organization",
    site_admin: false
    },
    private: false, */
    var html_url: String = ""
    var score:Int = 0
}


class Repositories: BaseCollection <Repo> {

  
}
