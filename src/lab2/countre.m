% COUNTRE Count regular expressions
%    [CNT,NUM] = COUNTRE('DIRECTORY',{'REGEXP',...})
%
%    Count how often a regular expression occured in the files 
%    listed in DIR
%
%    Parameters:  
%       DIR - The directory in which to look for the text files
%       RE  - The cell array of regular expressions
%
%    Returns:
%       CNT - an array with the counts for each regexp
%       NUM - The total number of files

function [CNT,NUM] = countre(DIR, RE)
  N=size(RE,2);

  FILES = dir(DIR);
  NUM=size(FILES,1)-2; % Discard '.' and '..'
  
  CNT = zeros(1,N);
  for n = 3:size(FILES,1)
    CNT = CNT + presentre([DIR '/' FILES(n).name], RE);
  end
  CNT = CNT/NUM;                  
end
