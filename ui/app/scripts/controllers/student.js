'use strict';

/**
 * @ngdoc function
 * @name studentSearchApp.controller:StudentdetailsCtrl
 * @description
 * # StudentdetailsCtrl
 * Controller of the studentSearchApp
 */
angular.module('studentSearchApp')
  .controller('StudentCtrl', function ($scope, studentResponse) {
    var _this = this;

    _this.student = {};
    
    _this.messages = {
      noCoursesTaken: "Student has not taken any courses yet."
    }

    function _init() {
      if (studentResponse) {
        _this.student = studentResponse.data;
      }
    }

    _init();
    
    _this.noCoursesTaken = function() {
      return _.isEmpty(_this.student.courses);
    }
  });
