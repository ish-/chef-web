chef.controller 'TabListController', ($scope, $location) ->
  $scope.tab = ''
  $scope.$on '$locationChangeStart', () ->
    if matched = $location.url().match /^\/([\w]*)\//
      $scope.tab = matched[1]