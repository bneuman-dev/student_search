'use strict';

/**
 * @ngdoc overview
 * @name studentSearchApp
 * @description
 * # studentSearchApp
 *
 * Main module of the application.
 */
angular
  .module('studentSearchApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.router',
    'services.config'
  ])
  .config(function ($urlMatcherFactoryProvider, $stateProvider) {
    $urlMatcherFactoryProvider.strictMode(false);
    $urlMatcherFactoryProvider.caseInsensitive(true);
 
    $stateProvider
      .state('main', {
        url: '',
        onEnter: function($state) {
          $state.go('search');
        }
      })
      .state('search', {
        url: '/search?first_name&last_name',
        templateUrl: 'views/search.html',
        controller: 'SearchCtrl',
        controllerAs: 'search',
        resolve: {
          searchResponse: function($stateParams, StudentService) {
            if ($stateParams.first_name || $stateParams.last_name) {
              return StudentService.search({
                'first_name': $stateParams.first_name,
                'last_name': $stateParams.last_name
              });
            } else {
              return false;
            }
          }
        }
      })
      .state('student', {
        url: '/students/:id',
        templateUrl: 'views/student.html',
        controller: 'StudentCtrl',
        controllerAs: 'studentDetails',
        resolve: {
          studentResponse: function($stateParams, StudentService) {
            return StudentService.getStudentById($stateParams.id);
          }
        }
      })
      .state('error', {
        url: '/error',
        templateUrl: 'views/errors.html',
        controller: 'ErrorCtrl',
        controllerAs: 'errorHandler',
        resolve: {
          error: function(ErrorService) {
            return ErrorService.getError();
          }
        }
      })
      .state('otherwise', {
        url: '*path',
        controller: function($location, $state, ErrorService) {
          
          ErrorService.setError({
            message: "No such URL: " + $location.url(),
            status: "404"
          });

          $state.go('error');
        }
      })
      
  })
  .run(function($rootScope, $log, $stateParams, $state, ErrorService) {
    $rootScope.$stateParams = $stateParams;

    $rootScope.$on('$stateNotFound', function(event, unfoundState, fromState, fromParams) {
      $log.error('$stateNotFound ' + unfoundState.to + '  - fired when a state cannot be found by its name.');
      $log.error(unfoundState, fromState, fromParams);
    });

    $rootScope.$on('$stateChangeError', function(event, toState, toParams, fromState, fromParams, error) {
      event.preventDefault();
    
      // If API call returns error code in resolve, catch it here and redirect to error page
      if (error.data) {
        ErrorService.setError({
          message: error.data.message,
          status: error.status
        });
      } else {
        ErrorService.setError({
          message: "Error connecting to the API",
          status: 500
        });
      }

      $state.go('error');  
    });
  });
