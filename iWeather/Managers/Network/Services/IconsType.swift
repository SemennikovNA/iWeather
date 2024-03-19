//
//  IconsType.swift
//  iWeather
//
//  Created by Nikita on 19.03.2024.
//

import Foundation

enum Icons {
    
    case skc_d
    case skc_n
    case fg_d
    case fg_n
    case bkn_d
    case bkn_n
    case bkn__da_d
    case bkn__ra_n
    case bkn__sn_d
    case bkn__sn_n
    case bkn_ra_d
    case bkn_ra_n
    case bkn_sn_d
    case bkn_sn_n
    case bkn___ra_d
    case bkn___ra_n
    case bkn___sn_d
    case bkn___sn_n
    case ovc_ts
    case ovc_ts_ra
    case ovc_ts_ha
    case ovc
    case ovc___ra
    case ovc___sn
    case ovc_ra
    case ovc_sn
    case ovc__ra
    case ovc__sn
    case ovc_ra_sn
    case ovc_ha
    case _bl
    case bl
    case dst
    case du_st
    case smog
    case strm
    case vlka

    enum CondingKeys: String, CodingKey {
        case bkn__ra_d = "bkn_-ra_d"
        case bkn__ra_n = "bkn_-ra_n"
        case bkn__sn_d = "bkn_-sn_d"
        case bkn__sn_n = "bkn_-sn_n"
        case bkn___ra_d = "bkn_+ra_d"
        case bkn___ra_n = "bkn_+ra_n"
        case bkn___sn_d = "bkn_+sn_d"
        case bkn___sn_n = "bkn_+sn_n"
        case ovc___ra = "ovc_-ra"
        case ovc___sn = "ovc_-sn"
        case ovc__ra = "ovc_+ra"
        case ovc__sn = "ovc_+sn"
        case _bl = "-bl"
    }
    
    private var baseURL: String {
        return "https://yastatic.net/weather/i/icons/funky/light/"
    }
    
    private var path: String {
        
        switch self {
        case .skc_d:
            return "skc_d.svg"
        case .skc_n:
            return "skc_n.svg"
        case .fg_d:
            return "fg_d.svg"
        case .fg_n:
            return "fg_n.svg"
        case .bkn_d:
            return "bkn_d.svg"
        case .bkn_n:
            return "bkn_n.svg"
        case .bkn__da_d:
            return "bkn_n.svg"
        case .bkn__ra_n:
            return "bkn_-ra_n.svg"
        case .bkn__sn_d:
            return "bkn_-sn_d.svg"
        case .bkn__sn_n:
            return "bkn_+sn_n.svg"
        case .bkn_ra_d:
            return "bkn_ra_d.svg"
        case .bkn_ra_n:
            return "bkn_ra_n.svg"
        case .bkn_sn_d:
            return "bkn_sn_d.svg"
        case .bkn_sn_n:
            return "bkn_sn_n.svg"
        case .bkn___ra_d:
            return "bkn_+ra_d.svg"
        case .bkn___ra_n:
            return "bkn_+ra_n.svg"
        case .bkn___sn_d:
            return "bkn_+sn_d.svg"
        case .bkn___sn_n:
            return "bkn_+sn_n.svg"
        case .ovc_ts:
            return "ovc_ts.svg"
        case .ovc_ts_ra:
            return "ovc_ts_ra.svg"
        case .ovc_ts_ha:
            return "ovc_ts_ha.svg"
        case .ovc:
            return "ovc.svg"
        case .ovc___ra:
            return "ovc_-ra.svg"
        case .ovc___sn:
            return "ovc_-sn.svg"
        case .ovc_ra:
            return "ovc_ra.svg"
        case .ovc_sn:
            return "ovc_sn.svg"
        case .ovc__ra:
            return "ovc_+ra.svg"
        case .ovc__sn:
            return "ovc_+sn.svg"
        case .ovc_ra_sn:
            return "ovc_ra_sn.svg"
        case .ovc_ha:
            return "ovc_ha.svg"
        case ._bl:
            return "-bl.svg"
        case .bl:
            return "bl.svg"
        case .dst:
            return "dst.svg"
        case .du_st:
            return "du_st.svg"
        case .smog:
            return "smog.svg"
        case .strm:
            return "strm.svg"
        case .vlka:
            return "vlka.svg"
        }
    }
    
    var requestIsons: URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL)!)!
        var requestIcons = URLRequest(url: url)
        
        switch self {
        default:
            requestIcons.httpMethod = HTTPMethod.get.rawValue
            return requestIcons
        }
    }
}
