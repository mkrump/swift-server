public func dirListing(target: String, directories: [String]) -> String {
    let dirs = directories.map({ "<li> <a href=/" + $0 + ">" + $0 + "</a></li>" })
    let dirList = "<!DOCTYPE html \"><html>" +
            "<title>Directory listing for " + target + "</title>" +
            "<h2>Directory listing for /</h2>" +
            "<body>" +
            "<ul>" +
            dirs.joined(separator: "\n") +
            "</ul>" +
            "</body>" +
            "</html>"
    return dirList
}
