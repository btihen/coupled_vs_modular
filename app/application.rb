require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

# This is the entry point for this messy application. Lionel didn't want it to be that way.
module Application
end
