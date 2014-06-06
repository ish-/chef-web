chef.directive 'dependLocation', ($rootScope, $location) ->
  require: '?^ngModel'
  link: (scope, element, attrs, ngModelCtrl) ->
    _class = attrs.dependLocationClass || 'active'
    _re = new RegExp attrs.dependLocation


    do onLocationChange = ->
      element.toggleClass _class, !!(matched = $location.url().match _re)
      if ngModelCtrl and matched
        ngModelCtrl.$setViewValue matched[1], yes

    unwatch = $rootScope.$on '$locationChangeStart', onLocationChange
    scope.$on '$destroy', ->
      unwatch()