import Foundation

public func imATeapot() -> String {
    let html = "<!DOCTYPE html \"><html>" +
            "<title>418 </title>" +
            "<body>" +
            "<p>I'm a teapot</p>" +
            "</body>" +
            "</html>"
    return html
}

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

public func generateForm(target: String, data: Data = Data()) -> String {
    let formText = String(data: data, encoding: String.Encoding.utf8) ?? ""
    let form = "<!DOCTYPE html \"><html>" +
            "<body>" +
            "<form action=\"" + target.substring(from: target.index(after: target.startIndex)) +
            "\" name=\"confirmationForm\" method=\"post\">" +
            "<textarea id=\"confirmationText\" class=\"text\" style=\"width:50%; height: 80px;\"" +
            "maxlength=\"300\" name=\"formData\"></textarea>" +
            "<br>" +
            "<input type=\"submit\" value=\"Submit\" class=\"submitButton\">" +
            "</form>" +
            "<p>Current values: " + formText + "</p>" +
            "</body>" +
            "</html>"
    return form
}
