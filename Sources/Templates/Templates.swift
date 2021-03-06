import Foundation
import SimpleURL

public func echoParams(params: [String: String]) -> String {
    let paramListArray = params.map { (key, value) in
        "<li>" + key + " = " + value + "</li>"
    }
    let paramListItems = paramListArray.joined(separator: "\n")
    let html = "<!DOCTYPE html \"><html>" +
            "<title>Echo </title>" +
            "<body>" +
            paramListItems +
            "</body>" +
            "</html>"
    return html
}

public func basicTemplate(message: String) -> String {
    let html = "<!DOCTYPE html \"><html>" +
            "<body>" +
            "<p>\(message)</p>" +
            "</body>" +
            "</html>"
    return html
}

public func dirListing(url: simpleURL, directories: [String]) -> String {
    let baseName = url.baseName == "/" ? "" : url.baseName
    let dirs = directories.map({ "<li> <a href=\(baseName)/\($0)>\($0)</a></li>" })
    let dirListItems = "<ul>" + dirs.joined(separator: "\n") + "</ul>"
    let dirList = "<!DOCTYPE html \"><html>" +
            "<title>Directory listing for \(url.baseName) </title>" +
            "<h2>Directory listing for \(url.baseName) </h2>" +
            "<body> \(dirListItems) </body>" +
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
