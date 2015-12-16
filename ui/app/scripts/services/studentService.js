'use strict';

/**
 * @ngdoc service
 * @name studentSearchApp.StudentService
 * @description
 * # StudentService
 * Service in the studentSearchApp.
 */
angular.module('studentSearchApp')
  .service('StudentService', function ($http, configuration) {
    this.getStudentById = function(id) {
      return $http({
        method: "GET",
        url: configuration.restUrl + "students/" + id
      });
    }

    this.search = function(search) {
      return $http({
        method: "GET",
        url: configuration.restUrl + "students", 
        params: search
      });
    }
  });
