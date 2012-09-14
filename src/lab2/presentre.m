% PRESENTRE Check whether regular expressions occur in a text file
%    PRESENT = PRESENTRE('FILE',{'REGEXP',...})
%
%    Count whether a regular expression occurs in the given file
%
%    Parameters:  
%       FILE - The text files to check
%       RE   - The cell array of regular expressions
%
%    Returns:
%       PRESENT - an array with ones for the regexp that are present

function PRESENT = countre(FILE, RE)
  N=size(RE,2);

  PRESENT = zeros(1,N);
  text = textread(FILE, '%s','whitespace','','bufsize',65536);

  for i = 1:N                   
    if regexp(text{1},RE{i},'ignorecase')
      PRESENT(i) = 1;
    end
  end
end
