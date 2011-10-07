$:.unshift File.dirname(__FILE__)

# Turn objects into AR records on command
require 'core_extensions/objectify'

# Actually activate them.
Object.send(:include, TurboLabsCore::Objectify::Object)
Class.send(:include, TurboLabsCore::Objectify::Class)


# TODO: the rest here pulled from zen_fleet/lib/zenfleet

