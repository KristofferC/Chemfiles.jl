# Copyright (c) Guillaume Fraux 2015
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

type ChemfilesError <: Exception
    message::AbstractString
end
Base.show(io::IO, e::ChemfilesError) = show(io, "Chemfiles error: $(e.message)")
export ChemfilesError

function check(result::Integer, message = "Unknown error")
    if result != 0
        str = message
        try
            str = last_error()
        end
        throw(ChemfilesError(str))
    end
    return nothing
end

function check(result::Ptr, message = "Unknown error")
    if Int(result) == 0
        str = message
        try
            str = bytestring(lib.chfl_strerror(result))
        end
        throw(ChemfilesError(str))
    end
    return nothing
end

"""
These functions are not exported, and should be called by there fully qualified name:
    Chemfiles.last_error()
    Chemfiles.loglevel(Chemfiles.ERROR)
"""

function last_error()
    bytestring(lib.chfl_last_error())
end

function strerror(status::Integer)
    bytestring(lib.chfl_strerror(Cint(status)))
end

function loglevel(level::LogLevel)
    check(
        lib.chfl_loglevel(level)
    )
    return nothing
end

function logfile(file::AbstractString)
    check(
        lib.chfl_logfile(pointer(file))
    )
    return nothing
end

function log_to_stderr()
    check(
        lib.chfl_log_stderr()
    )
    return nothing
end
