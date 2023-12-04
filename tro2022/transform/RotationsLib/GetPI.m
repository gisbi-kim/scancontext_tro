% Return the value of pi in the required type
function PI = GetPI(in)
	if nargin < 1
		PI = pi;
		return
	end
	switch class(in(1))
		case 'hpf'
			PI = hpf('pi', in(1).NumberOfDigits);
		otherwise
			PI = pi;
	end
end
% EOF