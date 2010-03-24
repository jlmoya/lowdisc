
// lowdisc_rem --
//  Remainder after division.
//
function r = lowdisc_rem ( X , Y )
  r = X - fix ( X ./ Y ) .* Y
endfunction

