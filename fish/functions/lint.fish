function lint 
    lein bikeshed && clj-kondo --lint src test
end
