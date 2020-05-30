//
//  main.swift
//  cronx
//
//  Created by Casper Sørensen on 30/05/2020.
//  Copyright © 2020 Casper Sørensen. All rights reserved.
//

import Foundation

typealias Command = String

func runCommand(forLine: Int, lineDividedCrontab: [Substring], errorOnComment: Bool) {
    let command = parseCrontab(line: forLine, splitCrontab: lineDividedCrontab, errorOnComment: errorOnComment)
    if(command != nil) {
        print("Running command: " + command!)
        print(shell(command!))
    }

}

func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/bash"
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return output
}

func printUsage() -> Void {
    print("""
Usage and help:
Cronx: Cron Execute\nExecute commands from your crontab\n
        
        -a      Execute all commands in your crontab
        -l #    Execute the specified line number (#). Multiple line numbers can be specified seperated by spaces.
        -r #    Read the specified line number (#). Multiple line numbers can be specified seperated by spaces.
        -ra     Read the whole crontab with line numbers
        -h      Print this usage message

To see or edit your crontab please use the crontab command with either -l or -e respectively
""")
}

func parseCrontab(line: Int, splitCrontab: [Substring], errorOnComment: Bool) -> Command? {
    let lineToParse = splitCrontab[line]
    let spaceDividedLine = lineToParse.split(separator: " ")
    var resultingCommand = ""
    if (spaceDividedLine[0] != "#"){
        let commandSubstring = spaceDividedLine.dropFirst(5)
        for i in commandSubstring {
            resultingCommand += i + " "
        }
        return resultingCommand
    }
    else if (errorOnComment) {
        print("The specified line seems to be a comment. Use -r to see the line")
        exit(-1)
    }
    else {
        return Optional.none
    }
}

// Example usage:
let crontab = shell("crontab -l")
let lineDividedCrontab = crontab.split(separator: "\n")

let args = CommandLine.arguments

if (args.count<2) {
    printUsage()
    exit(-1)
}

if (args[1] == "-l") {
    for i in 2..<args.count{
        var line = Int.init(args[i])
        if (line != nil) {
            line! -= 1
            if (line! < lineDividedCrontab.count && line! >= 0) {
                runCommand(forLine: line!, lineDividedCrontab: lineDividedCrontab, errorOnComment: true)
            } else {
                print("Specified line: " + String(line!+1) + ", is out of crontab bounds")
            }
        }
    }
}
else if (args[1] == "-r") {
    for i in 2..<args.count {
        var line = Int.init(args[i])
        if (line != nil) {
            line! -= 1
            if (line! < lineDividedCrontab.count && line! >= 0) {
                print(String(line!+1) + " " + lineDividedCrontab[line!])
            } else {
                print("Specified line: " + String(line!+1) + ", is out of crontab bounds")
            }
        }
    }
}

else if (args.count != 2) {
    print("Cronx currently only takes a single argument, with the exception of -r or -l that also take line numbers. \n")
    printUsage()
}

if (args[1] == "-a") {
    for i in lineDividedCrontab.indices {
        runCommand(forLine: i, lineDividedCrontab: lineDividedCrontab, errorOnComment: false)
    }
}

if (args[1] == "-h") {
    printUsage()
}

if (args[1] == "-ra") {
    for i in 0..<lineDividedCrontab.count {
        print(String((i+1)) + " " + lineDividedCrontab[i])
    }
}

