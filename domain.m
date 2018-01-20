function out = domain(varargin)
%DOMAIN  fake constructor for a fake DOMAIN class.
  for i=1:nargin
    varargin{i} = double(varargin{i});
  end
  out = horzcat(varargin{:});
end
