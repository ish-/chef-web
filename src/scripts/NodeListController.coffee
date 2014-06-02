chef.controller 'NodeListController', ($scope, $location, provision) ->
  do $scope.getNodes = (force = false) ->
    if force
      $scope.$broadcast 'node:reload'
    $scope.nodes = provision.nodes force: force

  $scope.showNode = (name) -> $location.path '/nodes/' + name
