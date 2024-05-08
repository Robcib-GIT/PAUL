% Returns a random number in an interval (a,b).
%
% r = randBtw(a, b, m, n)
% Parameters:
%   (a,b): ends of the interval (a vector can be given).
%   (m,n): dimensions of the matrix to be returned. If only
%   m is specified, a square matrix mxm is returned.
function r = randBtw(a, b, m, n)

    % If the first argument is a vector, then a and b are considered to be given.
    if length(a) > 1
        b = a(end);
        a = a(1);
        extraParams = 1;
    else
        extraParams = 0;
    end
    
    % As in rand, if no columns are specified, it is assumed matrix square,
    % and if nothing is specified, integer
    if nargin == (3 - extraParams)
        n = m;
    elseif nargin == (2 - extraParams)
        m = 1;
        n = 1;
    end
    
    r = a + (b-a)*rand(m, n);
end