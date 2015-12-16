'use strict';

/**
 * @ngdoc service
 * @name studentSearchApp.Error
 * @description
 * # Error
 * Service in the studentSearchApp.
 */
angular.module('studentSearchApp')
  .service('ErrorService', function () {
    this.error = {};

    this.setError = function(error) {
      this.error = error;
    }
    
    this.getError = function() {
      return this.error;
    }
  });
