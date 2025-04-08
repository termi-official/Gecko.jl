module Gecko

using CxxWrap
using gecko_jll

@wrapmodule(gecko_jll.get_libgeckowrapper_path)

function __init__()
    @initcxx
end

end
