'use strict';

/**
 * @ngdoc function
 * @name studentSearchApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the studentSearchApp
 */
angular.module('studentSearchApp')
  .controller('SearchCtrl', function ($stateParams, $state, $scope, searchResponse) {
    var _this = this;
    
    _this.searchResult = {};
    _this.searchParams = {};

    _this.messages = {
      noSearchResults: "No search results found",
      searchInstructions: "Enter first name and/or last name above to search for a student",
      noGPA: "n/a"
    };

    function _init() {
      if (searchResponse) {
        _this.searchResult.students = searchResponse.data;
        _this.messages.searchActionText = "Search again";
      } else {
        _this.messages.searchActionText = "Search";
      }

      _this.searchParams.first_name = $stateParams.first_name;
      _this.searchParams.last_name = $stateParams.last_name;
    }
   
    _init();
    
    _this.getGPA = function(student) {
      if (student.gpa) {
        return student.gpa;
      } else {
        return _this.messages.noGPA;
      }
    }

    _this.isNewSearch = function() {
      return _.isEmpty(_this.searchResult);
    }

    _this.isEmptySearchResult = function() {
      return _.isEmpty(_this.searchResult.students);
    }
  });
