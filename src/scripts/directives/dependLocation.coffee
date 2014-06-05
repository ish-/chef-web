chef.directive 'dependLocation', ($rootScope, $location) ->

  link: (scope, element, attrs) ->
    _class = attrs.dependLocationClass || 'active'
    _re = new RegExp attrs.dependLocation

    $rootScope.$on '$locationChangeStart', ->
      element.toggleClass _class, _re.test $location.url()