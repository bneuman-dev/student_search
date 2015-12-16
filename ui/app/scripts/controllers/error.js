'use strict';

/**
 * @ngdoc function
 * @name studentSearchApp.controller:ErrorCtrl
 * @description
 * # ErrorCtrl
 * Controller of the studentSearchApp
 */
angular.module('studentSearchApp')
  .controller('ErrorCtrl', function ($scope, $location, error) {
    var _this = this;
    
    // so clicking 'back' doesn't cause a loop
    $location.replace();

    if (_.isEmpty(error)) {
      _this.errorMessage = "Unknown error occurred";
    } else {
      _this.errorMessage = error.status + " error - " + error.message;
    }
  });
