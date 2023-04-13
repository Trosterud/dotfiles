function lint 
    lein bikeshed && clj-kondo --lint src test && lein cljstyle fix
end
