//
//  ListViewModelTests.swift
//  GitReposTests
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import XCTest
@testable import GitRepos

class ListViewModelTests: XCTestCase {

    var listViewModel: ListViewModel!
    var fakeApiTask: FakeApiTask!
    
    override func setUpWithError() throws {
        
        fakeApiTask = FakeApiTask()
        listViewModel = ListViewModel(gitHubApi:GitHubApi(apiTask:fakeApiTask ), entities:ListEntities(entryEntity: ListEntryEntity(language: "Swift")) , view: nil)
    }

 
    func testFetchSearch_success() {
        
        fakeApiTask.responceType = "search_responce_success"
        let request = SearchLanguageRequest(language:Constants.searchedRepoKeyWord, page:1)

        listViewModel?.fetchSearch(request: request)
        
        
        XCTAssertEqual(        listViewModel?.entities?.gitHubRepositories.count
, 30)
        
        XCTAssertNil(listViewModel.error)
    }
    
    func testOnReachBottom_success() {
        
        fakeApiTask.responceType = "search_responce_success"

        let request = SearchLanguageRequest(language:Constants.searchedRepoKeyWord, page:1)

        listViewModel?.fetchSearch(request: request)
        
        listViewModel?.onReachBottom()
        
        
        XCTAssertEqual(        listViewModel?.entities?.gitHubRepositories.count
, 60)
        
        XCTAssertNil(listViewModel.error)

    }
    
    func testFetchSearch_failure() {

        fakeApiTask.responceType = "search_responce_failure"

        let request = SearchLanguageRequest(language:Constants.searchedRepoKeyWord, page:1)

        listViewModel?.fetchSearch(request: request)


        XCTAssertEqual(        listViewModel?.entities?.gitHubRepositories.count
, 0)
        
        XCTAssertEqual(listViewModel.error , ApiError.recieveErrorHttpStatus)

    }
    
    func testGetRepo_failure_parsing_error() {

        fakeApiTask.responceType = "search_responce_wrong_responce"

        let request = SearchLanguageRequest(language:Constants.searchedRepoKeyWord, page:1)

        listViewModel?.fetchSearch(request: request)


        XCTAssertEqual(        listViewModel?.entities?.gitHubRepositories.count
, 0)
        
        XCTAssertEqual(listViewModel.error , ApiError.failedParse)
    }
    
    func testGetRepo_failure_status_code_404() {

        fakeApiTask.responceType = "file_not_found_status_code_404"

        let request = SearchLanguageRequest(language:Constants.searchedRepoKeyWord, page:1)

        listViewModel?.fetchSearch(request: request)


        XCTAssertEqual(        listViewModel?.entities?.gitHubRepositories.count
, 0)
        
        XCTAssertEqual(listViewModel.error , ApiError.customError(404))
    }

    func testGetRepo_internal_server__failure_status_code_500() {

        fakeApiTask.responceType = "internal_server_error_status_code_500"

        let request = SearchLanguageRequest(language:Constants.searchedRepoKeyWord, page:1)

        listViewModel?.fetchSearch(request: request)


        XCTAssertEqual(        listViewModel?.entities?.gitHubRepositories.count
, 0)
        
        XCTAssertEqual(listViewModel.error , ApiError.customError(500))
    }

}
