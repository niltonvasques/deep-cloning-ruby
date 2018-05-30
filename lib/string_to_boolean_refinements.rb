# This module add refinements to cast string to boolean
module StringToBooleanRefinements
  refine String do
    def to_bool
      return true  if self == true  || self =~ /(true|t|yes|y|1|on)$/i
      return false if self == false || nil? || strip.empty? || self =~ /(false|f|no|n|0|off)$/i
      raise ArgumentError, "invalid value for Boolean: \"#{self}\""
    end
  end
end
