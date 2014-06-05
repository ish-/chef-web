chef.controller 'RoleController', class RoleController
  constructor: (@$scope, @provision, @$routeParams) ->
    $scope.$on 'role:reload', @getRole
    $scope.role = do ($scope.getRole = @getRole)
    $scope.updateRunList = @updateRunList

    $scope.filterRole = (name) ->
      $scope.role.name isnt name

  getRole: (force = false) => 
    @provision.roles
      data:
        name: @$scope.name or @$routeParams.name
      force: force


  updateRunList: (runList) =>
    run_list = runList.map (v) ->
      v.essence + '[' + v.name + ']'
    update = @provision.roles
      method: 'PUT'
      data:
        name: @$scope.role.name
        run_list: run_list