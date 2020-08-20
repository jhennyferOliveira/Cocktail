//
//  FileHelper.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 20/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation

struct FileHelper {
    let manager = FileManager.default
    let mainPath  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    //MARK: - Create a new directory on the documents by default, or on the choosen path
    func createDirectory(with name: String, at path: String? = nil) {
        let contentPath = constructPath(named: name, from: path)
        if !directoryExists(with: name, at: path) {
            do {
                try manager.createDirectory(at: contentPath, withIntermediateDirectories: true, attributes: nil)
            } catch (let error) { print(error.localizedDescription) }
        }
    }
    //MARK: - Remove directory and all of it's contents
    func removeDirectory(named: String, at path: String? = nil) -> Bool {
        let dirPath = constructPath(named: named, from: path)
        do {
            try manager.removeItem(at: dirPath)
            return !manager.fileExists(atPath: dirPath.path)
        } catch (let error) {
            print(error.localizedDescription)
            return false
        }
    }
    //MARK: - Check if the directory exists
    func directoryExists(with name: String, at path: String? = nil) -> Bool {
        let dirPath = constructPath(named: name, from: path)
        var isDirectory = ObjCBool(true)
        return manager.fileExists(atPath: dirPath.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
    //MARK: - Move file to another directory
    func moveFileNewDirectory(at path: URL, directoryNamed: String){
        createDirectory(with: directoryNamed)
        let list = path.pathComponents
        let newPath = constructPath(named: directoryNamed + "/" + list[list.count - 1])
        do{
            try FileManager.default.moveItem(at: path,
                                             to: newPath )
        } catch{
            print(error.localizedDescription)
        }
    }
    func removeAllFilesFromDirectory(directoryName: String){
        let contents = contentsForDirectory(atPath: directoryName)
        for content in contents{
            let path = constructPath(named: directoryName + "/" + content)
            do{
                try manager.removeItem(at: path)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    //MARK: - Get the content of directory
    func contentsForDirectory(atPath path: String) -> [String] {
        let contentPath = constructPath(named: path)
        let itens = try? manager.contentsOfDirectory(atPath: contentPath.path)
        return itens ?? []
    }
    func fullPathForContents(at directory: String) -> [String] {
        let contentPath = constructPath(named: directory)
        guard let itens = try? manager.contentsOfDirectory(atPath: contentPath.path) else {
            return []
        }
        return itens.map { "\(contentPath.path)/\($0)"}
    }
    @discardableResult
    func createFile(with data: Data, name: String) -> Bool {
        let contentPath = constructPath(named: name)
        manager.createFile(atPath: contentPath.path, contents: data, attributes: nil)
        return manager.fileExists(atPath: contentPath.path)
    }
    @discardableResult
    func removeFile(at path: String) -> Bool {
        let contentPath = constructPath(named: path)
        do {
            try manager.removeItem(at: contentPath)
            return !manager.fileExists(atPath: contentPath.path)
        } catch (let error) {
            print(error.localizedDescription)
            return false
        }
    }
    @discardableResult
    func updateFile(at path: String, data: Data) -> Bool {
        let contentPath = constructPath(named: path)
        do {
            try data.write(to: contentPath)
            return true
        } catch (let error) {
            print(error.localizedDescription)
            return false
        }
    }
    func retrieveFile(at path: String) -> Data? {
        let contentPath = constructPath(named: path)
        let data = try? Data(contentsOf: contentPath)
        return data
    }
    func constructPath(named: String, from path: String? = nil) -> URL {
        let contentPath = mainPath
        if let path = path {
            return contentPath.appendingPathComponent(path).appendingPathComponent(named)
        } else {
            return contentPath.appendingPathComponent(named)
        }
    }
}
