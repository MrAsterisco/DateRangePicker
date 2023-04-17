//
//  File.swift
//  
//
//  Created by Alessio Moiso on 17.04.23.
//

import Foundation

/// The availability of a date in the context.
enum DateValidity {
        /// The date is invalid for the context and should be hidden.
  case  hidden,
        /// The date is outside of existing constraints set by the context.
        unavailable,
        /// The date is valid for the context.
        available
}
