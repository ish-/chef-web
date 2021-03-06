chef.controller 'NodeController', class NodeController
  constructor: (@$scope, @provision, @$routeParams) ->
    $scope.$on 'node:reload', @getNode
    $scope.node = do ($scope.getNode = @getNode)
    $scope.updateRunList = @updateRunList


  getNode: (force = false) => 
    @provision.nodes
      data:
        name: @$scope.name or @$routeParams.name
      force: force

  updateRunList: (runList) =>
    run_list = runList.map (v) ->
      v.essence + '[' + v.name + ']'
    update = @provision.nodes
      method: 'PUT'
      data:
        name: @$scope.node.name
        run_list: run_list